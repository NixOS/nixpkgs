"""Build and install a Flutter macOS app bundle without Xcode or CocoaPods.

build-flutter-application.nix invokes this as `macos-build.py build` inside
buildPhase and `macos-build.py install` inside installPhase; runHook stays in
Nix so the stdenv hooks keep working.  All configuration arrives through
environment variables:

    flutterMode       release, debug or profile
    flutterFlags      extra flags for the flutter tool (space separated)
    macosBuildFlags   the user's flutterBuildFlags, one per line
    macosSdkroot      the nixpkgs macOS SDK
    macosRunnerMain   programmatic Swift main for template projects
    macosRunnerObjc   ObjC fallback main for projects without Swift sources
    macosXcrunBridge  xcrun shim that must shadow xcbuild's on PATH

The $out and $debug output paths are exported by the stdenv like any other
derivation variable.

Everything lives in one file so collect() can hand its results to the
compiler invocations as a Collected record instead of through intermediate
files.
"""

import base64
import glob
import json
import logging
import os
import plistlib
import re
import shlex
import shutil
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path
from urllib.parse import unquote, urlparse

import yaml

# Warnings go to stderr, where nix builders surface them alongside the
# compiler output.
logging.basicConfig(format="%(levelname)s: %(message)s", level=logging.INFO)
log = logging.getLogger(__name__)

_MACOS_PLATFORMS = {"", "osx", "macos"}
# Pods provided by the build itself rather than fetched from CocoaPods:
# the Flutter engine (and, previously, sqlite3, which was injected into every
# macOS build through NIX_CFLAGS_COMPILE/NIX_LDFLAGS).  Plugins that need
# sqlite3 now provide it themselves via package-source-builders (sqflite_darwin
# bakes the nixpkgs headers and dylib into its source tree); a plugin that
# still declares `dependency 'sqlite3'` is skipped, since the build no longer
# supplies it implicitly.
_APPLE_PODS = {"Flutter", "FlutterMacOS"}
# Frameworks/modules that need no explicit `-framework` flag: Foundation,
# Cocoa and AppKit autolink themselves under clang -fmodules, the engine is
# linked by the build, and objc/sqlite3 are libraries rather than frameworks
# (sqflite imports <objc/runtime.h> and <sqlite3/sqlite3.h>; the library
# itself arrives via the plugin's vendored_libraries declaration, see the
# sqflite_darwin builder).
_AUTOLINKED_FRAMEWORKS = {
    "Flutter",
    "FlutterMacOS",
    "Foundation",
    "Cocoa",
    "AppKit",
    "objc",
    "sqlite3",
}
_PIGEON_SYMBOLS = (
    "PigeonError",
    "MessagesPigeonCodec",
    # Pigeon declares the codec class with a lowercase initial (e.g.
    # `class messagesPigeonCodec`), so the uppercase symbol above alone
    # leaves the declaration and its references un-renamed when two Pigeon
    # plugins (url_launcher_macos, path_provider_foundation, ...) compile
    # into the same module.
    "messagesPigeonCodec",
    "deepEqualsmessages",
    "deepHashmessages",
)


def optimization_flags() -> list[str]:
    """Optimization and assertion flags for the C/ObjC compiler, matching
    the build mode.

    Debug builds keep assertions and drop optimization so native crashes
    are debuggable; release and profile ship the optimized, assertion-free
    binary.  (The NDEBUG/NS_BLOCK_ASSERTIONS pair also keeps assert()'s
    implicit __FILE__ out of the shipped binary; work directories are fixed
    paths now, but store paths still must not leak.)"""
    if os.environ["flutterMode"] == "debug":
        return ["-O0"]
    return ["-O", "-DNDEBUG", "-DNS_BLOCK_ASSERTIONS=1"]


def swift_optimization_flags() -> list[str]:
    """The Swift spelling of optimization_flags(): -Onone instead of -O0,
    and no preprocessor defines."""
    return ["-Onone"] if os.environ["flutterMode"] == "debug" else ["-O"]


def run(command: list[str]) -> None:
    print(f"+ {shlex.join(str(argument) for argument in command)}", flush=True)
    subprocess.run(command, check=True)


# ---------------------------------------------------------------------------
# Podspec parsing
# ---------------------------------------------------------------------------


def strip_ruby(text: str) -> str:
    # Protect string literals so stripping // comments and # comments does
    # not eat text that only lives inside them (URLs, glob patterns).
    protected = {}

    def protect(match):
        token = f"\x00{len(protected)}\x00"
        protected[token] = match.group(0)
        return token

    text = re.sub(r"'(?:[^'\\]|\\.)*'|\"(?:[^\"\\]|\\.)*\"", protect, text)
    text = re.sub(r"<<-?(\w+).*?^\s*\1\s*$", "", text, flags=re.DOTALL | re.MULTILINE)
    text = re.sub(r"#.*$", "", text, flags=re.MULTILINE)
    for token, literal in protected.items():
        text = text.replace(token, literal)
    return text


def podspec_value(text: str, attribute: str):
    """Value of the last `s[.<platform>.]<attribute> = ...` that applies.

    The lookbehind keeps subspec assignments (`ss.source_files` inside
    `|ss|` blocks) from matching as the main spec's attribute.  Values may
    span lines (array literals), so the capture runs up to the next line
    starting with an attribute assignment (`s.`) or the podspec's `end`
    keyword.  This mirrors how CocoaPods terminates attribute values, and
    standard podspecs are written accordingly."""
    pattern = re.compile(
        rf"(?<![A-Za-z0-9_.])s\.(?:(?P<platform>[a-z_]+)\.)?{attribute}\s*=\s*(?P<value>.+?)"
        r"(?=\n\s*(?:s\.|end\b)|\Z)",
        re.DOTALL,
    )
    found = None
    for match in pattern.finditer(text):
        if (match.group("platform") or "") in _MACOS_PLATFORMS:
            found = match.group("value").strip()
    return found


def podspec_string(value: str):
    match = re.fullmatch(r"['\"](.*)['\"]", value, re.DOTALL)
    if not match:
        return None
    inner = match.group(1)
    # A Ruby varargs list without brackets (s.frameworks = 'A', 'B') would
    # greedily match as one garbage token; callers handle None instead.
    if "'" in inner or '"' in inner:
        log.warning(f"ignoring bracket-less list {value!r}; declare it as a Ruby array")
        return None
    return inner


def podspec_string_list(value: str):
    match = re.fullmatch(r"\[(.*)\]", value, re.DOTALL)
    if match:
        return re.findall(r"['\"]([^'\"]*)['\"]", match.group(1))
    string = podspec_string(value)
    return [string] if string is not None else None


# Version requirements of `dependency` args: an operator plus digits, or a
# bare pinned version ('1.2').  CocoaPods pod names never start with a digit,
# so the digit anchor keeps names and versions apart.
_VERSION_RE = re.compile(r"^(?:~>|>=|<=|>|<|=|!=)?\s*\d[\d.]*$")


def podspec_dependencies(text: str):
    """All `s[.<osx|macos>.].dependency 'Pod'[, 'version requirement']` args
    across the podspec, as pod names only.  Several plugins declare more than
    one dependency line and pass the version as a separate quoted argument
    (e.g. `s.dependency 'OrderedSet', '~>6.0.3'`); a naive value grab would
    swallow both arguments into one string and keep only the last line."""
    deps = []
    # Any block variable may declare dependencies (subspecs use `ss.`), and
    # the platform-scoped shape (`s.osx.dependency`) counts too; a subspec's
    # third-party pod still breaks the combined-module compile.
    for match in re.finditer(
        r"(?<![A-Za-z0-9_.])\w+\.(?:(?:osx|macos|ios)\.)?dependency[^\n]*", text
    ):
        deps.extend(
            d
            for d in re.findall(r"['\"]([^'\"]*)['\"]", match.group(0))
            if not _VERSION_RE.match(d)
        )
    return deps


def expand_braces(pattern: str):
    match = re.search(r"\{([^}]*)\}", pattern)
    if not match:
        return [pattern]
    expanded = []
    for alternative in match.group(1).split(","):
        expanded.extend(
            expand_braces(
                pattern[: match.start()] + alternative + pattern[match.end() :]
            )
        )
    return expanded


def glob_files(root: str, pattern: str):
    """Expand a CocoaPods glob. Braces are handled by hand because glob.glob
    mishandles `**` combined with {a,b} groups."""
    matches = []
    for expanded in expand_braces(pattern):
        matches.extend(
            m
            for m in glob.glob(expanded, root_dir=root, recursive=True)
            if os.path.isfile(os.path.join(root, m))
        )
    return sorted(os.path.join(root, match) for match in matches)


def imported_frameworks(podspec_dir: str, patterns: list[str], skip_pods=()):
    """System frameworks the ObjC sources import; ObjC has no autolinking.
    Headers imported as `<Foo/...>` where Foo is a known plugin are internal
    to a pod (e.g. printing/PrintingPlugin.h), not system frameworks."""
    frameworks = set()
    for pattern in patterns:
        for source in glob_files(podspec_dir, pattern):
            if source.endswith((".m", ".mm", ".h")):
                body = Path(source).read_text(encoding="utf-8", errors="ignore")
                frameworks.update(re.findall(r"#import\s*<([A-Za-z0-9_]+)/", body))
                frameworks.update(re.findall(r"@import\s+([A-Za-z0-9_]+)\s*;", body))
    return sorted(frameworks.difference(skip_pods))


# ---------------------------------------------------------------------------
# Plugin collection
# ---------------------------------------------------------------------------


def plugin_class(pubspec_path: str):
    pubspec = yaml.safe_load(Path(pubspec_path).read_text(encoding="utf-8"))
    platforms = (pubspec.get("flutter") or {}).get("plugin", {}).get(
        "platforms", {}
    ) or {}
    for key in ("macos", "darwin"):
        macos_plugin = platforms.get(key) or {}
        if macos_plugin.get("pluginClass"):
            return macos_plugin["pluginClass"]
    return None


def swiftpm_sources(package_dir: str, package_swift: str, name: str):
    text = Path(package_swift).read_text(encoding="utf-8")
    protected = {}

    def protect(match):
        token = f"\x00{len(protected)}\x00"
        protected[token] = match.group(0)
        return token

    # Protect string literals so stripping // comments does not eat https://.
    text = re.sub(r'"(?:[^"\\]|\\.)*"', protect, text)
    text = re.sub(r"//.*$", "", text, flags=re.MULTILINE)
    for token, literal in protected.items():
        text = text.replace(token, literal)
    third_party = []
    for dependency in re.findall(r"\.package\((?:[^()]|\([^()]*\))*\)", text):
        if "FlutterFramework" in dependency:
            continue
        match = re.search(r'(?:url|path)\s*:\s*"([^"]+)"', dependency)
        if not match:
            continue
        location = match.group(1)
        if location.startswith("http") or not location.startswith(("../", "./")):
            third_party.append(location)
    if third_party:
        log.warning(
            f"skip {name}: needs third-party SwiftPM packages {', '.join(third_party)}"
        )
        return []
    sources = []
    base = os.path.join(package_dir, "Sources")
    if os.path.isdir(base):
        for directory, subdirectories, filenames in os.walk(base):
            # Sorted so WMO sees the same input order on every machine.
            subdirectories[:] = sorted(
                d for d in subdirectories if d not in ("Tests", ".build")
            )
            for filename in sorted(filenames):
                if filename.endswith(".swift"):
                    sources.append(os.path.join(directory, filename))
    if not sources:
        log.warning(f"skip {name}: Package.swift has no Sources directory")
    return sources


def prefix_pigeon_symbols(path: str, plugin_name: str) -> None:
    """Prefix the shared Pigeon symbols in a plugin source file.  Every Swift
    file of a plugin may reference them (hand-written code uses e.g.
    PigeonError), not just the generated messages.g.swift.  Whole words only:
    identifiers that merely embed a symbol name (rows_MyMessagesPigeonCodec)
    must not be rewritten."""
    text = Path(path).read_text(encoding="utf-8")
    for symbol in _PIGEON_SYMBOLS:
        text = re.sub(
            rf"(?<![A-Za-z0-9_]){re.escape(symbol)}",
            f"{plugin_name}{symbol}",
            text,
        )
    Path(path).write_text(text, encoding="utf-8")


def rename_pigeon_files(dest: str, plugin_name: str):
    """Rename each messages.g.swift so several Pigeon plugins can compile
    into one Swift module.  Returns {relative: new_name} so the caller can
    address the renamed sources."""
    renamed = {}
    for message_file in glob.glob(
        os.path.join(dest, "**", "messages.g.swift"), recursive=True
    ):
        relative = os.path.relpath(message_file, dest)
        new_name = f"{plugin_name}_{relative.replace('/', '_')}"
        new_path = os.path.join(dest, new_name)
        os.rename(message_file, new_path)
        # macOS builds run on a case-insensitive filesystem where glob keeps
        # the query's casing (e.g. "Messages.g.swift" matched as
        # "messages.g.swift"), while the podspec sources carry the real name;
        # look up the renamed files case-insensitively so both agree.
        renamed[relative.casefold()] = new_name
    return renamed


def has_nsrect_top_left(path: str) -> bool:
    text = Path(path).read_text(encoding="utf-8")
    return "extension NSRect {" in text and "var topLeft" in text


def drop_satellite_connectivity_branch(path: str) -> None:
    """Drop a plugin's innermost `if` around `path.isUltraConstrained`.
    connectivity_plus gates the satellite connectivity type behind
    `NWPath.isUltraConstrained`, which does not exist in the 14.4 SDK nixpkgs
    ships; compiling against it fails even under `#available`. Removing only
    the innermost statement keeps any sibling logic in the enclosing
    availability block intact (satellite stays off)."""
    text = Path(path).read_text(encoding="utf-8")
    marker = text.find("path.isUltraConstrained")
    if marker == -1:
        return
    # Statement lines only: a bare "if" inside a comment, string or
    # preprocessor directive must not start the brace scan.
    starts = [match.start() for match in re.finditer(r"(?m)^[ \t]*if\b", text[:marker])]
    if not starts:
        return
    start = starts[-1]
    depth = 0
    end = start
    for index in range(start, len(text)):
        if text[index] == "{":
            depth += 1
        elif text[index] == "}":
            depth -= 1
            if depth == 0:
                end = index + 1
                break
    # Say so: a future connectivity_plus reshuffling its availability block
    # must not silently change what this rewrites.
    log.warning(f"{path}: dropped satellite-connectivity branch")
    Path(path).write_text(text[:start] + text[end:], encoding="utf-8")


def drop_nsrect_extension(path: str) -> None:
    """Drop a plugin's `extension NSRect { var topLeft }`. Several plugins
    (screen_retriever_macos, tray_manager, window_manager) define it; only the
    first one may stay, the rest are removed here. Since every plugin compiles
    into a single module, uses of `topLeft` elsewhere still resolve against the
    surviving extension."""
    source = Path(path).read_text(encoding="utf-8")
    start = source.find("extension NSRect {")
    if start == -1:
        return
    depth = 0
    end = start
    for index in range(start, len(source)):
        if source[index] == "{":
            depth += 1
        elif source[index] == "}":
            depth -= 1
            if depth == 0:
                end = index + 1
                break
    Path(path).write_text(source[:start] + source[end:], encoding="utf-8")


def sidecar_libraries(sidecar: str, root: str) -> list[str]:
    """Absolute paths of the libraries a builder declares in ``sidecar``
    (one path relative to ``root`` per line; see the sqflite_darwin and
    super_native_extensions builders)."""
    libraries = []
    for line in Path(sidecar).read_text(encoding="utf-8").splitlines():
        path = line.strip()
        if not path:
            continue
        absolute = os.path.join(root, path)
        if os.path.isfile(absolute):
            libraries.append(absolute)
        else:
            log.warning(f"{sidecar}: {path!r} does not exist")
    return libraries


def copy_sources(sources, root: str, dest: str) -> None:
    for source_file in sources:
        target = os.path.join(dest, os.path.relpath(source_file, root))
        os.makedirs(os.path.dirname(target), exist_ok=True)
        shutil.copy2(source_file, target)
        # Store paths are read-only; the copies must be writable for the
        # renaming and rewriting below.
        os.chmod(target, 0o644)


def resolve_plugin(
    name: str,
    root: str,
    known_pods: set = frozenset(),
):
    """Return (kind, sources, public_dir, frameworks, vendored_libraries),
    or None when the plugin cannot be built without CocoaPods/SwiftPM.

    kind is "swift" or "objc"; public_dir is the plugin's public header
    directory relative to root, or None; frameworks are the `-framework`
    names the pod declares or its ObjC sources import; vendored_libraries
    holds absolute paths of the prebuilt libraries the pod ships
    (s.vendored_libraries); the caller copies them next to the sources and
    links them by path."""
    package_dir = None
    swift_package = None
    podspec = None
    for subdirectory in (os.path.join(root, "macos"), os.path.join(root, "darwin")):
        for candidate in (
            os.path.join(subdirectory, f"{name}.podspec"),
            os.path.join(subdirectory, name, f"{name}.podspec"),
            os.path.join(subdirectory, "Package.swift"),
            os.path.join(subdirectory, name, "Package.swift"),
        ):
            if os.path.isfile(candidate):
                package_dir = os.path.dirname(candidate)
                if candidate.endswith("Package.swift"):
                    swift_package = candidate
                else:
                    podspec = candidate
                break
        if swift_package is not None or podspec is not None:
            break

    if swift_package is not None:
        sources = swiftpm_sources(package_dir, swift_package, name)
        return ("swift", sources, None, [], []) if sources else None

    if podspec is not None:
        text = strip_ruby(Path(podspec).read_text(encoding="utf-8"))
        dependencies = podspec_dependencies(text)
        # Dependencies on other plugins are fine: their sources are
        # collected into the same Runner module (e.g. media_kit_video
        # depending on media_kit_libs_macos_video).
        third_party = [
            d
            for d in dependencies
            if d.split("/")[0] not in _APPLE_PODS and d.split("/")[0] not in known_pods
        ]
        if third_party:
            log.warning(f"skip {name}: needs third-party pods {', '.join(third_party)}")
            return None
        platform = re.match(r":([a-z_]+)", podspec_value(text, "platform") or "")
        if platform and platform.group(1) != "osx":
            log.warning(f"skip {name}: podspec declares platform :{platform.group(1)}")
            return None
        # source_files may be a single glob or a Ruby array of globs;
        # podspec_string_list handles both shapes.
        patterns = podspec_string_list(podspec_value(text, "source_files") or "") or []
        if not patterns:
            log.warning(f"skip {name}: no compilable source_files in {podspec}")
            return None
        # Overlapping globs would hand the same file to swiftc twice.
        sources = list(
            dict.fromkeys(
                path
                for source_pattern in patterns
                for path in glob_files(package_dir, source_pattern)
            )
        )
        swift_files = [s for s in sources if s.endswith(".swift")]
        objc_files = [s for s in sources if s.endswith((".m", ".mm"))]
        if not swift_files and not objc_files:
            raise SystemExit(f"{name}: {patterns!r} matched no compilable sources")
        public_dir = None
        public_value = podspec_value(text, "public_header_files")
        if public_value is not None:
            # The attribute may be a single quoted string or a Ruby array;
            # podspec_string_list handles both shapes.
            headers = [
                header
                for header_pattern in podspec_string_list(public_value) or []
                for header in glob_files(package_dir, header_pattern)
            ]
            directories = sorted({os.path.dirname(h) for h in headers})
            if directories:
                public_dir = os.path.relpath(directories[0], root)
        # Pods may declare the attribute as s.frameworks (plural) or
        # s.framework (singular, e.g. super_native_extensions' Carbon).
        frameworks = (
            podspec_string_list(
                podspec_value(text, "frameworks")
                or podspec_value(text, "framework")
                or ""
            )
            or []
        )
        if objc_files:
            frameworks = sorted(
                set(frameworks)
                | set(imported_frameworks(package_dir, patterns, known_pods))
            )
        # Prebuilt libraries the pod ships (s.vendored_libraries): the
        # sqflite_darwin builder carries the nixpkgs sqlite dylib this way,
        # since the sandboxed SDK has no system libsqlite3 to link against.
        # nixpkgs builders may declare them in a sidecar instead of editing
        # the podspec; its paths are relative to the plugin root.
        sidecar = os.path.join(root, "nixpkgs-vendored-libraries.txt")
        if os.path.isfile(sidecar):
            vendored = sidecar_libraries(sidecar, root)
        else:
            vendored = [
                os.path.join(package_dir, library)
                for library in podspec_string_list(
                    podspec_value(text, "vendored_libraries") or ""
                )
                or []
                if library
            ]
        return (
            "swift" if swift_files else "objc",
            sources,
            public_dir,
            frameworks,
            vendored,
        )

    log.warning(f"skip {name}: no macos/darwin Package.swift or podspec")
    return None


@dataclass
class Collected:
    """Plugins prepared for compilation, straight from collect().

    swift_files go into the Runner's Swift module; objc_roots are the
    (directory, public header dir) pairs whose .m/.mm sources the build
    compiles with clang; objc_registrations are the (plugin, class) pairs
    registered from ObjC.  vendored_libraries are linked by path and shipped
    inside the bundle, static_libraries are linked into the Runner only."""

    swift_files: list[str] = field(default_factory=list)
    objc_roots: list[tuple[str, str]] = field(default_factory=list)
    objc_registrations: list[tuple[str, str]] = field(default_factory=list)
    frameworks: list[str] = field(default_factory=list)
    vendored_libraries: list[str] = field(default_factory=list)
    static_libraries: list[str] = field(default_factory=list)
    modules: list[str] = field(default_factory=list)
    swift_registrations: list[str] = field(default_factory=list)


def registrant_source(collected: Collected) -> str:
    lines = [
        "//",
        "//  Generated file. Do not edit.",
        "//",
        "",
        "import FlutterMacOS",
        "import Foundation",
        "",
        "func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {",
    ]
    lines.extend(collected.swift_registrations)
    if collected.objc_registrations:
        lines.append("  RegisterNixpkgsObjCPlugins(registry)")
    lines.append("}")
    return "\n".join(lines) + "\n"


def bridging_header_source(collected: Collected) -> str:
    lines = ["#import <FlutterMacOS/FlutterMacOS.h>"]
    if collected.objc_registrations:
        lines.append(
            "void RegisterNixpkgsObjCPlugins(id<FlutterPluginRegistry> registry);"
        )
    return "\n".join(lines) + "\n"


def objc_registrar_source(collected: Collected) -> str:
    lines = ["#import <FlutterMacOS/FlutterMacOS.h>"]
    for name, class_name in collected.objc_registrations:
        lines.append(
            f"static void RegisterPlugin{name}(id<FlutterPluginRegistry> r) {{"
        )
        lines.append(f'  Class c = NSClassFromString(@"{class_name}");')
        lines.append(
            "  if (c && [c respondsToSelector:@selector(registerWithRegistrar:)])"
        )
        lines.append(f'    [c registerWithRegistrar:[r registrarForPlugin:@"{name}"]];')
        lines.append("}")
    lines.append(
        "void RegisterNixpkgsObjCPlugins(id<FlutterPluginRegistry> registry) {"
    )
    for name, _ in collected.objc_registrations:
        lines.append(f"  RegisterPlugin{name}(registry);")
    lines.append("}")
    return "\n".join(lines) + "\n"


def collect(config_path: str, outdir: str) -> Collected:
    """Copy every buildable macOS plugin's native sources under outdir and
    return what the compile steps need.

    The native sources of every macOS method-channel plugin land under
    <outdir>/<package>/, rewritten where needed (Pigeon symbol prefixes,
    duplicated NSRect extensions, ...).  registrant.swift and bridging.h are
    written for the Swift compile; the ObjC registrar is generated later by
    compile_objc_sources()."""
    os.makedirs(outdir, exist_ok=True)
    collected = Collected()

    config = json.loads(Path(config_path).read_text(encoding="utf-8"))
    # Relative rootUris resolve against the package_config's own directory
    # (package_config.json 2.x spec), not the process CWD.
    config_dir = os.path.dirname(os.path.abspath(config_path))
    packages = {}
    for package in config["packages"]:
        root = unquote(urlparse(package["rootUri"]).path)
        if root and not os.path.isabs(root):
            root = os.path.normpath(os.path.join(config_dir, root))
        if root:
            packages[package["name"]] = root

    plugins = {}
    for name, root in packages.items():
        pubspec = os.path.join(root, "pubspec.yaml")
        if not os.path.isfile(pubspec):
            continue
        class_name = plugin_class(pubspec)
        if class_name:
            plugins[name] = (root, class_name)
            continue
        # A macOS section without a pluginClass is usually an ffiPlugin
        # (its native library arrives via code assets, not source
        # collection); say so instead of passing over it in silence.
        platforms = (
            (
                yaml.safe_load(Path(pubspec).read_text(encoding="utf-8")).get("flutter")
                or {}
            )
            .get("plugin", {})
            .get("platforms", {})
        ) or {}
        if any(platforms.get(key) for key in ("macos", "darwin")):
            log.warning(
                f"{name}: macOS plugin section without pluginClass; assuming ffiPlugin"
            )
    if not plugins:
        log.warning(f"no macOS plugins found in {config_path}")

    nsrect_top_left_seen = False
    objc_frameworks: set[str] = set()
    for name, (root, class_name) in sorted(plugins.items()):
        resolved = resolve_plugin(name, root, set(plugins))
        if resolved is None:
            continue
        kind, sources, public_dir, frameworks, vendored = resolved
        collected.modules.append(name)
        dest = os.path.join(outdir, name)
        copy_sources(sources, root, dest)
        for library in vendored:
            copy_sources([library], root, dest)
            collected.vendored_libraries.append(
                os.path.join(dest, os.path.relpath(library, root))
            )
        # Static libraries the builder ships (e.g. super_native_extensions'
        # Rust core): linked into the Runner, never bundled.
        extra = os.path.join(root, "nixpkgs-static-libraries.txt")
        if os.path.isfile(extra):
            collected.static_libraries.extend(sidecar_libraries(extra, root))
        renamed = rename_pigeon_files(dest, name)
        if kind == "swift":
            mixed_objc = False
            for source in sources:
                if source.endswith((".m", ".mm")):
                    # ObjC brothers of a Swift pod (helper classes, ...):
                    # compile them via clang below, but do not register
                    # anything (the plugin class lives in the Swift module).
                    mixed_objc = True
                    continue
                # source_files usually covers resources (xib, ...) and
                # mixed ObjC siblings too; only Swift goes into the module.
                if not source.endswith(".swift"):
                    continue
                relative = os.path.relpath(source, root)
                copied = os.path.join(dest, renamed.get(relative.casefold(), relative))
                collected.swift_files.append(copied)
                # Hand-written sources reference the shared Pigeon symbols
                # (PigeonError, the codec, ...) too; prefix them so the
                # references still match after the rename.  This also
                # renames the declarations in messages.g.swift itself.
                prefix_pigeon_symbols(copied, name)
                drop_satellite_connectivity_branch(copied)
                if has_nsrect_top_left(copied):
                    if nsrect_top_left_seen:
                        drop_nsrect_extension(copied)
                    else:
                        nsrect_top_left_seen = True
            if mixed_objc:
                collected.objc_roots.append((dest, public_dir))
            # Declared frameworks are passed to the Swift compile too: the
            # module links them explicitly instead of relying on autolinking
            # (which only covers SDK frameworks).
            objc_frameworks.update(frameworks)
            collected.swift_registrations.append(
                f'{class_name}.register(with: registry.registrar(forPlugin: "{name}"))'
            )
        else:
            collected.objc_roots.append((dest, public_dir))
            collected.objc_registrations.append((name, class_name))
            objc_frameworks.update(frameworks)

    collected.frameworks = sorted(objc_frameworks.difference(_AUTOLINKED_FRAMEWORKS))

    output = Path(outdir)
    (output / "registrant.swift").write_text(
        registrant_source(collected), encoding="utf-8"
    )
    (output / "bridging.h").write_text(
        bridging_header_source(collected), encoding="utf-8"
    )
    return collected


# ---------------------------------------------------------------------------
# Info.plist and xcconfig
# ---------------------------------------------------------------------------


def xcconfig_lookup(path: str, key: str) -> str:
    """Value of `key` in an .xcconfig file, or "" when either is missing.

    The build reads settings this way instead of relying on Xcode's build
    system.  `#include` lines are followed (the Flutter template pulls in
    Generated.xcconfig that way); like xcconfig itself, the last assignment
    wins."""
    try:
        with open(path, encoding="utf-8") as handle:
            lines = handle.read().splitlines()
    except OSError:
        return ""
    pattern = re.compile(rf"^\s*{re.escape(key)}\s*=\s*(.*?)\s*$")
    value = ""
    for line in lines:
        stripped = line.lstrip()
        if stripped.startswith("//"):  # comment
            continue
        include = re.match(r'#include\??\s*"(.*)"', stripped)
        if include:
            included = include.group(1)
            if not os.path.isabs(included):
                included = os.path.join(os.path.dirname(path), included)
            # The included file's assignment stands, unless this file
            # reassigns the key further down.
            value = xcconfig_lookup(included, key) or value
            continue
        if stripped.startswith("#"):  # plain comment
            continue
        match = pattern.match(line)
        if match:
            value = re.sub(r"\s*//.*$", "", match.group(1)).rstrip()
    return value


_PLACEHOLDER = re.compile(r"^\$\(([^)]+)\)$")


def generate_info_plist(
    template: str, output: str, pubspec: str, substitutions: dict[str, str]
) -> None:
    """Generate the Runner's Info.plist from the template.

    The template carries build-settings placeholders such as $(PRODUCT_NAME).
    They are substituted from an explicit mapping (plus the version from
    pubspec.yaml), and the nib entry is dropped because the bundle is
    assembled without ibtool.  An unresolved placeholder fails the build
    instead of shipping a broken bundle."""
    pubspec_version = yaml.safe_load(Path(pubspec).read_text(encoding="utf-8")).get(
        "version", ""
    )
    build_name, _, build_number = str(pubspec_version).partition("+")
    # Work on a copy: the caller's dict must not gain the FLUTTER_BUILD_*
    # entries as a side effect.
    substitutions = {
        **substitutions,
        "FLUTTER_BUILD_NAME": build_name,
        "FLUTTER_BUILD_NUMBER": build_number or "1",
    }

    with open(template, "rb") as handle:
        plist = plistlib.load(handle)
    for key, value in list(plist.items()):
        if isinstance(value, str):
            match = _PLACEHOLDER.match(value)
            if match:
                replacement = substitutions.get(match.group(1))
                if replacement is None:
                    raise SystemExit(f"no substitution for {value} in {template}")
                plist[key] = replacement
    plist.pop("NSMainNibFile", None)
    with open(output, "wb") as handle:
        plistlib.dump(plist, handle, sort_keys=False)

    leftover = sorted(
        set(
            re.findall(
                r"\$\([A-Za-z0-9_:]+\)", Path(output).read_text(encoding="utf-8")
            )
        )
    )
    if leftover:
        raise SystemExit(
            f"unsubstituted placeholders remain in {output}: {', '.join(leftover)}"
        )


# ---------------------------------------------------------------------------
# Build stage
# ---------------------------------------------------------------------------


def assemble_flags_and_target() -> tuple[list[str], str]:
    """Translate the user's flutterBuildFlags into `flutter assemble` defines.

    --target overrides the default main.dart entry point; the -dTargetFile
    define below uses it either way, so nothing is appended for it here.
    flutter_tools expects dart defines to be base64-encoded (see
    decodeDartDefines in flutter_tools/lib/src/build_info.dart); a plain value
    would be rejected by `assemble`.  The mode rides in via -dBuildMode below
    and the local engine flags are already on the assemble command line.  The
    Linux build forwards unknown flags to `flutter build`, which validates
    them; `assemble` understands only the cases above, so dropping one
    silently would change the app without notice.
    """
    flags: list[str] = []
    target_file = "lib/main.dart"
    for flag in os.environ["macosBuildFlags"].splitlines():
        if flag.startswith("--dart-define="):
            encoded = base64.b64encode(flag.removeprefix("--dart-define=").encode())
            flags.append("--dart-define=" + encoded.decode())
        elif flag.startswith("--split-debug-info="):
            # The build always sends split debug info to the $debug output;
            # honoring a user path here would silently empty that output.
            log.warning(f"ignoring {flag}; split debug info goes to the debug output")
        elif flag == "--obfuscate":
            flags.append("-dDartObfuscation=true")
        elif flag == "--tree-shake-icons":
            flags.append("-dTreeShakeIcons=true")
        elif flag == "--no-tree-shake-icons":
            flags.append("-dTreeShakeIcons=false")
        elif flag.startswith("--target="):
            target_file = flag.removeprefix("--target=")
        elif flag in ("--release", "--debug", "--profile") or flag.startswith(
            ("--local-engine", "host_")
        ):
            pass
        else:
            # The Linux build forwards unknown flags to `flutter build`, so a
            # dropped one would make the macOS app differ without notice.
            sys.exit(
                f"error: flutterBuildFlags entry not supported by 'flutter assemble': {flag}"
            )
    return flags, target_file


def strip_main_attributes(text: str) -> str:
    """Blank out @main/@NSApplicationMain lines; the programmatic main in
    macosRunnerMain replaces them."""
    text = re.sub(r"(?m)^@main[ \t]*$", "", text)
    return re.sub(r"(?m)^@NSApplicationMain[ \t]*$", "", text)


def strip_plugin_imports(paths: list[Path], modules: list[str]) -> None:
    """Plugins compile into the Runner module itself; drop imports of those
    modules from Runner and plugin sources (the symbols are already visible).
    Only files we own are edited: the pinned plugin sources under /nix/store
    are read-only (and never import themselves)."""
    for module in modules:
        pattern = re.compile(rf"(?m)^[ \t]*import {re.escape(module)}[ \t]*(\n|$)")
        for path in paths:
            text = path.read_text(encoding="utf-8")
            rewritten = pattern.sub("", text)
            if rewritten != text:
                path.write_text(rewritten, encoding="utf-8")


def compile_objc_sources(
    collected: Collected, plugin_dir: Path, products_dir: Path, target: str
) -> list[str]:
    """Compile the ObjC plugin sources and the generated registrar.

    Sources that mix Swift siblings import their pod's generated Swift
    interface header (e.g. <printing/printing-Swift.h>).  In the single
    Runner module that interface lives in Runner-Swift.h, which the Swift
    compile emits before this runs; rewrite the imports and add its
    directory to the include path."""
    objects = []
    if not collected.objc_roots:
        return objects
    registrar = plugin_dir / "nixpkgs_objc_plugins.m"
    registrar.write_text(objc_registrar_source(collected), encoding="utf-8")
    registrar_object = plugin_dir / "nixpkgs_objc_plugins.o"
    common = [
        "-fobjc-arc",
        f"--target={target}",
        "-F",
        str(products_dir),
        "-isysroot",
        os.environ["SDKROOT"],
        *optimization_flags(),
    ]
    run(
        [
            "clang",
            *common,
            "-c",
            str(registrar),
            "-include",
            "Foundation/Foundation.h",
            "-o",
            str(registrar_object),
        ]
    )
    objects.append(str(registrar_object))
    swift_header = re.compile(r"#import\s+<[^>]+-Swift\.h>")
    for dest, public_dir in collected.objc_roots:
        include_dirs = [plugin_dir]
        if public_dir is not None:
            include_dirs.insert(0, Path(dest) / public_dir)
        includes = [
            flag for directory in include_dirs for flag in ("-I", str(directory))
        ]
        for source in sorted(
            glob.glob(os.path.join(dest, "**", "*.m"), recursive=True)
            + glob.glob(os.path.join(dest, "**", "*.mm"), recursive=True)
        ):
            text = Path(source).read_text(encoding="utf-8")
            rewritten = swift_header.sub('#import "Runner-Swift.h"', text)
            if rewritten != text:
                Path(source).write_text(rewritten, encoding="utf-8")
            object_file = os.path.splitext(source)[0] + ".o"
            objects.append(object_file)
            run(
                [
                    "clang",
                    *common,
                    "-fmodules",
                    # Pin the module cache: the default lives next to the
                    # sources, which are read-only store paths.
                    f"-fmodules-cache-path={plugin_dir / 'modules'}",
                    "-c",
                    source,
                    *includes,
                    "-include",
                    "Foundation/Foundation.h",
                    "-o",
                    object_file,
                ]
            )
    return objects


def compile_swift_runner(
    collected: Collected,
    plugin_dir: Path,
    runner_dir: Path,
    products_dir: Path,
    app_binary: Path,
    target: str,
) -> None:
    """Compile the Runner from Swift sources.

    The template project's @main entry point is stripped and replaced by a
    programmatic main (macos-runner-main.swift) that reproduces the
    MainMenu.xib behavior without Xcode/ibtool.  The collector runs regardless
    of the Runner flavor: the ObjC fallback needs to know whether any plugin
    was requested.  The template's GeneratedPluginRegistrant.swift imports the
    plugin modules normally compiled by CocoaPods; nixpkgs builds without
    CocoaPods, so the collector generates a registrant for the plugins it
    compiled."""
    framework_flags = [
        flag for name in collected.frameworks for flag in ("-framework", name)
    ]
    # -import-objc-header exposes RegisterNixpkgsObjCPlugins (bridging.h);
    # it only makes sense when compiling Swift, not at link time.
    compile_flags = ["-import-objc-header", str(plugin_dir / "bridging.h")]
    common_flags = [*framework_flags, "-target", target]

    shutil.copyfile(
        plugin_dir / "registrant.swift", runner_dir / "GeneratedPluginRegistrant.swift"
    )
    runner_sources = sorted(runner_dir.glob("*.swift"))
    for source in runner_sources:
        text = strip_main_attributes(source.read_text(encoding="utf-8"))
        source.write_text(text, encoding="utf-8")

    # find(1) order is unspecified but sed is idempotent; sort for determinism.
    plugin_swift = sorted(plugin_dir.rglob("*.swift"))
    strip_plugin_imports(runner_sources + plugin_swift, collected.modules)
    shutil.copyfile(os.environ["macosRunnerMain"], runner_dir / "main.swift")

    # Compile the plugin and Runner Swift sources to a single object file,
    # emitting Runner-Swift.h for ObjC plugin sources that import their pod's
    # generated Swift header.
    runner_object = plugin_dir / "Runner.o"
    run(
        [
            "swiftc",
            *swift_optimization_flags(),
            # Whole-module mode is what makes the compile emit a single
            # Runner.o; per-file output cannot take -o.
            "-whole-module-optimization",
            "-c",
            "-module-name",
            "Runner",
            *common_flags,
            *compile_flags,
            "-emit-objc-header",
            "-emit-objc-header-path",
            str(plugin_dir / "Runner-Swift.h"),
            *sorted(runner_dir.glob("*.swift")),
            *collected.swift_files,
            "-F",
            str(products_dir),
            "-framework",
            "FlutterMacOS",
            "-o",
            str(runner_object),
        ]
    )
    # Compile the ObjC plugin sources and the generated registrar (needs
    # Runner-Swift.h from the step above).
    objc_objects = compile_objc_sources(collected, plugin_dir, products_dir, target)
    # Link the Runner executable.  vendored_libraries are pod libraries
    # copied next to the plugin sources; linking by absolute path records
    # their @rpath install name (see the sqflite_darwin builder), resolved
    # from Contents/Frameworks where embed_frameworks ships the dylibs.
    run(
        [
            "swiftc",
            str(runner_object),
            *objc_objects,
            *collected.vendored_libraries,
            *collected.static_libraries,
            *common_flags,
            "-F",
            str(products_dir),
            "-framework",
            "FlutterMacOS",
            "-Xlinker",
            "-rpath",
            "-Xlinker",
            "@executable_path/../Frameworks",
            "-o",
            str(app_binary),
        ]
    )


def compile_objc_runner(
    collected: Collected, products_dir: Path, app_binary: Path, target: str
) -> None:
    """Non-template projects without Swift sources: plain ObjC runner.

    It cannot host compiled plugins (the registrant is Swift), so a plugin
    dependency is a hard error instead of a silently broken app."""
    if collected.modules:
        sys.exit(
            "error: macOS plugins require Swift Runner sources (macos/Runner/*.swift); "
            "the Flutter template provides them"
        )
    run(
        [
            "clang",
            "-fobjc-arc",
            f"--target={target}",
            *optimization_flags(),
            os.environ["macosRunnerObjc"],
            "-F",
            str(products_dir),
            "-framework",
            "FlutterMacOS",
            "-framework",
            "Cocoa",
            "-Xlinker",
            "-rpath",
            "-Xlinker",
            "@executable_path/../Frameworks",
            "-o",
            str(app_binary),
        ]
    )


def embed_frameworks(collected: Collected, products_dir: Path, app_dir: Path) -> None:
    frameworks_dir = app_dir / "Contents" / "Frameworks"
    for framework in ("App.framework", "FlutterMacOS.framework"):
        shutil.copytree(
            products_dir / framework, frameworks_dir / framework, symlinks=True
        )
    # Dart build hooks (code assets, e.g. objective_c) emit <name>.framework
    # into BUILT_PRODUCTS_DIR/native_assets; the Xcode build normally copies
    # them into the bundle (flutter_tools xcode_backend.dart).  Do the same
    # here, since their Dart side dlopens them by name at runtime.
    native_assets = products_dir / "native_assets"
    if native_assets.is_dir():
        for framework in sorted(native_assets.glob("*.framework")):
            shutil.copytree(framework, frameworks_dir / framework.name, symlinks=True)
    # Vendored libraries are linked by path and ship inside the bundle: their
    # install name is @rpath/<basename> (see the sqflite_darwin builder) and
    # the rpath above points at Contents/Frameworks, so the app is
    # self-contained without depending on the nix store at runtime.
    for library in collected.vendored_libraries:
        # -L semantics: resolve symlinks so the real dylib ships.
        shutil.copy(library, frameworks_dir / Path(library).name, follow_symlinks=True)


def build() -> None:
    mode = os.environ["flutterMode"]
    pname = os.environ["pname"]
    debug_out = os.environ["debug"]

    # Our xcrun shim must shadow `xcbuild.xcrun`, which the Darwin stdenv puts
    # on PATH before the derivation's own inputs; everything spawned below
    # inherits it.  The ObjC plugin compiler needs the SDK to resolve
    # Foundation/AppKit headers.
    os.environ["PATH"] = f"{os.environ['macosXcrunBridge']}/bin:{os.environ['PATH']}"
    os.environ["SDKROOT"] = os.environ["macosSdkroot"]
    os.environ["FLUTTER_SUPPRESS_ANALYTICS"] = "true"

    # Produce the Flutter framework artifacts without Xcode.  `flutter
    # assemble` is the Xcode-independent interface flutter_tools uses
    # internally; `*_macos_bundle_flutter_assets` emits App.framework,
    # FlutterMacOS.framework and ephemeral build outputs into
    # build/macos/Build/Products/<mode> (the conventional layout).
    products_dir = Path.cwd() / "build/macos/Build/Products" / mode
    products_dir.mkdir(parents=True, exist_ok=True)
    Path(debug_out).mkdir(parents=True, exist_ok=True)
    assemble_flags, target_file = assemble_flags_and_target()
    run(
        [
            "flutter",
            "assemble",
            "--no-version-check",
            *os.environ["flutterFlags"].split(),
            f"--output={products_dir}/",
            "-dTargetPlatform=darwin",
            f"-dTargetFile={target_file}",
            f"-dBuildMode={mode}",
            f"-dConfiguration={mode.capitalize()}",
            "-dDarwinArchs=arm64",
            f"-dSplitDebugInfo={debug_out}",
            *assemble_flags,
            f"{mode}_macos_bundle_flutter_assets",
        ]
    )

    # Assemble the .app bundle.
    app_info = "macos/Runner/Configs/AppInfo.xcconfig"
    app_name = xcconfig_lookup(app_info, "PRODUCT_NAME") or pname
    # Each configuration has its own xcconfig; read the one being built.  The
    # value also feeds the compiler target below, so it is needed before the
    # Runner compile, not just for Info.plist.
    # The Flutter template has no Profile.xcconfig; profile builds use the
    # Release settings, same as Xcode.
    config_name = "Release" if mode == "profile" else mode.capitalize()
    mode_config = f"macos/Runner/Configs/{config_name}.xcconfig"
    # The Flutter template keeps the value in project.pbxproj instead, where
    # we cannot read it; 12.0 is the template's default.  Values like
    # $(inherited) would produce an invalid compiler target, so anything
    # non-numeric falls back too.
    configured_target = xcconfig_lookup(mode_config, "MACOSX_DEPLOYMENT_TARGET")
    if not re.fullmatch(r"\d+(?:\.\d+)?", configured_target or ""):
        if configured_target:
            log.warning(
                f"ignoring non-numeric {mode_config} MACOSX_DEPLOYMENT_TARGET {configured_target!r}"
            )
        else:
            log.warning(f"no MACOSX_DEPLOYMENT_TARGET in {mode_config}; assuming 12.0")
        deployment_target = "12.0"
    else:
        deployment_target = configured_target
    # The compiler target keeps the binary floor in sync with
    # LSMinimumSystemVersion below.
    target = f"arm64-apple-macos{deployment_target}"
    app_dir = Path.cwd() / "build/app" / f"{app_name}.app"
    (app_dir / "Contents/MacOS").mkdir(parents=True, exist_ok=True)
    (app_dir / "Contents/Frameworks").mkdir(parents=True)
    app_binary = app_dir / "Contents/MacOS" / app_name

    # Fixed work directories, not mkdtemp(): random paths would end up in
    # debug info via __FILE__, making otherwise identical builds differ.
    plugin_dir = Path.cwd() / "build/macos/nixpkgs/plugins"
    package_config = Path.cwd() / ".dart_tool/package_config.json"
    collected = collect(str(package_config), str(plugin_dir))

    # Compile the Runner.
    runner_sources = sorted(Path("macos/Runner").glob("*.swift"))
    if runner_sources:
        runner_dir = plugin_dir.parent / "runner"
        runner_dir.mkdir(parents=True, exist_ok=True)
        for source in runner_sources:
            shutil.copyfile(source, runner_dir / source.name)
        compile_swift_runner(
            collected, plugin_dir, runner_dir, products_dir, app_binary, target
        )
    else:
        compile_objc_runner(collected, products_dir, app_binary, target)

    # Info.plist: substitute the $(...) placeholders of the template (keeping
    # any user-defined keys) and drop the nib entry.
    product_bundle_id = (
        xcconfig_lookup(app_info, "PRODUCT_BUNDLE_IDENTIFIER") or f"com.example.{pname}"
    )
    development_language = xcconfig_lookup(app_info, "DEVELOPMENT_LANGUAGE") or "en"
    generate_info_plist(
        "macos/Runner/Info.plist",
        str(app_dir / "Contents/Info.plist"),
        "pubspec.yaml",
        {
            "DEVELOPMENT_LANGUAGE": development_language,
            "EXECUTABLE_NAME": app_name,
            "PRODUCT_NAME": app_name,
            "PRODUCT_BUNDLE_IDENTIFIER": product_bundle_id,
            "MACOSX_DEPLOYMENT_TARGET": deployment_target,
            "PRODUCT_COPYRIGHT": xcconfig_lookup(app_info, "PRODUCT_COPYRIGHT"),
        },
    )
    embed_frameworks(collected, products_dir, app_dir)


def install() -> None:
    out = Path(os.environ["out"])
    pname = os.environ["pname"]

    (out / "app").mkdir(parents=True)
    (out / "bin").mkdir(parents=True)
    bundles = sorted(Path.cwd().glob("build/app/*.app"))
    if len(bundles) != 1:
        sys.exit(f"error: expected exactly one app bundle, found {bundles}")
    for app in bundles:
        shutil.move(str(app), str(out / "app" / app.name))

    # Binaries in $out/bin would otherwise be symlinks into the .app; macOS
    # resolves the main bundle from the executable path and a symlink (or
    # wrapper script) breaks that resolution, losing Info.plist/flutter_assets
    # lookups.  A plain `exec` keeps argv[0] at the binary's store path, so
    # the main bundle resolves correctly.  Name the wrapper after $pname
    # rather than the binary (PRODUCT_NAME may be capitalized, e.g. Saber) so
    # it stays stable across platforms for meta.mainProgram.
    # The single bundle was verified above; its binary feeds the wrapper.
    # Sorted so the choice is deterministic if a bundle ever ships more
    # than one file in MacOS/.
    binary = next(
        (
            candidate
            for candidate in sorted((out / "app").glob("*/Contents/MacOS/*"))
            if candidate.is_file()
        ),
        None,
    )
    if binary is None:
        sys.exit(f"error: no executable in {out}/app")
    wrapper = out / "bin" / pname
    # shlex.quote, not manual quoting: PRODUCT_NAME comes from the project's
    # xcconfig and must not be able to break out of the exec.
    wrapper.write_text(
        f'#!/bin/sh\nexec {shlex.quote(str(binary))} "$@"\n', encoding="utf-8"
    )
    wrapper.chmod(0o755)


def main() -> None:
    stages = {"build": build, "install": install}
    if len(sys.argv) != 2 or sys.argv[1] not in stages:
        sys.exit(f"usage: {sys.argv[0]} {{{','.join(stages)}}}")
    stages[sys.argv[1]]()


if __name__ == "__main__":
    main()
