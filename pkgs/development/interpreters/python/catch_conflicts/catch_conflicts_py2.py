import pkg_resources
import collections
import sys

do_abort = False
packages = collections.defaultdict(list)

for f in sys.path:
    for req in pkg_resources.find_distributions(f):
        if req not in packages[req.project_name]:
            # some exceptions inside buildPythonPackage
            if req.project_name in ['setuptools', 'pip', 'wheel']:
                continue
            packages[req.project_name].append(req)


for name, duplicates in packages.items():
    if len(duplicates) > 1:
        do_abort = True
        print("Found duplicated packages in closure for dependency '{}': ".format(name))
        for dup in duplicates:
            print("  " + repr(dup))

if do_abort:
    print("")
    print(
        'Package duplicates found in closure, see above. Usually this '
        'happens if two packages depend on different version '
        'of the same dependency.')
    sys.exit(1)
