from importlib.metadata import PathDistribution
from pathlib import Path
import collections
import sys
import os
from typing import Dict, List, Set, Tuple
do_abort: bool = False
packages: Dict[str, Dict[str, Dict[str, List[str]]]] = collections.defaultdict(dict)
found_paths: Set[Path] = set()
out_path: Path = Path(os.getenv("out"))
version: Tuple[int, int] = sys.version_info
site_packages_path: str = f'lib/python{version[0]}.{version[1]}/site-packages'


def get_name(dist: PathDistribution) -> str:
    return dist.metadata['name'].lower().replace('-', '_')


# pretty print a package
def describe_package(dist: PathDistribution) -> str:
    return f"{get_name(dist)} {dist.version} ({dist._path})"


# pretty print a list of parents (dependency chain)
def describe_parents(parents: List[str]) -> str:
    if not parents:
        return ""
    return \
        f"    dependency chain:\n      " \
        + str(f"\n      ...depending on: ".join(parents))


# inserts an entry into 'packages'
def add_entry(name: str, version: str, store_path: str, parents: List[str]) -> None:
    packages[name][store_path] = dict(
        version=version,
        parents=parents,
    )


# transitively discover python dependencies and store them in 'packages'
def find_packages(store_path: Path, site_packages_path: str, parents: List[str]) -> None:
    site_packages: Path = (store_path / site_packages_path)
    propagated_build_inputs: Path = (store_path / "nix-support/propagated-build-inputs")

    # only visit each path once, to avoid exponential complexity with highly
    # connected dependency graphs
    if store_path in found_paths:
        return
    found_paths.add(store_path)

    # add the current package to the list
    if site_packages.exists():
        for dist_info in site_packages.glob("*.dist-info"):
            dist: PathDistribution = PathDistribution(dist_info)
            add_entry(get_name(dist), dist.version, store_path, parents)

    # recursively add dependencies
    if propagated_build_inputs.exists():
        with open(propagated_build_inputs, "r") as f:
            build_inputs: List[str] = f.read().split()
            for build_input in build_inputs:
                find_packages(Path(build_input), site_packages_path, parents + [build_input])


find_packages(out_path, site_packages_path, [f"this derivation: {out_path}"])

# print all duplicates
for name, store_paths in packages.items():
    if len(store_paths) > 1:
        do_abort = True
        print("Found duplicated packages in closure for dependency '{}': ".format(name))
        for store_path, candidate in store_paths.items():
            print(f"  {name} {candidate['version']} ({store_path})")
            print(describe_parents(candidate['parents']))

# fail if duplicates were found
if do_abort:
    print("")
    print(
        "Package duplicates found in closure, see above. Usually this "
        "happens if two packages depend on different version "
        "of the same dependency."
    )
    sys.exit(1)
