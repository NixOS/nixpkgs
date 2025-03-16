#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ ps.httpx ps.socksio ])"

import json
import os
import pathlib
import re
import subprocess

import httpx

platforms = {
    "x86_64-linux": "linux-x86_64",
    "aarch64-linux": "linux-arm64",
    "x86_64-darwin": "darwin-x86_64",
    "aarch64-darwin": "darwin-arm64",
}


def main():
    headers = {}
    token = os.getenv("GITHUB_TOKEN")
    if token is not None:
        headers["Authorization"] = "Bearer {}".format(token)

    resp = httpx.get(
        "https://trunk.io/releases/latest",
        headers=headers,
    )

    version_match = re.search(r"version:\s*(\d+\.\d+\.\d+)", resp.text)
    if not version_match:
        raise ValueError("Could not find version in response")

    version = version_match.group(1)

    assets = {
        "version": version,
        "assets": {},
    }

    for k, v in platforms.items():
        url = f"https://trunk.io/releases/{version}/trunk-{version}-{v}.tar.gz"

        process = subprocess.run(
            ["nix-prefetch-url", "--type", "sha256", url],
            capture_output=True,
            text=True,
        )

        process.check_returncode()

        process = subprocess.run(
            ["nix-hash", "--type", "sha256", "--to-sri", process.stdout.rstrip()],
            capture_output=True,
            text=True,
        )

        process.check_returncode()

        hash = process.stdout.rstrip()
        assets["assets"][k] = {
            "url": url,
            "hash": hash,
        }

    (pathlib.Path(__file__).parent / "manifest.json").write_text(
        json.dumps(assets, indent=2) + "\n"
    )


if __name__ == "__main__":
    main()
