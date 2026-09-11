#!/usr/bin/env nix-shell
#!nix-shell --pure -i python3 -p "python3.withPackages (ps: with ps; [ requests ])"

import json
import os
import requests
import sys

all_feature_versions = (8, 11, 17, 21, 25, 26)
oses = ("mac", "linux", "alpine-linux")
types = ("jre", "jdk")
impls = ("hotspot",)

arch_to_nixos = {
    "x64": ("x86_64",),
    "aarch64": ("aarch64",),
    "arm": ("armv6l", "armv7l"),
    "ppc64le": ("powerpc64le",),
    "riscv64": ("riscv64",),
}

def generate_sources(assets, feature_version, out):
    for asset in assets:
        binary = asset["binary"]
        if binary["os"] not in oses: continue
        if binary["image_type"] not in types: continue
        if binary["jvm_impl"] not in impls: continue
        if binary["heap_size"] != "normal": continue
        if binary["architecture"] not in arch_to_nixos: continue

        version = ".".join(str(v) for v in [
            asset["version"]["major"],
            asset["version"]["minor"],
            asset["version"]["security"]
        ])
        build = str(asset["version"]["build"])

        arch_map = (
            out
            .setdefault(binary["jvm_impl"], {})
            .setdefault(binary["os"], {})
            .setdefault(binary["image_type"], {})
            .setdefault(feature_version, {
                "packageType": binary["image_type"],
                "vmType": binary["jvm_impl"],
            })
        )

        for nixos_arch in arch_to_nixos[binary["architecture"]]:
            arch_map[nixos_arch] = {
                "url": binary["package"]["link"],
                "sha256": binary["package"]["checksum"],
                "version": version,
                "build": build,
            }

    return out


# Parse optional version arguments; default to all known versions.
# This is especially helpful when adding a new version without updating everything..
if len(sys.argv) > 1:
    try:
        feature_versions = tuple(int(v) for v in sys.argv[1:])
    except ValueError:
        print(f"usage: {sys.argv[0]} [version ...]", file=sys.stderr)
        print(f"  version: one or more feature version numbers, e.g. 21 25", file=sys.stderr)
        sys.exit(1)
    unknown = [v for v in feature_versions if v not in all_feature_versions]
    if unknown:
        print(f"warning: unknown feature version(s): {', '.join(str(v) for v in unknown)}", file=sys.stderr)
else:
    feature_versions = all_feature_versions

sources_path = os.path.join(os.path.dirname(__file__), "sources.json")

# Load existing sources so unrelated versions are preserved during partial updates.
try:
    with open(sources_path) as f:
        out = json.load(f)
except FileNotFoundError:
    out = {}

for feature_version in feature_versions:
    # Default user-agent is blocked by Azure WAF.
    headers = {'user-agent': 'nixpkgs-temurin-generate-sources/1.0.0'}
    resp = requests.get(f"https://api.adoptium.net/v3/assets/latest/{feature_version}/hotspot", headers=headers)

    if resp.status_code != 200:
        print("error: could not fetch data for release {} (code {}) {}".format(feature_version, resp.status_code, resp.content), file=sys.stderr)
        sys.exit(1)
    generate_sources(resp.json(), f"openjdk{feature_version}", out)

with open(sources_path, "w") as f:
    json.dump(out, f, indent=2, sort_keys=True)
    f.write('\n')
