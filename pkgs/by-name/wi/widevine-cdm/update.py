#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import json
import re
import subprocess
import urllib.request
from pathlib import Path

PKG_DIR = Path(__file__).resolve().parent
PACKAGE_NIX = PKG_DIR / "package.nix"

CHROME_RELEASE_API = "https://chromiumdash.appspot.com/fetch_releases?channel=Stable&platform=Linux&num=1"

def get_latest_version() -> str:
    req = urllib.request.Request(
        CHROME_RELEASE_API,
        headers={"User-Agent": "Mozilla/5.0 (compatible; nixpkgs-update/1.0)"}
    )
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode("utf-8"))
        return data[0]["version"]

def prefetch_hash(url: str) -> str:
    hash = subprocess.check_output(
        ["nix-prefetch-url", "--type", "sha256", url],
        text=True
    ).strip()
    sri = subprocess.check_output(
        ["nix", "hash", "convert", "--hash-algo", "sha256", "--to", "sri", hash],
        text=True
    ).strip()
    return sri

def main() -> None:
    version = get_latest_version()
    print(f"Latest Google Chrome Version: {version}")

    deb_urls = {
        "amd64": f"https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_{version}-1_amd64.deb",
        "arm64": f"https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_{version}-1_arm64.deb",
    }

    print("Prefetching.")
    hashes = {}

    for arch, url in deb_urls.items():
        print(f"  Prefetching {arch} from {url}")
        hashes[arch] = prefetch_hash(url)

    content = PACKAGE_NIX.read_text()

    content = re.sub(r'version = "[^"]+";', f'version = "{version}";', content, count=1)

    content = re.sub(r'(x86_64-linux\s*=\s*\{[^}]*?hash\s*=\s*")[^"]+(";)', rf'\g<1>{hashes["amd64"]}\g<2>', content, flags=re.DOTALL)

    content = re.sub(r'(aarch64-linux\s*=\s*\{[^}]*?hash\s*=\s*")[^"]+(";)', rf'\g<1>{hashes["arm64"]}\g<2>', content, flags=re.DOTALL)

    PACKAGE_NIX.write_text(content)
    print("Widevine updated.")

if __name__ == "__main__":
    main()
