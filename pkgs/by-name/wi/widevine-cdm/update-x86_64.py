#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

from __future__ import annotations
import sys, os, json, base64, re, argparse, urllib.request, time
from typing import Dict, Optional, Tuple
from pathlib import Path

DEFAULT_JSON = "https://raw.githubusercontent.com/mozilla-firefox/firefox/refs/heads/main/toolkit/content/gmp-sources/widevinecdm.json"
ARCH_PATTERNS = {
    "linux_x86_64": ["Linux_x86_64-gcc3"],
    "linux_aarch64": ["Linux_aarch64-gcc3"]
}

def fetch_json(url: str) -> dict:
    with urllib.request.urlopen(url) as r:
        return json.load(r)

def hex_to_sri(hexstr: str) -> str:
    b = bytes.fromhex(hexstr)
    return "sha512-" + base64.b64encode(b).decode()

def find_widevine_vendor(data: dict) -> dict:
    vendors = data.get("vendors") or {}
    for key, value in vendors.items():
        if "gmp-widevinecdm" in key.lower():
            return value

    raise SystemExit("ERR: couldn't find a widevine vendor entry in JSON !")

def judge_platforms(platforms: dict, patterns) -> Optional[Tuple[str, dict]]:
    for plkey, plvalue in platforms.items():
        if plvalue.get("alias"):
            continue

        low = plkey.lower()
        for pat in patterns:
            if pat.lower() in low:
                return plkey, plvalue

    return None

def normalize_fileurl(entry: dict) -> Optional[str]:
    if entry.get("fileUrl"):
        return entry["fileUrl"]

    m = entry.get("mirrorUrls")
    if isinstance(m, list) and m:
        return m[0]

    return None

def extract_ver_from_url(url: str) -> Optional[str]:
    m = re.search(r'[_-](\d+\.\d+\.\d+\.\d+)[_-]', url)
    if m:
        return m.group(1)
    m = re.search(r'(\d+\.\d+\.\d+\.\d+)', url)
    return m.group(1) if m else None

def build_entry(pkey: str, pentry: dict) -> dict:
    url = normalize_fileurl(pentry)
    hv = pentry.get("hashValue")

    if not url or not hv:
        raise SystemExit(f"ERR: platform {pkey} is missing a file URL or hash !")

    sri = hex_to_sri(hv)
    version = extract_ver_from_url(url)
    return {"platform_key": pkey, "url": url, "sri": sri, "version": version}

def main():
    WIDEVINE_DIR = Path(__file__).resolve().parent
    DEFAULT_FILE = WIDEVINE_DIR / "x86_64-manifest.json"

    ap = argparse.ArgumentParser()
    ap.add_argument("file", type=Path, nargs="?", default=DEFAULT_FILE)
    ap.add_argument("--json-url", default=DEFAULT_JSON)
    args = ap.parse_args()

    print(f"# fetching {args.json_url} !", file=sys.stderr)
    data = fetch_json(args.json_url)
    vendor = find_widevine_vendor(data)
    platforms = vendor.get("platforms") or {} # should never be null but moz could forseeably delete it
    if not platforms:
        raise SystemExit("ERR: no widevine platforms !")

    results = {}
    for arch, patterns in ARCH_PATTERNS.items():
        found = judge_platforms(platforms, patterns)
        if not found:
            print(f"# WARN: no platform for {arch}. skipping !", file=sys.stderr)
            continue
        pkey, pentry = found
        print(f"# found {arch} --> {pkey}", file=sys.stderr)
        entry = build_entry(pkey, pentry)
        results[arch] = entry

    if not results:
        raise SystemExit("ERR: no linux platform entries !")

    linux_x64 = results["linux_x86_64"]

    args.file.write_text(json.dumps(linux_x64, indent=2) + "\n", encoding="utf-8")
    print("# updated", file=sys.stderr)

if __name__ == "__main__":
    main()
