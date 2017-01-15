#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python36 python36Packages.pytoml python36Packages.requests2 nix-prefetch-git
import sys
import os
import re
import json
import pytoml as toml
import requests
import subprocess
from tempfile import NamedTemporaryFile

SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))

def download_channel(channel):
    url = f"https://static.rust-lang.org/dist/channel-rust-{channel}.toml"
    sig_url = url + ".asc"
    resp = requests.get(url)
    manifest = toml.loads(resp.text)
    version = manifest["manifest-version"]
    assert version == "2", f"unknown manifest version {version}, update this script!"
    return manifest

def prefetch_cargo(revision, version):
    url = f"https://github.com/rust-lang/cargo"
    sha256 = json.loads(subprocess.check_output(["nix-prefetch-git", url, revision]))["sha256"]
    return dict(url=url,
                revision=revision,
                sha256=sha256.strip(),
                version=version)

PLATFORMS = {
    "*": "all", # rust-src
    "x86_64-unknown-linux-gnu": "x86_64-linux",
    "i686-unknown-linux-gnu": "i686-linux",
    "x86_64-apple-darwin": "x86_64-darwin",
}

def main():
    channels = {}
    for channel in ["stable", "beta", "nightly"]:
        manifest = download_channel(channel)
        channels[channel] = {}
        for name in ["rust", "rust-src", "rust-docs", "cargo"]:
            channels[channel][name] = {}
            pkg = manifest["pkg"][name]
            version_parts = re.split(r"[ ()]+", pkg["version"])
            if channel == "stable":
                version = version_parts[0]
            else:
                version = f"{channel}-{manifest['date']}"
            revision = version_parts[1]
            for key, value in pkg["target"].items():
                if key not in PLATFORMS:
                    continue
                sha256 = pkg["target"][key]["hash"]
                url = pkg["target"][key]["url"]
                data = dict(version=version, sha256=sha256, url=url, revision=revision)
                channels[channel][name][PLATFORMS[key]] = data

        cargo = channels[channel]["cargo"]["x86_64-linux"]
        version = cargo["version"]
        if channel == "stable":
            version = version.replace("-nightly", "")
        channels[channel]["cargo-src"] = dict(all=prefetch_cargo(cargo["revision"],
                                                                 version))

    with open(os.path.join(SCRIPT_PATH, "sources.json"), "w+") as f:
        json.dump(channels, f, indent=4, sort_keys=True)

if __name__ == "__main__":
    main()
