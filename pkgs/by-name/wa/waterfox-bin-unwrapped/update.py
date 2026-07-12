#!/usr/bin/env nix-shell
#! nix-shell -i python3 --packages python3 prefetch-yarn-deps nix-prefetch-git nix-prefetch

import json
from pathlib import Path
from sys import stderr
from urllib.parse import quote
from urllib.request import Request, urlopen
from base64 import b64encode


def main() -> None:
    headers = {"User-Agent": "nixpkgs update.py"}

    print("Fetching latest release off GitHub", file=stderr)
    with urlopen(
        Request(
            "https://api.github.com/repos/BrowserWorks/waterfox/releases/latest",
            headers=headers,
        )
    ) as resp:
        latest = json.loads(resp.read().decode())
        tag = latest["tag_name"]

    sources = [
        ("Linux_x86_64", f"waterfox-{tag}.tar.bz2"),
        ("Darwin_x86_64-aarch64", f"Waterfox {tag}.dmg"),
    ]

    out = {"version": tag, "sources": []}

    print("Fetching hashes", file=stderr)
    for arch, filename in sources:
        src = f"https://cdn.waterfox.com/waterfox/releases/{quote(tag)}/{quote(arch)}/{quote(filename)}"
        with urlopen(Request(src + quote(".sha512"), headers=headers)) as resp:
            src_hash = resp.read().split(b"  ")[0].decode()

            out["sources"].append(
                {
                    "url": src,
                    "hash": f"sha512-{b64encode(bytes.fromhex(src_hash)).decode()}",
                    "arch": arch,
                }
            )

    (Path(__file__).parent / "version.json").write_text(
        json.dumps(out, indent=2) + "\n"
    )


if __name__ == "__main__":
    main()
