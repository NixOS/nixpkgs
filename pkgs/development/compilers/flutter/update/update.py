#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.pyyaml

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
import urllib.request
from pathlib import Path

import yaml

FAKE_HASH = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

NIXPKGS_ROOT = (
    subprocess.Popen(
        ["git", "rev-parse", "--show-toplevel"], stdout=subprocess.PIPE, text=True
    )
    .communicate()[0]
    .strip()
)


def load_code(name, **kwargs):
    with Path(
        f"{NIXPKGS_ROOT}/pkgs/development/compilers/flutter/update/{name}.in"
    ).open("r", encoding="utf-8") as f:
        code = f.read()

    for key, value in kwargs.items():
        code = code.replace(f"@{key}@", value)

    return code


# Return out paths
def nix_build(code):
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", delete=False) as temp:
        temp.write(code)
        temp.flush()
        os.fsync(temp.fileno())
    temp_name = temp.name

    process = subprocess.Popen(
        [
            "nix-build",
            "--impure",
            "--no-out-link",
            "--expr",
            f"with import {NIXPKGS_ROOT} {{}}; callPackage {temp_name} {{}}",
        ],
        stdout=subprocess.PIPE,
        text=True,
    )

    process.wait()
    Path(temp_name).unlink()  # Clean up the temporary file
    return process.stdout.read().strip().splitlines()[0]


# Return errors
def nix_build_to_fail(code):
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", delete=False) as temp:
        temp.write(code)
        temp.flush()
        os.fsync(temp.fileno())
    temp_name = temp.name

    process = subprocess.Popen(
        [
            "nix-build",
            "--impure",
            "--keep-going",
            "--no-link",
            "--expr",
            f"with import {NIXPKGS_ROOT} {{}}; callPackage {temp_name} {{}}",
        ],
        stderr=subprocess.PIPE,
        text=True,
    )

    stderr = ""
    while True:
        line = process.stderr.readline()
        if not line:
            break
        stderr += line
        print(line.strip())

    process.wait()
    Path(temp_name).unlink()  # Clean up the temporary file
    return stderr


def get_engine_hashes(engine_version, flutter_version):
    code = load_code(
        "get-engine-hashes.nix",
        nixpkgs_root=NIXPKGS_ROOT,
        flutter_version=flutter_version,
        engine_version=engine_version,
    )

    stderr = nix_build_to_fail(code)

    pattern = re.compile(
        rf"/nix/store/.*-flutter-engine-source-{engine_version}-(.+?-.+?)-(.+?-.+?).drv':\n\s+specified: .*\n\s+got:\s+(.+?)\n"
    )
    matches = pattern.findall(stderr)
    result_dict = {}

    for match in matches:
        flutter_platform, architecture, got = match
        result_dict.setdefault(flutter_platform, {})[architecture] = got

    def sort_dict_recursive(d):
        return {
            k: sort_dict_recursive(v) if isinstance(v, dict) else v
            for k, v in sorted(d.items())
        }

    return sort_dict_recursive(result_dict)


def get_artifact_hashes(flutter_compact_version):
    code = load_code(
        "get-artifact-hashes.nix",
        nixpkgs_root=NIXPKGS_ROOT,
        flutter_compact_version=flutter_compact_version,
    )

    stderr = nix_build_to_fail(code)

    pattern = re.compile(
        r"/nix/store/.*-flutter-artifacts-(.+?)-(.+?).drv':\n\s+specified: .*\n\s+got:\s+(.+?)\n"
    )
    matches = pattern.findall(stderr)
    result_dict = {}

    for match in matches:
        flutter_platform, architecture, got = match
        result_dict.setdefault(flutter_platform, {})[architecture] = got

    def sort_dict_recursive(d):
        return {
            k: sort_dict_recursive(v) if isinstance(v, dict) else v
            for k, v in sorted(d.items())
        }

    return sort_dict_recursive(result_dict)


def get_dart_hashes(dart_version, channel):
    platforms = ["x86_64-linux", "aarch64-linux", "x86_64-darwin", "aarch64-darwin"]
    result_dict = {}
    for platform in platforms:
        code = load_code(
            "get-dart-hashes.nix",
            dart_version=dart_version,
            channel=channel,
            platform=platform,
        )
        stderr = nix_build_to_fail(code)

        pattern = re.compile(r"got:\s+(.+?)\n")
        result_dict[platform] = pattern.findall(stderr)[0]

    return result_dict


def get_flutter_hash_and_src(flutter_version):
    code = load_code("get-flutter.nix", flutter_version=flutter_version, hash="")

    stderr = nix_build_to_fail(code)
    pattern = re.compile(r"got:\s+(.+?)\n")
    flutter_hash_value = pattern.findall(stderr)[0]

    code = load_code(
        "get-flutter.nix", flutter_version=flutter_version, hash=flutter_hash_value
    )

    return (flutter_hash_value, nix_build(code))


def get_pubspec_lock(flutter_compact_version, flutter_src):
    code = load_code(
        "get-pubspec-lock.nix",
        flutter_compact_version=flutter_compact_version,
        flutter_src=flutter_src,
        hash="",
    )

    stderr = nix_build_to_fail(code)
    pattern = re.compile(r"got:\s+(.+?)\n")
    pubspec_lock_hash = pattern.findall(stderr)[0]

    code = load_code(
        "get-pubspec-lock.nix",
        flutter_compact_version=flutter_compact_version,
        flutter_src=flutter_src,
        hash=pubspec_lock_hash,
    )

    pubspec_lock_file = nix_build(code)

    with Path(pubspec_lock_file).open("r", encoding="utf-8") as f:
        pubspec_lock_yaml = f.read()

    return yaml.safe_load(pubspec_lock_yaml)


def get_engine_swiftshader_rev(engine_version):
    with urllib.request.urlopen(
        f"https://github.com/flutter/flutter/raw/{engine_version}/DEPS"
    ) as f:
        deps = f.read().decode("utf-8")
        pattern = re.compile(
            r"Var\('swiftshader_git'\) \+ '\/SwiftShader\.git' \+ '@' \+ \'([0-9a-fA-F]{40})\'\,"
        )
        return pattern.findall(deps)[0]


def get_engine_swiftshader_hash(engine_swiftshader_rev):
    code = load_code(
        "get-engine-swiftshader.nix",
        engine_swiftshader_rev=engine_swiftshader_rev,
        hash="",
    )

    stderr = nix_build_to_fail(code)
    pattern = re.compile(r"got:\s+(.+?)\n")
    return pattern.findall(stderr)[0]


def write_data(
    nixpkgs_flutter_version_directory,
    flutter_version,
    channel,
    engine_hash,
    engine_hashes,
    engine_swiftshader_hash,
    engine_swiftshader_rev,
    dart_version,
    dart_hash,
    flutter_hash,
    artifact_hashes,
    pubspec_lock,
):
    with Path(f"{nixpkgs_flutter_version_directory}/data.json").open(
        "w", encoding="utf-8"
    ) as f:
        f.write(
            json.dumps(
                {
                    "version": flutter_version,
                    "engineVersion": engine_hash,
                    "engineSwiftShaderHash": engine_swiftshader_hash,
                    "engineSwiftShaderRev": engine_swiftshader_rev,
                    "channel": channel,
                    "engineHashes": engine_hashes,
                    "dartVersion": dart_version,
                    "dartHash": dart_hash,
                    "flutterHash": flutter_hash,
                    "artifactHashes": artifact_hashes,
                    "pubspecLock": pubspec_lock,
                },
                indent=2,
            ).strip()
            + "\n"
        )


def update_all_packages():
    versions_directory = f"{NIXPKGS_ROOT}/pkgs/development/compilers/flutter/versions"
    versions = [d.name for d in Path(versions_directory).iterdir()]
    versions = sorted(
        versions,
        key=lambda x: (int(x.split("_")[0]), int(x.split("_")[1])),
        reverse=True,
    )

    new_content = [
        "flutterPackages-bin = recurseIntoAttrs (callPackage ../development/compilers/flutter { });",
        "flutterPackages-source = recurseIntoAttrs (",
        "  callPackage ../development/compilers/flutter { useNixpkgsEngine = true; }",
        ");",
        "flutterPackages = flutterPackages-bin;",
        "flutter = flutterPackages.stable;",
    ] + [
        f"flutter{version.replace('_', '')} = flutterPackages.v{version};"
        for version in versions
    ]

    with Path(f"{NIXPKGS_ROOT}/pkgs/top-level/all-packages.nix").open(
        "r", encoding="utf-8"
    ) as file:
        lines = file.read().splitlines(keepends=True)

    start = -1
    end = -1
    for i, line in enumerate(lines):
        if (
            "flutterPackages-bin = recurseIntoAttrs (callPackage ../development/compilers/flutter { });"
            in line
        ):
            start = i
        if start != -1 and len(line.strip()) == 0:
            end = i
            break

    if start != -1 and end != -1:
        del lines[start:end]
        lines[start:start] = [f"  {line}\n" for line in new_content]

    with Path(f"{NIXPKGS_ROOT}/pkgs/top-level/all-packages.nix").open(
        "w", encoding="utf-8"
    ) as file:
        file.write("".join(lines))


# Finds Flutter version, Dart version, and Engine hash.
# If the Flutter version is given, it uses that. Otherwise finds the
# latest stable Flutter version.
def find_versions(flutter_version=None, channel=None):
    engine_hash = None
    dart_version = None

    releases = json.load(
        urllib.request.urlopen(
            "https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json"
        )
    )

    if not channel:
        channel = "stable"

    if not flutter_version:
        release_hash = releases["current_release"][channel]
        release = next(
            filter(
                lambda release: release["hash"] == release_hash, releases["releases"]
            )
        )
        flutter_version = release["version"]

    tags = (
        subprocess.Popen(
            ["git", "ls-remote", "--tags", "https://github.com/flutter/flutter.git"],
            stdout=subprocess.PIPE,
            text=True,
        )
        .communicate()[0]
        .strip()
    )

    try:
        flutter_hash = (
            next(
                filter(
                    lambda line: line.endswith(f"refs/tags/{flutter_version}"),
                    tags.splitlines(),
                )
            )
            .split("refs")[0]
            .strip()
        )

        engine_hash = (
            urllib.request.urlopen(
                f"https://github.com/flutter/flutter/raw/{flutter_hash}/bin/internal/engine.version"
            )
            .read()
            .decode("utf-8")
            .strip()
        )
    except StopIteration:
        sys.exit(f"Couldn't find Engine hash for Flutter version: {flutter_version}")

    try:
        dart_version = next(
            filter(
                lambda release: release["version"] == flutter_version,
                releases["releases"],
            )
        )["dart_sdk_version"]

        if " " in dart_version:
            dart_version = dart_version.split(" ")[2][:-1]
    except StopIteration:
        sys.exit(f"Couldn't find Dart version for Flutter version: {flutter_version}")

    return (flutter_version, engine_hash, dart_version, channel)


def main():
    parser = argparse.ArgumentParser(description="Update Flutter in Nixpkgs")
    parser.add_argument("--version", type=str, help="Specify Flutter version")
    parser.add_argument("--channel", type=str, help="Specify Flutter release channel")
    parser.add_argument(
        "--artifact-hashes", action="store_true", help="Whether to get artifact hashes"
    )
    args = parser.parse_args()

    (flutter_version, engine_hash, dart_version, channel) = find_versions(
        args.version, args.channel
    )

    flutter_compact_version = "_".join(flutter_version.split(".")[:2])

    if args.artifact_hashes:
        print(
            json.dumps(get_artifact_hashes(flutter_compact_version), indent=2).strip()
            + "\n"
        )
        return

    print(
        f"Flutter version: {flutter_version} ({flutter_compact_version}) on ({channel})"
    )
    print(f"Engine hash: {engine_hash}")
    print(f"Dart version: {dart_version}")

    dart_hash = get_dart_hashes(dart_version, channel)
    (flutter_hash, flutter_src) = get_flutter_hash_and_src(flutter_version)

    nixpkgs_flutter_version_directory = f"{NIXPKGS_ROOT}/pkgs/development/compilers/flutter/versions/{flutter_compact_version}"

    if Path(f"{nixpkgs_flutter_version_directory}/data.json").exists():
        Path(f"{nixpkgs_flutter_version_directory}/data.json").unlink()
    Path(nixpkgs_flutter_version_directory).mkdir(parents=True, exist_ok=True)

    update_all_packages()

    common_data_args = {
        "nixpkgs_flutter_version_directory": nixpkgs_flutter_version_directory,
        "flutter_version": flutter_version,
        "channel": channel,
        "dart_version": dart_version,
        "engine_hash": engine_hash,
        "flutter_hash": flutter_hash,
        "dart_hash": dart_hash,
    }

    write_data(
        pubspec_lock={},
        artifact_hashes={},
        engine_hashes={},
        engine_swiftshader_hash=FAKE_HASH,
        engine_swiftshader_rev="0",
        **common_data_args,
    )

    pubspec_lock = get_pubspec_lock(flutter_compact_version, flutter_src)

    write_data(
        pubspec_lock=pubspec_lock,
        artifact_hashes={},
        engine_hashes={},
        engine_swiftshader_hash=FAKE_HASH,
        engine_swiftshader_rev="0",
        **common_data_args,
    )

    artifact_hashes = get_artifact_hashes(flutter_compact_version)

    write_data(
        pubspec_lock=pubspec_lock,
        artifact_hashes=artifact_hashes,
        engine_hashes={},
        engine_swiftshader_hash=FAKE_HASH,
        engine_swiftshader_rev="0",
        **common_data_args,
    )

    engine_hashes = get_engine_hashes(engine_hash, flutter_version)

    write_data(
        pubspec_lock=pubspec_lock,
        artifact_hashes=artifact_hashes,
        engine_hashes=engine_hashes,
        engine_swiftshader_hash=FAKE_HASH,
        engine_swiftshader_rev="0",
        **common_data_args,
    )

    engine_swiftshader_rev = get_engine_swiftshader_rev(engine_hash)
    engine_swiftshader_hash = get_engine_swiftshader_hash(engine_swiftshader_rev)

    write_data(
        pubspec_lock=pubspec_lock,
        artifact_hashes=artifact_hashes,
        engine_hashes=engine_hashes,
        engine_swiftshader_hash=engine_swiftshader_hash,
        engine_swiftshader_rev=engine_swiftshader_rev,
        **common_data_args,
    )


if __name__ == "__main__":
    main()
