from packaging.version import InvalidVersion, parse, Version
from sys import argv, exit


derivation_pname = argv[1]
derivation_version = argv[2]
metadata_version = argv[3]

if 'unstable-' not in derivation_version:
    try:
        parse(derivation_version)
    except InvalidVersion as e:
        print(e)
        print('Make sure you follow https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#versioning.')
        exit(1)

    if Version(derivation_version) != Version(metadata_version):
        print(f"The '{derivation_pname}' derivation has version '{derivation_version}' but .dist-info/METADATA specifies version '{metadata_version}'.")
        print('This usually means that the wrong version is hardcoded in pyproject.toml or setup.{py,cfg}.')
        print("Use the pyprojectVersionPatchHook or patch the version manually so that the project metadata matches the derivation's version.")
        exit(1)
