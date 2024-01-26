from importlib.metadata import PathDistribution
from pathlib import Path
import collections
import sys
import os


do_abort = False
packages = collections.defaultdict(list)
out_path = Path(os.getenv("out"))
version = sys.version_info
site_packages_path = f'lib/python{version[0]}.{version[1]}/site-packages'


def find_packages(store_path, site_packages_path):
    site_packages = (store_path / site_packages_path)
    propagated_build_inputs = (store_path / "nix-support/propagated-build-inputs")
    if site_packages.exists():
        for dist_info in site_packages.glob("*.dist-info"):
            dist = PathDistribution(dist_info)
            packages[dist._normalized_name].append(
                f"{dist._normalized_name} {dist.version} ({dist._path})"
            )

    if propagated_build_inputs.exists():
        with open(propagated_build_inputs, "r") as f:
            build_inputs = f.read().strip().split(" ")
            for build_input in build_inputs:
                find_packages(Path(build_input), site_packages_path)


find_packages(out_path, site_packages_path)

for name, duplicates in packages.items():
    if len(duplicates) > 1:
        do_abort = True
        print("Found duplicated packages in closure for dependency '{}': ".format(name))
        for duplicate in duplicates:
            print(f"\t{duplicate}")

if do_abort:
    print("")
    print(
        "Package duplicates found in closure, see above. Usually this "
        "happens if two packages depend on different version "
        "of the same dependency."
    )
    sys.exit(1)
