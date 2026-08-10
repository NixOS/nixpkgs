from functools import reduce
from operator import getitem
from packaging.version import Version
from sys import argv, exit
from tomlkit import dump, load
from tomlkit.exceptions import NonExistentKey


new_version = argv[1]

with open('pyproject.toml', 'r') as f:
    pyproject = load(f)

sections = ['project', 'tool.poetry']
for path in sections:
    try:
        section = reduce(getitem, path.split('.'), pyproject)
    except NonExistentKey:
        continue
    if 'version' in section:
        if Version(section['version']) == Version(new_version):
            print("The version in pyproject.toml already matches the derivation's version. Remove pyprojectVersionPatchHook.")
            exit(1)
        print(f"Changing version in pyproject.toml from '{section['version']}' to '{new_version}'.")
        section['version'] = new_version
        break
    if 'dynamic' in section and 'version' in section['dynamic']:
        print(f"Changing dynamic version in pyproject.toml to '{new_version}'.")
        section['dynamic'].remove('version')
        section['version'] = new_version
        break
else:
    print('No patchable version specification found in pyproject.toml.')
    exit(1)

with open('pyproject.toml', 'w') as f:
    dump(pyproject, f)
