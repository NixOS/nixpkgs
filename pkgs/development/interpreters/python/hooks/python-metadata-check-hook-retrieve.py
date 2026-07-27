from importlib.metadata import PackageNotFoundError, version
from sys import argv, exit, stderr


pname = argv[1]
try:
    print(version(pname))
except PackageNotFoundError as e:
    print(e, file=stderr)
    print("This usually means that the derivation's pname does not correspond to the project name, as found on PyPI, in pyproject.toml, or in setup.{py,cfg}.", file=stderr)
    print("Use the normalized name for the derivation's pname and its attribute name in python3Packages.", file=stderr)
    print("See https://packaging.python.org/en/latest/specifications/name-normalization/.", file=stderr)
    exit(1)
