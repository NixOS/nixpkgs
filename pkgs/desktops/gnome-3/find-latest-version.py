import argparse
import math
import json
import requests
import sys
from libversion import Version
from typing import Optional


def version_to_list(version):
    return list(map(int, version.split(".")))


def odd_unstable(version: Version, selected):
    try:
        version = version_to_list(version.value)
    except:
        # Failing to parse as a list of numbers likely means the version contains a string tag like “beta”, therefore it is not a stable release.
        return selected != "stable"

    if len(version) < 2:
        return True

    even = version[1] % 2 == 0
    prerelease = (version[1] >= 90 and version[1] < 100) or (version[1] >= 900 and version[1] < 1000)
    stable = even and not prerelease
    if selected == "stable":
        return stable
    else:
        return True


def tagged(version: Version, selected):
    if selected == "stable":
        return not ("alpha" in version.value or "beta" in version.value or "rc" in version.value)
    else:
        return True


def no_policy(version: Version, selected):
    return True


version_policies = {
    "odd-unstable": odd_unstable,
    "tagged": tagged,
    "none": no_policy,
}


def make_version_policy(version_predicate, selected, upper_bound: Optional[Version]):
    if not upper_bound:
        return lambda version: version_predicate(version, selected)
    else:
        return lambda version: version_predicate(version, selected) and version < upper_bound


parser = argparse.ArgumentParser(description="Find latest version for a GNOME package by crawling their release server.")
parser.add_argument("package-name", help="Name of the directory in https://ftp.gnome.org/pub/GNOME/sources/ containing the package.")
parser.add_argument("version-policy", help="Policy determining which versions are considered stable. GNOME packages usually denote stability by alpha/beta/rc tag in the version. For older packages, odd minor versions are unstable but there are exceptions.", choices=version_policies.keys(), nargs="?", default="tagged")
parser.add_argument("requested-release", help="Most of the time, we will want to update to stable version but sometimes it is useful to test.", choices=["stable", "unstable"], nargs="?", default="stable")
parser.add_argument("--upper-bound", dest="upper-bound", help="Only look for versions older than this one (useful for pinning dependencies).")


if __name__ == "__main__":
    args = parser.parse_args()

    package_name = getattr(args, "package-name")
    requested_release = getattr(args, "requested-release")
    upper_bound = getattr(args, "upper-bound")
    if upper_bound:
        upper_bound = Version(upper_bound)
    version_predicate = version_policies[getattr(args, "version-policy")]
    version_policy = make_version_policy(version_predicate, requested_release, upper_bound)

    # The structure of cache.json: https://gitlab.gnome.org/Infrastructure/sysadmin-bin/blob/master/ftpadmin#L762
    cache = json.loads(requests.get(f"https://ftp.gnome.org/pub/GNOME/sources/{package_name}/cache.json").text)
    if type(cache) != list or cache[0] != 4:
        print("Unknown format of cache.json file.", file=sys.stderr)
        sys.exit(1)

    versions = map(Version, cache[2][package_name])
    versions = sorted(filter(version_policy, versions))

    if len(versions) == 0:
        print("No versions matched.", file=sys.stderr)
        sys.exit(1)

    print(versions[-1].value)
