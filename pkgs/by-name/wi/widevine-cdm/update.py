#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 nix dpkg

import json
import re
import shutil
import subprocess
import urllib.request
import tempfile
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

def prefetch(url: str) -> tuple[str, str]:
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_path = Path(tmpdir)
        deb_file = tmp_path / "chrome.deb"

        req = urllib.request.Request(
            url,
            headers={"User-Agent": "Mozilla/5.0 (compatible; nixpkgs-update/1.0)"}
        )

        with urllib.request.urlopen(req) as response, open(deb_file, "wb") as f:
            shutil.copyfileobj(response, f)

        subprocess.check_call(["ar", "x", str(deb_file)], cwd=tmp_path)

        data_tars = list(tmp_path.glob("data.tar.*"))
        if not data_tars:
            raise FileNotFoundError("data.tar.* not in deb archive")

        subprocess.check_call(
            [
                "tar",
                "-xf",
                str(data_tars[0]),
                "--no-same-owner",
                "--no-same-permissions",
                "--wildcards",
                "./opt/google/chrome/WidevineCdm*"
            ],
            cwd=tmp_path
        )

        widevine_dir = tmp_path / "opt" / "google" / "chrome" / "WidevineCdm"
        manifest = json.loads((widevine_dir / "manifest.json").read_text())
        widevine_version = manifest["version"]

        sri_hash = subprocess.check_output(
            ["nix", "hash", "path", str(widevine_dir)],
            text=True
        ).strip()

        return sri_hash, widevine_version

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
        hashes[arch], ver = prefetch(url)
        if not widevineVersion:
            widevineVersion = ver

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
