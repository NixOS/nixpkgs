#!/usr/bin/env nix-shell
#!nix-shell --pure -i python3 -p "python3.withPackages (ps: with ps; [ requests semver ])"

import json
import requests
import sys
import semver

releases = ["openjdk11", "openjdk8"]
oses = ["mac", "linux"]
types = ["jre", "jdk"]
impls = ["hotspot", "openj9"]

arch_to_nixos = {
    "x64": "x86_64",
    "aarch64": "aarch64",
}

def get_sha256(url):
    resp = requests.get(url)
    if resp.status_code != 200:
        print("error: could not fetch checksum from url {}: code {}".format(url, resp.code), file=sys.stderr)
        sys.exit(1)
    return resp.text.strip().split(" ")[0]

def generate_sources(release, assets):
    out = {}
    for asset in assets:
        if asset["os"] not in oses: continue
        if asset["binary_type"] not in types: continue
        if asset["openjdk_impl"] not in impls: continue
        if asset["heap_size"] != "normal": continue
        if asset["architecture"] not in arch_to_nixos: continue
        vi = semver.VersionInfo.parse(asset['version_data']['semver'])
        version = '{0.major}.{0.minor}.{0.patch}'.format(vi)
        build = vi.build
        type_map = out.setdefault(asset["os"], {})
        impl_map = type_map.setdefault(asset["binary_type"], {})
        arch_map = impl_map.setdefault(asset["openjdk_impl"], {
            "packageType": asset["binary_type"],
            "vmType": asset["openjdk_impl"],
        })

        arch_map[arch_to_nixos[asset["architecture"]]] = {
            "url": asset["binary_link"],
            "sha256": get_sha256(asset["checksum_link"]),
            "version": version,
            "build": build,
        }

    return out

out = {}
for release in releases:
    resp = requests.get("https://api.adoptopenjdk.net/v2/latestAssets/releases/" + release)
    if resp.status_code != 200:
        print("error: could not fetch data for release {} (code {})".format(release, resp.code), file=sys.stderr)
        sys.exit(1)
    out[release] = generate_sources(release, resp.json())

with open("sources.json", "w") as f:
    json.dump(out, f, indent=2, sort_keys=True)
