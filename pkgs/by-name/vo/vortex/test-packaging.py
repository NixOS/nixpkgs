import argparse
import base64
import configparser
import hashlib
import importlib.util
import json
import os
import re
import shlex
import subprocess
import sys
import tempfile
from pathlib import Path


def check_desktop_handler(package: Path, source: Path, temporary: Path) -> None:
    registration = (
        source / "src/renderer/src/util/protocolRegistration/linux/nxm.ts"
    ).read_text()
    match = re.search(r'const PACKAGE_DESKTOP_ID = "([^"]+)";', registration)
    if match is None:
        raise AssertionError("Upstream package desktop ID was not found")

    handler = package / "share/applications" / match[1]
    application = package / "share/applications/vortex.desktop"
    if not handler.is_file():
        raise AssertionError(f"Vortex registers a missing desktop entry: {handler.name}")

    for desktop in [application, handler]:
        subprocess.run(["desktop-file-validate", desktop], check=True)

    entry = configparser.ConfigParser(interpolation=None)
    entry.read(handler)
    assert shlex.split(entry["Desktop Entry"]["Exec"]) == ["vortex-nxm", "%u"]
    assert "x-scheme-handler/nxm" in entry["Desktop Entry"]["MimeType"].split(";")
    assert entry["Desktop Entry"].getboolean("NoDisplay")
    entry.clear()
    entry.read(application)
    assert shlex.split(entry["Desktop Entry"]["Exec"]) == ["vortex"]
    assert not entry["Desktop Entry"].getboolean("NoDisplay", fallback=False)

    # Exercise the installed NXM wrapper, replacing only its Electron-launching
    # target with an argument recorder so no GUI session is needed.
    recorder = temporary / "record-arguments"
    recorder.write_text(
        f"#!{sys.executable}\n"
        "import json, os, sys\n"
        "with open(os.environ['CAPTURE'], 'w') as output:\n"
        "    json.dump(sys.argv[1:], output)\n"
    )
    recorder.chmod(0o755)
    wrapper = (package / "bin/vortex-nxm").read_text()
    target = str(package / "bin/vortex")
    assert target in wrapper, "NXM wrapper no longer delegates to the main launcher"
    executable = temporary / "vortex-nxm"
    executable.write_text(wrapper.replace(target, str(recorder)))
    executable.chmod(0o755)
    capture = temporary / "arguments.json"
    url = "nxm://example/mods/123/files/456?key=a b&expires=1"
    subprocess.run(
        [executable, url],
        check=True,
        env={**os.environ, "CAPTURE": str(capture)},
    )
    assert json.loads(capture.read_text()) == ["--download", url]
    print("NXM desktop registration and wrapper argument forwarding passed")


def check_dependency_pins(args: argparse.Namespace, temporary: Path) -> None:
    spec = importlib.util.spec_from_file_location("vortex_pnpm_lock", args.helper)
    assert spec is not None and spec.loader is not None
    helper = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = helper
    spec.loader.exec_module(helper)

    pins = json.loads(args.pins.read_text())
    archives = {
        (dep["repository"], dep["revision"]): Path(dep["archive"])
        for dep in json.loads(args.archives.read_text())
    }
    identities = {(dep["repository"], dep["revision"]) for dep in pins}
    assert len(identities) == len(pins), "Committed dependency pins contain duplicates"
    assert identities == archives.keys()

    for pin in pins:
        data = archives[(pin["repository"], pin["revision"])].read_bytes()
        algorithm, digest = pin["hash"].split("-", 1)
        assert hashlib.new(algorithm, data).digest() == base64.b64decode(digest)

    # Use the already fetched, hash-checked archives at the prefetch boundary.
    # The actual generator reads the pinned upstream YAML and writes its JSON;
    # this test does not discover releases or access the network.
    def prefetch(dep):
        data = archives[(dep.repository, dep.revision)].read_bytes()
        digest = base64.b64encode(hashlib.sha256(data).digest()).decode()
        return helper.LockedGitDependency(
            dep.repository, dep.revision, dep.url, f"sha256-{digest}"
        )

    helper.prefetch = prefetch
    generated = helper.generate_lockfile(args.source / "pnpm-lock.yaml")
    output = temporary / "generated-pins.json"
    helper.write_lockfile(generated, output)
    result = json.loads(output.read_text())
    assert {(dep["repository"], dep["revision"]) for dep in result} == identities
    assert len(result) == len(pins)
    urls = {(dep["repository"], dep["revision"]): dep["url"] for dep in pins}
    assert all(dep["url"] == urls[(dep["repository"], dep["revision"])] for dep in result)
    print(f"Pinned-source generator and archive hashes passed for {len(pins)} dependencies")


def main() -> None:
    parser = argparse.ArgumentParser()
    for name in ["package", "source", "pins", "helper", "archives"]:
        parser.add_argument(f"--{name}", required=True, type=Path)
    args = parser.parse_args()
    with tempfile.TemporaryDirectory() as directory:
        temporary = Path(directory)
        check_desktop_handler(args.package, args.source, temporary)
        check_dependency_pins(args, temporary)


if __name__ == "__main__":
    main()
