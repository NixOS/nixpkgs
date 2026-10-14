"""Check the installed XML utility without executing its target interpreter."""

import argparse
import shlex
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--script", required=True, type=Path)
    parser.add_argument("--interpreter", required=True, type=Path)
    args = parser.parse_args()
    with args.script.open(encoding="utf-8") as stream:
        shebang = stream.readline()
    if not shebang.startswith("#!"):
        raise AssertionError("xml_grep has no interpreter directive")
    command = shlex.split(shebang[2:])
    if not command or command[0] != str(args.interpreter):
        raise AssertionError(f"Unexpected xml_grep interpreter: {command}")
    if "-w" not in command[1:]:
        raise AssertionError("The xml_grep warning flag was lost")


if __name__ == "__main__":
    main()
