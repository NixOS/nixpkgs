#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3.pkgs.requests python3.pkgs.packaging
"""
Update GNOME.

This script updates all packages included in one (or multiple) GNOME releases.

To run (from nixpkgs root!):

$ pkgs/desktops/gnome/updateGnome.py <VERSIONS> ...

Note that this script uses the parsed output from the gnome-build-meta NEWS
files¹.

The format (or location) might change with an update, breaking the script.
Check the result.

You can pass multiple versions, this is useful for pre-release testing:
`pkgs/desktops/gnome/updateGnome.py 51.alpha 51.beta 51.rc`.
When you pass a pre-release version, `GNOME_UPDATE_STABILITY=unstable` is set
automatically for the gnome updateScript.

The script needs to map GNOME module names to nixpkgs attr paths. The mapping
for this is at the beginning of the file.

Exits successfully if all packages were updated to the exact version specified
in the NEWS files for the update.

¹: e.g. https://download.gnome.org/sources/gnome-build-meta/51/gnome-build-meta-51.beta.news
"""
import os
import sys
from dataclasses import dataclass
import requests
from packaging.version import Version
import re
import subprocess

# Map gnome module names to nixpkgs attr paths.
NAMES = {
    "foundry": "libfoundry",
    "gexiv2": "gexiv2_0_16",
    "glibmm": "glibmm_2_68",
    "glycin": "libglycin",
    "gssdp": "gssdp_1_6",
    "gtk": "gtk4",
    "gtk+-3": "gtk3",
    "gtkmm": "gtkmm4",
    "gtksourceview": "gtksourceview5",
    "gupnp": "gupnp_1_6",
    "libsoup": "libsoup_3",
    "manuals": "gnome-manuals",
    "msgraph": "libmsgraph",
    "pangomm": "pangomm_2_48",
    "pyatspi": "python3Packages.pyatspi",
    "pygobject": "python3Packages.pygobject3",
    "tecla": "gnome-tecla",
}

# Modules that we don't ship
SKIP = [
    "gnome-app-list"
]

ENV_STABILITY = "GNOME_UPDATE_STABILITY"
NEWS_PACKAGE_REGEX = re.compile(r"-\s*(.*?)\s*\((.*?)\s*=>(.*?)\s*\)")
# group 1: removed packages
OUTER_NEWS_R_REMOVED = r"(?:(?:The following modules have been removed in this release:)\s{3}(.*?)\n)?[\w\n]*"
# group 2: changed packages (matches NEWS_PACKAGE_REGEX)
OUTER_NEWS_R_CHANGED = r"(?:The following modules have a new version:\n)[\w\n]*([\S\s]*?)[\w\n]*"
# group 3: unchanged packages
OUTER_NEWS_R_UNCHANGED = r"(?:The following modules weren't upgraded in this release:\n)\s{3}(.*?)\n"
OUTER_NEWS_REGEX = re.compile(f"{OUTER_NEWS_R_REMOVED}{OUTER_NEWS_R_CHANGED}{OUTER_NEWS_R_UNCHANGED}", re.MULTILINE)


@dataclass(slots=True)
class Package:
    name: str
    old_version: str
    new_version: str


@dataclass(slots=True)
class NewsInfo:
    news_files: set[str]
    removed: set[str]
    changed: list[Package]
    unchanged: set[str]
    unstable: bool


def version_greater(a: str, b: str) -> bool:
    return Version(a) > Version(b)


def collect_updates(versions: list[str]) -> NewsInfo:
    news_files: list[str] = []
    removed: set[str] = set()
    changed: dict[str, Package] = {}
    unchanged: set[str] = set()
    unstable = False

    for version in versions:
        unstable = unstable or version.endswith(".alpha") or version.endswith("beta") or version.endswith("rc")
        major = version.split(".")[0]
        newsfile_url = f"https://download.gnome.org/sources/gnome-build-meta/{major}/gnome-build-meta-{version}.news"
        news_files.append(newsfile_url)
        resp = requests.get(newsfile_url)
        resp.raise_for_status()

        news = resp.text

        matches = OUTER_NEWS_REGEX.match(news)
        if matches is None:
            raise ValueError(f"could not parse NEWS file ({newsfile_url})")

        removed_group = matches.group(1)
        if removed_group is not None:
            raw_removed = [resolve_name(pkg.strip()) for pkg in removed_group.split(',')]
        else:
            raw_removed = []
        raw_changes = NEWS_PACKAGE_REGEX.findall(matches.group(2))
        raw_unchanged = [resolve_name(pkg.strip()) for pkg in matches.group(3).split(',')]

        for pkg in raw_unchanged:
            if pkg not in removed and pkg not in changed:
                unchanged.add(pkg)

        for package_name, old_version, new_version in raw_changes:
            package_name = resolve_name(package_name.strip())
            old_version = old_version.strip()
            new_version = new_version.strip()

            if package_name in unchanged:
                unchanged.remove(package_name)
            if package_name in removed:
                removed.remove(package_name)
            if package_name not in changed or version_greater(new_version, changed[package_name].new_version):
                changed[package_name] = Package(package_name.strip(), old_version.strip(), new_version.strip())

        for pkg in raw_removed:
            if pkg in unchanged:
                unchanged.remove(pkg)
            if pkg in changed:
                del changed[pkg]
            removed.add(pkg)

    return NewsInfo(news_files, removed, sorted(changed.values(), key=lambda pkg: pkg.name), unchanged, unstable)


def resolve_name(candidate: str) -> str:
    if candidate in NAMES:
        return NAMES[candidate]
    return candidate


def try_update(pkg: Package, stability: str):
    update_env = os.environ.copy()
    update_env[ENV_STABILITY] = stability
    subprocess.run([
        "nix-shell",
        "maintainers/scripts/update.nix",
        "--argstr", "path", pkg.name,
        "--argstr", "commit", "true",
        "--argstr", "skip-prompt", "true",
        "--impure"
    ], check=True, env=update_env)

def nixpkgs_get_package_version(pkg: str) -> str:
    result = subprocess.run([
        "nix-instantiate", "--eval", "-A", f"{pkg}.version", "--raw"
    ], capture_output=True, check=True, text=True)
    return result.stdout.strip()


def usage_exit(code=1):
    print(__doc__)
    exit(code)


def main(versions: list[str]):
    print("... collecting NEWS ...")
    update = collect_updates(versions)

    print("================================================================================")
    print("# Updates as described by the NEWS files:")
    print()
    print("## NEWS:")
    for newsfile in update.news_files:
        print(f"- {newsfile}")

    if len(update.removed) > 0:
        print()
        print("## Removed packages (these are not touched by this script!):")
        for package in update.removed:
            print(f"- {package}")
    if len(update.unchanged) > 0:
        print()
        print("## Unchanged packages (these are not touched by this script!):")
        print(", ".join(update.unchanged))
    if len(update.changed) > 0:
        print()
        print("## Package updates:")
        for package in update.changed:
            print(f"- {package.name}: {package.old_version} -> {package.new_version}", end="")
            if package.name in SKIP:
                print(" [will be skipped]")
            else:
                print()
    print("================================================================================")

    env_var_value = "unstable" if update.unstable else "stable"

    print()
    print("Will now launch the update script for each package update.")
    print("One commit will be created per package, you will not be prompted again.")
    print(f"{ENV_STABILITY} will be set to '{env_var_value}'.")
    print("Please note that the update script will itself look for the newest version,")
    print("it is possible it will find newer versions. After the update this script will")
    print("check each package, to see if the version now matches the version in the")
    print("NEWS file.")
    print()
    print("If any error happens during any of the updates, the script will exit early.")
    print()
    print("Press Enter to continue...")
    input()

    for package in update.changed:
        print(f"... updating {package.name} ...")
        if package.name not in SKIP:
            try_update(package, env_var_value)

    print("updates done.")
    all_ok = True
    print("... checking package versions ...")
    longest_pkg_name = max(len(p.name) for p in update.changed)
    for package in update.changed:
        if package.name not in SKIP:
            print(f"{pad_str(package.name, longest_pkg_name)}: ", end="")
            actual_version = nixpkgs_get_package_version(package.name)
            if actual_version == package.new_version:
                print(f"ok       {actual_version}")
            elif version_greater(actual_version, package.new_version):
                all_ok = False
                print(f"NEWER    {actual_version}")
            else:
                all_ok = False
                print(f"FAIL     {actual_version}")

    sys.exit(0 if all_ok else 1)


def pad_str(s: str, l: int) -> str:
    return s + " " * (l - len(s))


if __name__ == '__main__':
    if len(sys.argv) < 2:
        usage_exit()
    if sys.argv[1] == '--help':
        usage_exit(0)

    main(sys.argv[1:])
