#!/usr/bin/env nix-shell
#!nix-shell --pure -i python3 -p nix python3 python3Packages.pyyaml cacert

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
from concurrent.futures import ThreadPoolExecutor
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any, Mapping

import yaml

GITHUB_SPECIFIER = re.compile(r"^github:(?P<repository>[^#]+)#(?P<revision>[0-9a-f]+)$")


@dataclass(frozen=True, order=True)
class GitDependency:
    repository: str
    revision: str

    @property
    def url(self) -> str:
        return f"https://codeload.github.com/{self.repository}/tar.gz/{self.revision}"


@dataclass(frozen=True, order=True)
class LockedGitDependency:
    repository: str
    revision: str
    url: str
    hash: str


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--lockfile",
        type=Path,
        help="Existing pnpm-lock.yaml (skips nix-build)",
    )

    parser.add_argument(
        "--attr",
        default=os.getenv("UPDATE_NIX_ATTR_PATH", "vortex") + ".src",
        help="Nix attribute built for 'src'",
    )

    parser.add_argument(
        "--nixpkgs",
        type=Path,
        default=Path(__file__).parents[4],
        help="Nixpkgs to evaluate for --attr",
    )

    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).with_name("pnpm-github-dependencies.json"),
        help="Output JSON lockfile",
    )

    return parser.parse_args()


def iter_objects(node: Any):
    stack = [node]

    while stack:
        node = stack.pop()

        if isinstance(node, Mapping):
            yield node
            stack.extend(reversed(tuple(node.values())))
        elif isinstance(node, (list, tuple)):
            stack.extend(reversed(list(node)))


def iter_git_dependencies(document: Any):
    seen: set[GitDependency] = set()

    for obj in iter_objects(document):
        if not isinstance(specifier := obj.get("specifier"), str):
            continue

        if (match := GITHUB_SPECIFIER.fullmatch(specifier)) is None:
            continue

        dep = GitDependency(
            repository=match["repository"],
            revision=match["revision"],
        )

        if dep in seen:
            continue

        seen.add(dep)
        yield dep


def resolve_lockfile(nixpkgs: Path, attr: str) -> Path:
    src = subprocess.run(
        [
            "nix-build",
            nixpkgs,
            "--no-out-link",
            "--attr",
            attr,
        ],
        check=True,
        stdout=subprocess.PIPE,
        text=True,
    ).stdout.strip()

    return Path(src) / "pnpm-lock.yaml"


def prefetch(dep: GitDependency) -> LockedGitDependency:
    result = subprocess.run(
        [
            "nix",
            "store",
            "prefetch-file",
            "--json",
            dep.url,
        ],
        check=True,
        stdout=subprocess.PIPE,
        text=True,
    ).stdout

    return LockedGitDependency(
        repository=dep.repository,
        revision=dep.revision,
        url=dep.url,
        hash=json.loads(result)["hash"],
    )


def generate_lockfile(lockfile: Path) -> list[LockedGitDependency]:
    with lockfile.open() as f:
        deps = (
            dep
            for document in yaml.safe_load_all(f)
            for dep in iter_git_dependencies(document)
        )

        with ThreadPoolExecutor() as executor:
            return sorted(executor.map(prefetch, deps))


def write_lockfile(entries, output: Path) -> None:
    with output.open("w") as f:
        json.dump(
            [asdict(entry) for entry in entries],
            f,
            indent=2,
        )
        f.write("\n")


def main() -> int:
    args = parse_args()

    lockfile = args.lockfile or resolve_lockfile(args.nixpkgs, args.attr)
    entries = generate_lockfile(lockfile)
    write_lockfile(entries, args.output)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
