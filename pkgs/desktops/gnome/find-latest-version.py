import argparse
import math
import json
import requests
import sys
from enum import Enum
from libversion import Version
from typing import (
    Callable,
    Iterable,
    List,
    NamedTuple,
    Optional,
    Tuple,
    TypeVar,
    Type,
    cast,
)


EnumValue = TypeVar("EnumValue", bound=Enum)


def enum_to_arg(enum: Enum) -> str:
    return enum.name.lower().replace("_", "-")


def arg_to_enum(enum_meta: Type[EnumValue], name: str) -> EnumValue:
    return enum_meta[name.upper().replace("-", "_")]


def enum_to_arg_choices(enum_meta: Type[EnumValue]) -> Tuple[str, ...]:
    return tuple(enum_to_arg(v) for v in cast(Iterable[EnumValue], enum_meta))


class Stability(Enum):
    STABLE = "stable"
    UNSTABLE = "unstable"


VersionPolicy = Callable[[Version], bool]
VersionPredicate = Callable[[Version, Stability], bool]


class VersionPredicateHolder(NamedTuple):
    function: VersionPredicate


def version_to_list(version: str) -> List[int]:
    return list(map(int, version.split(".")))


def odd_unstable(version: Version, selected: Stability) -> bool:
    try:
        version_parts = version_to_list(version.value)
    except:
        # Failing to parse as a list of numbers likely means the version contains a string tag like “beta”, therefore it is not a stable release.
        return selected != Stability.STABLE

    if len(version_parts) < 2:
        return True

    even = version_parts[1] % 2 == 0
    prerelease = (version_parts[1] >= 90 and version_parts[1] < 100) or (version_parts[1] >= 900 and version_parts[1] < 1000)
    stable = even and not prerelease
    if selected == Stability.STABLE:
        return stable
    else:
        return True


def tagged(version: Version, selected: Stability) -> bool:
    if selected == Stability.STABLE:
        return not ("alpha" in version.value or "beta" in version.value or "rc" in version.value)
    else:
        return True


def no_policy(version: Version, selected: Stability) -> bool:
    return True


class VersionPolicyKind(Enum):
    # HACK: Using function as values directly would make Enum
    # think they are methods and skip them.
    ODD_UNSTABLE = VersionPredicateHolder(odd_unstable)
    TAGGED = VersionPredicateHolder(tagged)
    NONE = VersionPredicateHolder(no_policy)


def make_version_policy(
    version_policy_kind: VersionPolicyKind,
    selected: Stability,
    upper_bound: Optional[Version],
) -> VersionPolicy:
    version_predicate = version_policy_kind.value.function
    if not upper_bound:
        return lambda version: version_predicate(version, selected)
    else:
        return lambda version: version_predicate(version, selected) and version < upper_bound


def find_versions(package_name: str, version_policy: VersionPolicy) -> List[Version]:
    # The structure of cache.json: https://gitlab.gnome.org/Infrastructure/sysadmin-bin/blob/master/ftpadmin#L762
    cache = json.loads(requests.get(f"https://download.gnome.org/sources/{package_name}/cache.json").text)
    if type(cache) != list or cache[0] != 4:
        raise Exception("Unknown format of cache.json file.")

    versions: Iterable[Version] = map(Version, cache[2][package_name])
    versions = sorted(filter(version_policy, versions))

    return versions


parser = argparse.ArgumentParser(
    description="Find latest version for a GNOME package by crawling their release server.",
)
parser.add_argument(
    "package-name",
    help="Name of the directory in https://download.gnome.org/sources/ containing the package.",
)
parser.add_argument(
    "version-policy",
    help="Policy determining which versions are considered stable. GNOME packages usually denote stability by alpha/beta/rc tag in the version. For older packages, odd minor versions are unstable but there are exceptions.",
    choices=enum_to_arg_choices(VersionPolicyKind),
    nargs="?",
    default=enum_to_arg(VersionPolicyKind.TAGGED),
)
parser.add_argument(
    "requested-release",
    help="Most of the time, we will want to update to stable version but sometimes it is useful to test.",
    choices=enum_to_arg_choices(Stability),
    nargs="?",
    default=enum_to_arg(Stability.STABLE),
)
parser.add_argument(
    "--upper-bound",
    dest="upper-bound",
    help="Only look for versions older than this one (useful for pinning dependencies).",
)


if __name__ == "__main__":
    args = parser.parse_args()

    package_name = getattr(args, "package-name")
    requested_release = arg_to_enum(Stability, getattr(args, "requested-release"))
    upper_bound = getattr(args, "upper-bound")
    if upper_bound is not None:
        upper_bound = Version(upper_bound)
    version_policy_kind = arg_to_enum(VersionPolicyKind, getattr(args, "version-policy"))
    version_policy = make_version_policy(version_policy_kind, requested_release, upper_bound)

    try:
        versions = find_versions(package_name, version_policy)
    except Exception as error:
        print(error, file=sys.stderr)
        sys.exit(1)

    if len(versions) == 0:
        print("No versions matched.", file=sys.stderr)
        sys.exit(1)

    print(versions[-1].value)
