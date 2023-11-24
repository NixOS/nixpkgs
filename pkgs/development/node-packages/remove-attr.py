#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

import collections.abc
import fileinput
import json
import os.path
import re
import sys


def remove(attr):
    with open(os.path.join(os.path.dirname(__file__), 'node-packages.json'), 'r+') as node_packages_json:
        packages = json.load(node_packages_json)
        idx = 0
        while idx < len(packages):
            if packages[idx] == attr or (isinstance(packages[idx], collections.abc.Mapping) and next(iter(packages[idx].keys())) == attr):
                del packages[idx]
            else:
                idx += 1

        node_packages_json.seek(0)
        for idx, package in enumerate(packages):
            if idx == 0:
                node_packages_json.write('[\n  ')
            else:
                node_packages_json.write(', ')
            json.dump(package, node_packages_json)
            node_packages_json.write('\n')
        node_packages_json.write(']\n')
        node_packages_json.truncate()

    with fileinput.input(os.path.join(os.path.dirname(__file__), 'node-packages.nix'), inplace=1) as node_packages:
        safe_attr = re.escape(attr)
        in_attr = False
        for line in node_packages:
            if in_attr:
                if re.fullmatch(r'  \};\n', line):
                    in_attr = False
            else:
                if re.fullmatch(rf'  (?:{safe_attr}|"{safe_attr}") = nodeEnv\.buildNodePackage \{{\n', line):
                    in_attr = True
                else:
                    sys.stdout.write(line)

    with fileinput.input(os.path.join(os.path.dirname(__file__), 'main-programs.nix'), inplace=1) as main_programs:
        safe_attr = re.escape(attr)
        for line in main_programs:
            if not re.fullmatch(rf'  "?{safe_attr}"? = ".*";\n', line):
                sys.stdout.write(line)

    with fileinput.input(os.path.join(os.path.dirname(__file__), 'overrides.nix'), inplace=1) as overrides:
        safe_attr = re.escape(attr)
        in_attr = False
        for line in overrides:
            if in_attr:
                if re.fullmatch(r'  \}\)?;\n', line):
                    in_attr = False
            else:
                if re.fullmatch(rf'  (?:{safe_attr}|"{safe_attr}") = .* \{{\n', line):
                    in_attr = True
                else:
                    sys.stdout.write(line)


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Remove a given package from the node-packages.nix file')
    parser.add_argument('attr', help='The package attribute to remove')
    args = parser.parse_args()

    remove(args.attr)
