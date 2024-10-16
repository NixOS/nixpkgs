#!/usr/bin/env nix-shell
#!nix-shell -i python3
#!nix-shell -p nix-prefetch-github
#!nix-shell -p "python3.withPackages(p: with p; [ python-dotenv ])"
#
# Usage: ./update <idea-ultimate tarball> <idea version>
#
# The first argument is a path to an IntelliJ IDEA Ultimate tarball and the second argument is version, like 2023.3.1
# of that tarball. You can get a path to one with `nix-build -A jetbrains.idea-ultimate.src`.
#
# The tarball contains a file with JBR version information at <prefix>/jbr/release. From that file we resolve the
# Git tag and a few other bits of metadata of the JBR version used by that version of IDEA, and with that we can
# pre-fetch the source and get the hash.
#
import json
import os.path
import re
import subprocess
import sys
import tarfile
from datetime import datetime
from io import TextIOWrapper
from json.decoder import JSONDecodeError
from pathlib import PurePath

import dotenv.parser

# Size of the tarfile buffer
BUFFER_SIZE = 4 * 1024 * 1024

# Regular expression for extracting different components from an `IMPLEMENTOR_VERSION` line, like:
#     JBR-17.0.10+1-1087.23-jcef
#         └┬────┘ ╿ └┬────┘
#          │      │  │
#          │      │  │
#          │      │  ┕ build
#          │      ┕ javaBuild
#          ┕ javaVersion
#
VERSION_LINE = re.compile(r"""JBR-(?P<javaVersion>[0-9.]+)\+(?P<javaBuild>\d+)-(?P<build>\d+\.\d+)(-\w+)?""")


def extract_jbr_release(intellij_tarball: str) -> dict[str, str]:
    """Extracts jbr/release from the source tarball and returns a dict with the contents of that file."""

    with tarfile.open(name=intellij_tarball, mode="r", bufsize=BUFFER_SIZE) as src:
        member = next(member for member in src if PurePath(member.name).match("*/jbr/release"))

        with src.extractfile(member) as release:
            return {b.key: b.value for b in dotenv.parser.parse_stream(TextIOWrapper(release))}


def prefetch(rev: str) -> str:
    argv = ["nix-prefetch-github", "--meta", "--rev", tag, "JetBrains", "JetBrainsRuntime"]
    prefetched = json.loads(subprocess.check_output(argv).decode("utf-8"))
    src = prefetched["src"]
    meta = prefetched["meta"]
    commit_timestamp = datetime.fromisoformat(f"{meta['commitDate']}T{meta['commitTimeOfDay']}Z")
    return dict(
        hash=src["hash"],
        SOURCE_DATE_EPOCH=int(commit_timestamp.timestamp()),
    )


if __name__ == "__main__":
    idea_tarball = sys.argv[1]
    idea_version = sys.argv[2]
    version_info_file = os.path.join(os.path.dirname(os.path.realpath(__file__)), "version-info.json")

    try:
        with open(version_info_file, mode="rb") as input:
            version_info = json.load(input)
    except (FileNotFoundError, JSONDecodeError):
        version_info = dict()

    if version_info.get("ideaVersion") == idea_version:
        print(f"Up to date at {version_info['rev']} for IntelliJ IDEA {idea_version}.", file=sys.stderr)
        sys.exit(0)

    print(f"Updating JBR release to match IDEA {idea_version}…", file=sys.stderr)

    release = extract_jbr_release(idea_tarball)

    version_info = {"ideaVersion": idea_version}

    version_info |= VERSION_LINE.fullmatch(release["IMPLEMENTOR_VERSION"]).groupdict()

    java_version = version_info["javaVersion"]
    java_build = version_info["javaBuild"]
    build = version_info["build"]
    tag = f"jb{java_version}-b{build}"

    version_info["openjdkTag"] = f"jbr-{java_version}+{java_build}"

    version_info["rev"] = tag
    version_info |= prefetch(tag)

    with open(version_info_file, "w") as out:
        json.dump(version_info, out, indent=4)
        out.write("\n")

    print(f"JBR updated to {tag}", file=sys.stderr)
