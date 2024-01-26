#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.pyyaml

import shutil
import json
import urllib.request
import tempfile
from sys import exit
import os
import subprocess
import re
import json
import argparse
import yaml
import json


NIXPKGS_ROOT = subprocess.Popen(['git',
                                 'rev-parse',
                                 '--show-toplevel'],
                                stdout=subprocess.PIPE,
                                text=True).communicate()[0].strip()


def load_code(name, **kwargs):
    with open(f"{NIXPKGS_ROOT}/pkgs/development/compilers/flutter/update/{name}", 'r') as f:
        code = f.read()

    for (key, value) in kwargs.items():
        code = code.replace(f"@{key}@", value)

    return code


# Return out paths
def nix_build(code):
    temp = tempfile.NamedTemporaryFile(mode='w')
    temp.write(code)
    temp.flush()
    os.fsync(temp.fileno())

    process = subprocess.Popen(
        [
            "nix-build",
            "--impure",
            "--no-out-link",
            "--expr",
            f"with import {NIXPKGS_ROOT} {{}}; callPackage {temp.name} {{}}"],
        stdout=subprocess.PIPE,
        text=True)

    process.wait()
    temp.close()
    return process.stdout.read().strip().splitlines()[0]


# Return errors
def nix_build_to_fail(code):
    temp = tempfile.NamedTemporaryFile(mode='w')
    temp.write(code)
    temp.flush()
    os.fsync(temp.fileno())

    process = subprocess.Popen(
        [
            "nix-build",
            "--impure",
            "--keep-going",
            "--no-link",
            "--expr",
            f"with import {NIXPKGS_ROOT} {{}}; callPackage {temp.name} {{}}"],
        stderr=subprocess.PIPE,
        text=True)

    stderr = ""
    while True:
        line = process.stderr.readline()
        if not line:
            break
        stderr += line
        print(line.strip())

    process.wait()
    temp.close()
    return stderr


def get_artifact_hashes(flutter_compact_version):
    code = load_code("get-artifact-hashes.nix",
                     nixpkgs_root=NIXPKGS_ROOT,
                     flutter_compact_version=flutter_compact_version)

    stderr = nix_build_to_fail(code)

    pattern = re.compile(
        r"/nix/store/.*-flutter-artifacts-(.+?)-(.+?).drv':\n\s+specified: .*\n\s+got:\s+(.+?)\n")
    matches = pattern.findall(stderr)
    result_dict = {}

    for match in matches:
        flutter_platform, architecture, got = match
        result_dict.setdefault(flutter_platform, {})[architecture] = got

    def sort_dict_recursive(d):
        return {
            k: sort_dict_recursive(v) if isinstance(
                v, dict) else v for k, v in sorted(
                d.items())}
    result_dict = sort_dict_recursive(result_dict)

    return result_dict


def get_dart_hashes(dart_version):
    platforms = [
        "x86_64-linux",
        "aarch64-linux",
        "x86_64-darwin",
        "aarch64-darwin"]
    result_dict = {}
    for platform in platforms:
        code = load_code(
            "get-dart-hashes.nix",
            dart_version=dart_version,
            platform=platform)
        stderr = nix_build_to_fail(code)

        pattern = re.compile(r"got:\s+(.+?)\n")
        result_dict[platform] = pattern.findall(stderr)[0]

    return result_dict


def get_flutter_hash_and_src(flutter_version):
    code = load_code(
        "get-flutter.nix",
        flutter_version=flutter_version,
        hash="")

    stderr = nix_build_to_fail(code)
    pattern = re.compile(r"got:\s+(.+?)\n")
    hash = pattern.findall(stderr)[0]

    code = load_code(
        "get-flutter.nix",
        flutter_version=flutter_version,
        hash=hash)

    return (hash, nix_build(code))


def get_pubspec_lock(flutter_compact_version, flutter_src):
    code = load_code(
        "get-pubspec-lock.nix",
        flutter_compact_version=flutter_compact_version,
        flutter_src=flutter_src,
        hash="")

    stderr = nix_build_to_fail(code)
    pattern = re.compile(r"got:\s+(.+?)\n")
    hash = pattern.findall(stderr)[0]

    code = load_code(
        "get-pubspec-lock.nix",
        flutter_compact_version=flutter_compact_version,
        flutter_src=flutter_src,
        hash=hash)

    pubspec_lock_file = nix_build(code)

    with open(pubspec_lock_file, 'r') as f:
        pubspec_lock_yaml = f.read()

    return yaml.safe_load(pubspec_lock_yaml)


def write_data(
        nixpkgs_flutter_version_directory,
        flutter_version,
        engine_hash,
        dart_version,
        dart_hash,
        flutter_hash,
        artifact_hashes,
        pubspec_lock):
    with open(f"{nixpkgs_flutter_version_directory}/data.json", "w") as f:
        f.write(json.dumps({
            "version": flutter_version,
            "engineVersion": engine_hash,
            "dartVersion": dart_version,
            "dartHash": dart_hash,
            "flutterHash": flutter_hash,
            "artifactHashes": artifact_hashes,
            "pubspecLock": pubspec_lock,
        }, indent=2).strip() + "\n")


def update_all_packages():
    versions_directory = f"{NIXPKGS_ROOT}/pkgs/development/compilers/flutter/versions"
    versions = [directory for directory in os.listdir(versions_directory)]
    versions = sorted(versions, key=lambda x: (
        int(x.split('_')[0]), int(x.split('_')[1])), reverse=True)

    new_content = [
        "flutterPackages = recurseIntoAttrs (callPackage ../development/compilers/flutter { });",
        "flutter = flutterPackages.stable;",
    ] + [f"flutter{version.replace('_', '')} = flutterPackages.v{version};" for version in versions]

    with open(f"{NIXPKGS_ROOT}/pkgs/top-level/all-packages.nix", 'r') as file:
        lines = file.read().splitlines(keepends=True)

    start = -1
    end = -1
    for i, line in enumerate(lines):
        if "flutterPackages = recurseIntoAttrs (callPackage ../development/compilers/flutter { });" in line:
            start = i
        if start != -1 and len(line.strip()) == 0:
            end = i
            break

    if start != -1 and end != -1:
        del lines[start:end]
        lines[start:start] = [f"  {l}\n" for l in new_content]

    with open(f"{NIXPKGS_ROOT}/pkgs/top-level/all-packages.nix", 'w') as file:
        file.write("".join(lines))


# Finds Flutter version, Dart version, and Engine hash.
# If the Flutter version is given, it uses that. Otherwise finds the
# latest stable Flutter version.
def find_versions(flutter_version=None):
    engine_hash = None
    dart_version = None

    releases = json.load(urllib.request.urlopen(
        "https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json"))

    if not flutter_version:
        stable_hash = releases['current_release']['stable']
        release = next(
            filter(
                lambda release: release['hash'] == stable_hash,
                releases['releases']))
        flutter_version = release['version']

    tags = subprocess.Popen(['git',
                             'ls-remote',
                             '--tags',
                             'https://github.com/flutter/engine.git'],
                            stdout=subprocess.PIPE,
                            text=True).communicate()[0].strip()

    try:
        engine_hash = next(
            filter(
                lambda line: line.endswith(f'refs/tags/{flutter_version}'),
                tags.splitlines())).split('refs')[0].strip()
    except StopIteration:
        exit(
            f"Couldn't find Engine hash for Flutter version: {flutter_version}")

    try:
        dart_version = next(
            filter(
                lambda release: release['version'] == flutter_version,
                releases['releases']))['dart_sdk_version']
    except StopIteration:
        exit(
            f"Couldn't find Dart version for Flutter version: {flutter_version}")

    return (flutter_version, engine_hash, dart_version)


def main():
    parser = argparse.ArgumentParser(description='Update Flutter in Nixpkgs')
    parser.add_argument('--version', type=str, help='Specify Flutter version')
    parser.add_argument('--artifact-hashes', action='store_true',
                        help='Whether to get artifact hashes')
    args = parser.parse_args()

    (flutter_version, engine_hash, dart_version) = find_versions(args.version)

    flutter_compact_version = '_'.join(flutter_version.split('.')[:2])

    if args.artifact_hashes:
        print(
            json.dumps(
                get_artifact_hashes(flutter_compact_version),
                indent=2).strip() +
            "\n")
        return

    print(f"Flutter version: {flutter_version} ({flutter_compact_version})")
    print(f"Engine hash: {engine_hash}")
    print(f"Dart version: {dart_version}")

    dart_hash = get_dart_hashes(dart_version)
    (flutter_hash, flutter_src) = get_flutter_hash_and_src(flutter_version)

    nixpkgs_flutter_version_directory = f"{NIXPKGS_ROOT}/pkgs/development/compilers/flutter/versions/{flutter_compact_version}"

    if os.path.exists(f"{nixpkgs_flutter_version_directory}/data.json"):
        os.remove(f"{nixpkgs_flutter_version_directory}/data.json")
    os.makedirs(nixpkgs_flutter_version_directory, exist_ok=True)

    update_all_packages()

    common_data_args = {
        "nixpkgs_flutter_version_directory": nixpkgs_flutter_version_directory,
        "flutter_version": flutter_version,
        "dart_version": dart_version,
        "engine_hash": engine_hash,
        "flutter_hash": flutter_hash,
        "dart_hash": dart_hash,
    }

    write_data(
        pubspec_lock={},
        artifact_hashes={},
        **common_data_args)

    pubspec_lock = get_pubspec_lock(flutter_compact_version, flutter_src)

    write_data(
        pubspec_lock=pubspec_lock,
        artifact_hashes={},
        **common_data_args)

    artifact_hashes = get_artifact_hashes(flutter_compact_version)

    write_data(
        pubspec_lock=pubspec_lock,
        artifact_hashes=artifact_hashes,
        **common_data_args)


if __name__ == "__main__":
    main()
