#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (p: [ p.waybackpy ])" _7zz

import argparse
import base64
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
import time
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

import waybackpy

UPDATE_CONFIG_URL = (
    "https://dldir1v6.qq.com/weixin/Universal/Mac/XPlugin/updateConfigUniMac.xml"
)
MACUPDATE_XML = "MacUpdate_universal.xml"

LINUX_APPIMAGE_URLS = {
    "x86_64-linux": "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage",
    "aarch64-linux": "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.AppImage",
}

DMG_RE = re.compile(
    r"xWeChatMac_universal_"
    r"(?P<version>\d+(?:\.\d+)+)_"
    r"(?P<build>\d+)\.dmg"
)

USER_AGENT = "nixpkgs-update-wechat (https://github.com/NixOS/nixpkgs)"


def log(message: str) -> None:
    print(message, file=sys.stderr)


def cache_bust(url: str) -> str:
    parts = urllib.parse.urlsplit(url)
    query = urllib.parse.parse_qsl(parts.query, keep_blank_values=True)
    query.append(("t", str(int(time.time()))))
    return parts._replace(query=urllib.parse.urlencode(query)).geturl()


def fetch(url: str) -> bytes:
    request = urllib.request.Request(
        cache_bust(url),
        headers={"User-Agent": USER_AGENT},
    )
    with urllib.request.urlopen(request) as response:
        return response.read()


def fetch_head_headers(url: str) -> dict[str, str]:
    request = urllib.request.Request(
        cache_bust(url),
        headers={"User-Agent": USER_AGENT},
        method="HEAD",
    )
    with urllib.request.urlopen(request) as response:
        return {key.lower(): value for key, value in response.headers.items()}


def download(url: str, destination: Path) -> None:
    request = urllib.request.Request(
        cache_bust(url),
        headers={"User-Agent": USER_AGENT},
    )
    with urllib.request.urlopen(request) as response, destination.open("wb") as output:
        while chunk := response.read(1024 * 1024):
            output.write(chunk)


def local_name(name: str) -> str:
    return name.rsplit("}", 1)[-1]


def version_key(version: str) -> tuple[int, ...]:
    return tuple(map(int, version.split(".")))


def clean_url(url: str) -> str:
    return (
        urllib.parse.urlsplit(url)
        ._replace(
            query="",
            fragment="",
        )
        .geturl()
    )


def find_sources_json() -> Path:
    local = Path(__file__).resolve().parent / "sources.json"
    if not str(local).startswith("/nix/store") and local.is_file():
        return local

    for parent in [Path.cwd(), *Path.cwd().parents]:
        by_name = parent / "pkgs/by-name/we/wechat/sources.json"
        if by_name.is_file():
            return by_name
        local_pkg = parent / "sources.json"
        if local_pkg.is_file() and (parent / "package.nix").is_file():
            return local_pkg

    return local


def read_sources(sources_json: Path) -> dict:
    with sources_json.open("r", encoding="utf-8") as file_handle:
        return json.load(file_handle)


def write_sources(sources: dict, sources_json: Path) -> None:
    with sources_json.open("w", encoding="utf-8") as file_handle:
        json.dump(sources, file_handle, indent=2)
        file_handle.write("\n")


def hash_file(path: Path) -> str:
    hasher = hashlib.sha256()
    with path.open("rb") as file_handle:
        while chunk := file_handle.read(1024 * 1024):
            hasher.update(chunk)
    digest = base64.b64encode(hasher.digest()).decode("ascii")
    return f"sha256-{digest}"


def extract_version_from_appimage(appimage_path: Path) -> str | None:
    seven_z = shutil.which("7zz") or shutil.which("7z")
    if not seven_z:
        raise RuntimeError(
            "Neither '7zz' nor '7z' was found in PATH. "
            "Please ensure '_7zz' is available in PATH."
        )

    base_version = None
    proc_desktop = subprocess.run(
        [seven_z, "e", str(appimage_path), "wechat.desktop", "-so"],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
    )
    if proc_desktop.returncode == 0 and proc_desktop.stdout:
        for line in proc_desktop.stdout.decode("utf-8", "ignore").splitlines():
            if line.startswith("X-AppImage-Version="):
                base_version = line.split("=", 1)[1].strip()
                break

    proc = subprocess.run(
        [seven_z, "e", str(appimage_path), "opt/wechat/wechat", "-so"],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
    )
    if proc.returncode == 0 and proc.stdout:
        if base_version:
            pattern = re.escape(base_version.encode()) + rb"\.\d+"
            matches = re.findall(pattern, proc.stdout)
            if matches:
                return matches[0].decode()
        matches = re.findall(rb"\b\d+\.\d+\.\d+\.\d+\b", proc.stdout)
        if matches:
            valid = [match for match in matches if match.startswith(b"4.")]
            if valid:
                return max(
                    valid, key=lambda match: tuple(map(int, match.split(b".")))
                ).decode()

    return base_version


def macupdate_package_url(config_xml: bytes) -> str:
    root = ET.fromstring(config_xml)
    candidates = [
        (int(element.attrib["version"]), element.attrib["fullurl"])
        for element in root.iter()
        if local_name(element.tag) == "VersionInfo"
        and element.attrib.get("name") == "MacUpdate"
    ]
    if not candidates:
        raise RuntimeError("MacUpdate not found in XPlugin update config")
    _, url = max(candidates)
    return url


def extract_macupdate_xml(zip_path: Path, destination: Path) -> Path:
    with zipfile.ZipFile(zip_path) as archive:
        try:
            member = next(
                name for name in archive.namelist() if Path(name).name == MACUPDATE_XML
            )
        except StopIteration as exc:
            raise RuntimeError(
                f"{MACUPDATE_XML} not found in MacUpdate package"
            ) from exc
        archive.extract(member, destination)
    return destination / member


def latest_darwin_release(manifest: Path) -> tuple[str, str, str]:
    root = ET.parse(manifest).getroot()
    releases: list[tuple[str, str, str]] = []

    for item in root.iter():
        if local_name(item.tag) != "item":
            continue

        enclosure = next(
            (
                element
                for element in item.iter()
                if local_name(element.tag) == "enclosure"
            ),
            None,
        )
        if enclosure is None:
            continue

        url = enclosure.attrib.get("url")
        if not url:
            continue

        url = clean_url(url)
        match = DMG_RE.search(url)
        if match is None:
            continue

        dmg_version = match.group("version")
        dmg_build = match.group("build")

        short_version = next(
            (
                element.text.strip()
                for element in item.iter()
                if local_name(element.tag) == "shortVersionString" and element.text
            ),
            dmg_version,
        )
        build = next(
            (
                element.text.strip()
                for element in item.iter()
                if local_name(element.tag) == "version" and element.text
            ),
            dmg_build,
        )

        releases.append((short_version, build, url))

    if not releases:
        raise RuntimeError("No valid Darwin releases found in MacUpdate manifest")

    return max(
        releases,
        key=lambda item: (version_key(item[0]), int(item[1])),
    )


def format_wayback_url(url: str) -> str:
    clean = url.strip()
    if clean.startswith("/"):
        clean = "https://web.archive.org" + clean
    elif clean.startswith("http://"):
        clean = "https://" + clean[len("http://") :]
    return re.sub(r"/web/(\d{14})(?:[a-z]{2}_)?/", r"/web/\1id_/", clean)


def save_to_wayback(url: str) -> str:
    log(f"Archiving to Wayback Machine: {url}")
    save_api = waybackpy.WaybackMachineSaveAPI(url, USER_AGENT, max_tries=3)
    try:
        saved_url = save_api.save()
    except Exception as exc:
        log(f"Wayback save request failed ({exc}); checking newest snapshot...")
        availability_api = waybackpy.WaybackMachineAvailabilityAPI(url, USER_AGENT)
        saved_url = availability_api.newest().archive_url
    return format_wayback_url(saved_url)


def update_darwin(sources: dict) -> bool:
    platform = "aarch64-darwin"
    log(f"[{platform}] Fetching update configuration: {UPDATE_CONFIG_URL}")
    macupdate_url = macupdate_package_url(fetch(UPDATE_CONFIG_URL))
    log(f"[{platform}] MacUpdate package: {macupdate_url}")

    with tempfile.TemporaryDirectory(prefix="wechat-update-darwin-") as tmp:
        tmpdir = Path(tmp)
        zip_path = tmpdir / "MacUpdate.zip"

        log(f"[{platform}] Downloading MacUpdate package...")
        download(macupdate_url, zip_path)

        manifest = extract_macupdate_xml(zip_path, tmpdir)
        version, build, dmg_url = latest_darwin_release(manifest)

    full_version = f"{version}-{build}"
    log(f"[{platform}] Latest WeChat Darwin: {full_version}")
    log(f"[{platform}] DMG URL: {dmg_url}")

    current = sources.get(platform, {})
    if (
        current.get("version") == full_version
        and current.get("src", {}).get("url") == dmg_url
    ):
        log(f"[{platform}] Already up to date.")
        return False

    with tempfile.TemporaryDirectory(prefix="wechat-dmg-") as tmp:
        tmp_dmg = Path(tmp) / "wechat.dmg"
        log(f"[{platform}] Downloading DMG for hashing...")
        download(dmg_url, tmp_dmg)
        hash_value = hash_file(tmp_dmg)

    sources[platform] = {
        "version": full_version,
        "src": {
            "url": dmg_url,
            "hash": hash_value,
        },
    }
    log(f"[{platform}] Updated to {full_version} ({hash_value})")
    return True


def update_linux(platform: str, sources: dict) -> bool:
    appimage_url = LINUX_APPIMAGE_URLS[platform]

    log(f"[{platform}] Checking upstream headers: {appimage_url}")
    headers = fetch_head_headers(appimage_url)

    current = sources.get(platform, {})
    current_upstream = current.get("upstream", {})

    crc = headers.get("x-cos-hash-crc64ecma")
    version_id = headers.get("x-cos-version-id")

    if crc is not None:
        is_unchanged = current_upstream.get("x-cos-hash-crc64ecma") == crc
    elif version_id is not None:
        is_unchanged = current_upstream.get("x-cos-version-id") == version_id
    else:
        is_unchanged = False

    if current.get("src", {}).get("url") and current.get("version") and is_unchanged:
        log(
            f"[{platform}] Upstream binary unchanged (CRC64: {crc}). Already up to date."
        )
        return False

    log(f"[{platform}] Upstream updated or not recorded. Downloading AppImage...")

    with tempfile.TemporaryDirectory(prefix=f"wechat-update-{platform}-") as tmp:
        appimage_path = Path(tmp) / Path(appimage_url).name
        log(f"[{platform}] Downloading AppImage...")
        download(appimage_url, appimage_path)

        version = extract_version_from_appimage(appimage_path)
        if not version:
            raise RuntimeError(f"Could not determine version for {platform}")

        log(f"[{platform}] Resolved version: {version}")
        log(f"[{platform}] Computing hash...")
        hash_value = hash_file(appimage_path)

    log(f"[{platform}] Archiving to Wayback Machine...")
    archived_url = save_to_wayback(appimage_url)
    log(f"[{platform}] Archived URL: {archived_url}")

    sources[platform] = {
        "version": version,
        "src": {
            "url": archived_url,
            "hash": hash_value,
        },
        "upstream": {
            "url": appimage_url,
            **({"x-cos-hash-crc64ecma": crc} if crc else {}),
            **({"x-cos-version-id": version_id} if version_id else {}),
        },
    }
    log(f"[{platform}] Updated to {version} ({hash_value})")
    return True


def main() -> None:
    parser = argparse.ArgumentParser(description="Update WeChat sources.")
    parser.add_argument(
        "--platform",
        choices=[
            "all",
            "darwin",
            "linux",
            "aarch64-darwin",
            "x86_64-linux",
            "aarch64-linux",
        ],
        default="all",
        help="Platforms to update",
    )
    parser.add_argument(
        "--sources-json",
        type=Path,
        default=None,
        help="Path to sources.json (defaults to auto-detect)",
    )
    args = parser.parse_args()

    sources_json = (
        args.sources_json.resolve() if args.sources_json else find_sources_json()
    )
    sources = read_sources(sources_json)
    changed = False

    targets = []
    if args.platform in ("all", "darwin", "aarch64-darwin"):
        targets.append("aarch64-darwin")
    if args.platform in ("all", "linux", "x86_64-linux"):
        targets.append("x86_64-linux")
    if args.platform in ("all", "linux", "aarch64-linux"):
        targets.append("aarch64-linux")

    for target in targets:
        if target == "aarch64-darwin":
            if update_darwin(sources):
                changed = True
        else:
            if update_linux(target, sources):
                changed = True

    if changed:
        write_sources(sources, sources_json)
        log(f"Updated {sources_json}")
    else:
        log("No changes made.")


if __name__ == "__main__":
    main()
