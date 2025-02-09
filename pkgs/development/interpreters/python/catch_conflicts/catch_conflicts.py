from importlib.metadata import PathDistribution
from pathlib import Path
import collections
import sys


do_abort = False
packages = collections.defaultdict(list)


for path in sys.path:
    for dist_info in Path(path).glob("*.dist-info"):
        dist = PathDistribution(dist_info)

        packages[dist._normalized_name].append(
            f"{dist._normalized_name} {dist.version} ({dist._path})"
        )


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
