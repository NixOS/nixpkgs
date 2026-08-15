#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 nix dpkg

import json
import re
import subprocess
import urllib.request
from pathlib import Path

PKG_DIR = Path(__file__).resolve().parent
PACKAGE_NIX = PKG_DIR / "package.nix"

CHROME_RELEASE_API = "https://chromiumdash.appspot.com/fetch_releases?channel=Stable&platform=Linux&num=1"

def get_latest_chrome_version() -> str:
    req = urllib.request.Request(
        CHROME_RELEASE_API,
        headers={"User-Agent": "Mozilla/5.0 (compatible; nixpkgs-update/1.0)"}
    )
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode("utf-8"))
        return data[0]["version"]

def get_widevine_version(deb_path: Path) -> str:
    raw = subprocess.check_output(
        f"dpkg-deb --fsys-tarfile {deb_path} | tar -xOf - --wildcards '*WidevineCdm/manifest.json'",
        shell=True
    )
    return json.loads(raw)["version"]

def prefetch(url: str) -> tuple[str, Path]:
    output = subprocess.check_output(
        ["nix-prefetch-url", "--print-path", "--type", "sha256", url],
        text=True
    ).strip().splitlines()
    hash = output[0].strip()
    store_path = Path(output[-1].strip())

    sri = subprocess.check_output(
        ["nix", "hash", "convert", "--hash-algo", "sha256", "--to", "sri", hash],
        text=True
    ).strip()

    return sri, store_path

def main() -> None:
    chromeVersion = get_latest_chrome_version()
    print(f"Latest Google Chrome Version: {chromeVersion}")

    deb_urls = {
        "amd64": f"https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_{chromeVersion}-1_amd64.deb",
        "arm64": f"https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_{chromeVersion}-1_arm64.deb",
    }

    print("Prefetching.")
    hashes: dict[str, str] = {}
    widevineVersion: str | None = None

    for arch, url in deb_urls.items():
        print(f"  Prefetching {arch} from {url}")
        hashes[arch], store_path = prefetch(url)
        if not widevineVersion:
            widevineVersion = get_widevine_version(store_path)

    print(f"Widevine version: {widevineVersion}")

    content = PACKAGE_NIX.read_text()

    content = re.sub(r'version = "[^"]+";', f'version = "{widevineVersion}";', content, count=1)
    content = re.sub(r'googleChromeVersion = "[^"]+";', f'googleChromeVersion = "{chromeVersion}";', content, count=1)

    content = re.sub(r'(x86_64-linux\s*=\s*\{[^}]*?hash\s*=\s*")[^"]+(";)', rf'\g<1>{hashes["amd64"]}\g<2>', content, flags=re.DOTALL)
    content = re.sub(r'(aarch64-linux\s*=\s*\{[^}]*?hash\s*=\s*")[^"]+(";)', rf'\g<1>{hashes["arm64"]}\g<2>', content, flags=re.DOTALL)

    _ = PACKAGE_NIX.write_text(content)
    print("Widevine updated.")

if __name__ == "__main__":
    main()
