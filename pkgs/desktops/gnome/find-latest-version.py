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

    def allows(self, target: "Stability") -> bool:
        """
        Whether selected stability `self` allows version
        with a specified `target` stability.
        """
        match self:
            case Stability.STABLE:
                return target == Stability.STABLE
            case Stability.UNSTABLE:
                return True

    def __repr__(self) -> str:
        """
        Useful for tests.
        """
        match self:
            case Stability.STABLE:
                return "Stability.STABLE"
            case Stability.UNSTABLE:
                return "Stability.UNSTABLE"


VersionPolicy = Callable[[Version], bool]
VersionClassifier = Callable[[Version], Stability]


class VersionClassifierHolder(NamedTuple):
    function: VersionClassifier


def version_to_list(version: str) -> List[int]:
    return list(map(int, version.split(".")))


def odd_unstable(version: Version) -> Stability:
    """
    Traditional GNOME version policy

    >>> odd_unstable(Version("32"))
    Stability.STABLE
    >>> odd_unstable(Version("3.2.1"))
    Stability.STABLE
    >>> odd_unstable(Version("3.2.1.alpha"))
    Stability.UNSTABLE
    >>> odd_unstable(Version("3.2.1beta"))
    Stability.UNSTABLE
    >>> odd_unstable(Version("4.2.89"))
    Stability.STABLE
    >>> odd_unstable(Version("4.2.90"))
    Stability.STABLE
    >>> odd_unstable(Version("4.88.2"))
    Stability.STABLE
    >>> odd_unstable(Version("4.90.2"))
    Stability.UNSTABLE
    >>> odd_unstable(Version("4.3.0"))
    Stability.UNSTABLE
    >>> odd_unstable(Version("4.3.89"))
    Stability.UNSTABLE
    >>> odd_unstable(Version("4.2.899"))
    Stability.STABLE
    >>> odd_unstable(Version("4.2.900"))
    Stability.STABLE
    >>> odd_unstable(Version("4.898.2"))
    Stability.STABLE
    >>> odd_unstable(Version("4.900.2"))
    Stability.UNSTABLE
    """
    try:
        version_parts = version_to_list(version.value)
    except:
        # Failing to parse as a list of numbers likely means the version contains a string tag like “beta”, therefore it is not a stable release.
        return Stability.UNSTABLE

    if len(version_parts) < 2:
        return Stability.STABLE

    even = version_parts[1] % 2 == 0
    prerelease = (version_parts[1] >= 90 and version_parts[1] < 100) or (version_parts[1] >= 900 and version_parts[1] < 1000)
    stable = even and not prerelease
    if stable:
        return Stability.STABLE
    else:
        return Stability.UNSTABLE


def ninety_micro_unstable(version: Version) -> Stability:
    """
    <https://gitlab.gnome.org/GNOME/gcr/-/tree/4.3.90.3#versions>:
    > To denote unstable versions, the micro version number will correspond to 90 or
    > higher, e.g. 4.$MINOR.90.

    >>> ninety_micro_unstable(Version("3.2.1"))
    Stability.STABLE
    >>> ninety_micro_unstable(Version("3.2.1.alpha"))
    Stability.UNSTABLE
    >>> ninety_micro_unstable(Version("3.2.1beta"))
    Stability.UNSTABLE
    >>> ninety_micro_unstable(Version("4.2.89"))
    Stability.STABLE
    >>> ninety_micro_unstable(Version("4.3.89"))
    Stability.STABLE
    >>> ninety_micro_unstable(Version("4.2.90"))
    Stability.UNSTABLE
    >>> ninety_micro_unstable(Version("4.2.89.3"))
    Stability.STABLE
    >>> ninety_micro_unstable(Version("4.2.90.3"))
    Stability.UNSTABLE
    >>> ninety_micro_unstable(Version("4.90.1"))
    Stability.STABLE
    """
    try:
        version_parts = version_to_list(version.value)
    except:
        # Failing to parse as a list of numbers likely means the version contains a string tag like “beta”, therefore it is not a stable release.
        return Stability.UNSTABLE

    if len(version_parts) < 3:
        return Stability.STABLE

    prerelease = version_parts[2] >= 90
    if prerelease:
        return Stability.UNSTABLE
    else:
        return Stability.STABLE


def tagged(version: Version) -> Stability:
    """
    Considers only versions with explicit `alpha`, `beta` or `rc` tags unstable.

    >>> tagged(Version("32"))
    Stability.STABLE
    >>> tagged(Version("3.2.1"))
    Stability.STABLE
    >>> tagged(Version("4.3.0"))
    Stability.STABLE
    >>> tagged(Version("3.2.1.alpha"))
    Stability.UNSTABLE
    >>> tagged(Version("3.2.1beta"))
    Stability.UNSTABLE
    >>> tagged(Version("3.2.1rc.3"))
    Stability.UNSTABLE
    """
    prerelease = "alpha" in version.value or "beta" in version.value or "rc" in version.value
    if prerelease:
        return Stability.UNSTABLE
    else:
        return Stability.STABLE


def no_policy(version: Version) -> Stability:
    """
    Considers any version stable.

    >>> no_policy(Version("32"))
    Stability.STABLE
    >>> no_policy(Version("3.2.1"))
    Stability.STABLE
    >>> no_policy(Version("3.2.1.alpha"))
    Stability.STABLE
    >>> no_policy(Version("3.2.1beta"))
    Stability.STABLE
    """
    return Stability.STABLE


class VersionPolicyKind(Enum):
    # HACK: Using function as values directly would make Enum
    # think they are methods and skip them.
    ODD_UNSTABLE = VersionClassifierHolder(odd_unstable)
    NINETY_MICRO_UNSTABLE = VersionClassifierHolder(ninety_micro_unstable)
    TAGGED = VersionClassifierHolder(tagged)
    NONE = VersionClassifierHolder(no_policy)


def make_version_policy(
    version_policy_kind: VersionPolicyKind,
    selected: Stability,
    upper_bound: Optional[Version],
) -> VersionPolicy:
    version_classifier = version_policy_kind.value.function
    if not upper_bound:
        return lambda version: selected.allows(version_classifier(version))
    else:
        return lambda version: selected.allows(version_classifier(version)) and version < upper_bound


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
