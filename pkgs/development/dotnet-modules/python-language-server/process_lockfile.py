#!/usr/bin/python

import json
import sys


def process_section(name, section):
    packages = set()

    if "resolved" in section:
        packages.add((name, section["resolved"]))

    if "dependencies" in section:
        for name in section["dependencies"]:
            packages.add((name, section["dependencies"][name]))

    return packages


def main():
    with open(sys.argv[1], 'r') as f:
        tree = json.loads(f.read())

    packages = set()

    topDependencies = tree["dependencies"]

    for area in topDependencies:
        for name in topDependencies[area]:
            packages = packages.union(process_section(name, topDependencies[area][name]))

    for (name, version) in packages:
        print("%s %s" % (name, version))


if __name__ == "__main__":
    main()
