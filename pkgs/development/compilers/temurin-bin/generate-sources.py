#!/usr/bin/env nix-shell
#!nix-shell --pure -i python3 -p "python3.withPackages (ps: with ps; [ requests ])"

import json
import re
import requests
import sys

feature_versions = (8, 11, 16, 17, 18, 19, 20, 21, 22)
oses = ("mac", "linux", "alpine-linux")
types = ("jre", "jdk")
impls = ("hotspot",)

arch_to_nixos = {
    "x64": ("x86_64",),
    "aarch64": ("aarch64",),
    "arm": ("armv6l", "armv7l"),
    "ppc64le": ("powerpc64le",),
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


out = {}
for feature_version in feature_versions:
    # Default user-agenet is blocked by Azure WAF.
    headers = {'user-agent': 'nixpkgs-temurin-generate-sources/1.0.0'}
    resp = requests.get(f"https://api.adoptium.net/v3/assets/latest/{feature_version}/hotspot", headers=headers)

    if resp.status_code != 200:
        print("error: could not fetch data for release {} (code {}) {}".format(feature_version, resp.status_code, resp.content), file=sys.stderr)
        sys.exit(1)
    generate_sources(resp.json(), f"openjdk{feature_version}", out)

with open("sources.json", "w") as f:
    json.dump(out, f, indent=2, sort_keys=True)
    f.write('\n')
