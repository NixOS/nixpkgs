#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.semver python3.pkgs.pyyaml buf prefetch-yarn-deps
from urllib.request import Request, urlopen
import dataclasses
import subprocess
import os.path
import semver
from typing import (
    Optional,
    Dict,
    List,
)
import json
import yaml
import os
import tempfile


SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
NIXPKGS = os.path.abspath(os.path.join(SCRIPT_DIR, "../../../../"))


OWNER = "zitadel"
REPO = "zitadel"

FAKEHASH = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

@dataclasses.dataclass
class Pin:
    version: str
    repoHash: str = FAKEHASH
    yarnHash: str = FAKEHASH
    goModulesHash: str = FAKEHASH
    protobufDeps: List[Dict] = dataclasses.field(default_factory=list)

    filename: Optional[str] = None

    def write(self) -> None:
        if not self.filename:
            raise ValueError("No filename set")

        with open(self.filename, "w") as fd:
            pin = dataclasses.asdict(self)
            del pin["filename"]
            json.dump(pin, fd, indent=2)
            fd.write("\n")


def github_get(path: str) -> Dict:
    """Send a GET request to GitHub, optionally adding GITHUB_TOKEN auth header"""
    url = f"https://api.github.com/{path.lstrip('/')}"
    print(f"Retrieving {url}")

    req = Request(url)

    if "GITHUB_TOKEN" in os.environ:
        req.add_header("authorization", f"Bearer {os.environ['GITHUB_TOKEN']}")

    with urlopen(req) as resp:
        return json.loads(resp.read())


def get_release(owner: str, repo: str, tag: str) -> str:
    return github_get(f"/repos/{owner}/{repo}/releases/tags/{tag}")


def run_cmd(cmd: List[str]) -> str:
    """Run a command."""

    proc = subprocess.run(
        cmd,
        check=True,
        stdout=subprocess.PIPE,
    )

    return proc.stdout

def nix_prefetch(url: str, unpack: bool = True):
    """Prefetch a URL."""
    print(f"Prefetching {url}")

    cmd = [ "nix-prefetch-url", "--print-path" ]
    if unpack:
        cmd.append("--unpack")
    cmd.append(url)

    out = run_cmd(cmd)
    out = out.decode().split("\n")
    return { "hash": out[0], "path": out[1], }


def get_latest_tag(owner: str, repo: str, prerelease: bool = False) -> str:
    """Get the latest tag from a GitHub Repo"""
    tags: List[str] = []

    # We hope that the newest release is in the first page of results.
    # This should be the case unless there was a significant amount of prereleases.
    # Collect all of them and sort so we can figure out the latest one.
    for i in range(1,2):  # change the upper bound if the first page is ever *not* enough
        resp = github_get(f"/repos/{owner}/{repo}/releases?page={i}")
        if not resp:
            break

        # Filter out unparseable tags
        for tag in resp:
            try:
                parsed = semver.Version.parse(tag["name"].lstrip("v"))
                if (
                    tag["draft"]
                    or (not prerelease and (parsed.prerelease or tag["prerelease"]))
                ):  # Filter out release candidates
                    continue
            except ValueError:
                continue
            else:
                tags.append(tag)

    # Sort and return latest
    return sorted(tags, key=lambda tag: semver.Version.parse(tag["name"].lstrip("v")))[-1]


def get_fod_hash(attr: str) -> str:
    """
    Get fixed output hash for attribute.
    This depends on a fixed output derivation with the fake hash (lib.fakeHash).
    """

    print(f"Getting fixed output hash for {attr}")

    proc = subprocess.run(["nix-build", NIXPKGS, "-A", attr], stderr=subprocess.PIPE)
    if proc.returncode != 1:
        raise ValueError("Expected nix-build to fail")

    correctHash = FAKEHASH

    # iterate over the stderr lines in reverse
    for line in proc.stderr.decode().split("\n")[::-1]:
        cols = line.split()
        # find the correct hash
        if cols and cols[0] == "got:":
            correctHash = cols[1]
        # but only return it after ensuring it's the missing one
        if cols and cols[0] == "specified:" and cols[1] == FAKEHASH:
            return correctHash

    raise ValueError("No fixed output hash found")

def prefetch_protobuf_dep(remote: str, owner: str, repository: str, commit: str) -> Dict:
    """Prefetch protobuf dependencies."""

    print(f"Prefetching protobuf dependency {repository}")

    with tempfile.TemporaryDirectory() as tmp:
        cache_dir = os.path.join(tmp, ".cache")
        repo_dir = os.path.join(tmp, repository)
        run_cmd([ "env", f"BUF_CACHE_DIR={cache_dir}", "buf", "export", "-o", repo_dir, f"{remote}/{owner}/{repository}:{commit}", ])
        dir_hash = run_cmd([ "nix-hash", "--type", "sha256", repo_dir, ])
        dir_hash = run_cmd([ "nix-hash", "--to-sri", "--type", "sha256", dir_hash.strip(), ])

    return {
        "hash": dir_hash.strip().decode(),
        "remote": remote,
        "owner": owner,
        "repository": repository,
        "commit": commit,
    }


def prefetch_yarn_deps(yarn_lock: str) -> str:
    """Prefetch yarn dependencies from lock file."""

    print(f"Prefetching yarn dependencies for '{yarn_lock}'")

    sha = run_cmd([ "prefetch-yarn-deps", yarn_lock, ]).strip()
    sri = run_cmd([ "nix-hash", "--to-sri", "--base64", "--type", "sha256", sha, ]).strip()
    return f"sha256-{sri.decode()}"

if __name__ == "__main__":
    hash_file = os.path.join(SCRIPT_DIR, "source.json")
    # Get server version
    tag = get_latest_tag(OWNER, REPO)
    version = tag["name"].lstrip("v")

    # short circuit for the update script infra
    # otherwise they'd fetch a bunch of stuff on every run even if there's no new version
    if version == os.getenv("UPDATE_NIX_OLD_VERSION"):
        print("No updates available, exitting...")
        exit(0)

    print(f"Updating to {version}")
    repo = nix_prefetch(tag['tarball_url'])
    repoHash = run_cmd([ "nix-hash", "--to-sri", "--type", "sha256", repo["hash"], ]).strip().decode()
    repoPath = os.path.abspath(repo['path'])

    with open(os.path.join(repoPath, "proto", "buf.lock"), "r") as f:
        protobufDeps = yaml.load(f, yaml.loader.SafeLoader)["deps"]

    protobufDeps = {dep["repository"]: prefetch_protobuf_dep(**dep) for dep in protobufDeps}
    yarnHash = prefetch_yarn_deps(os.path.join(repoPath, "console", "yarn.lock"))

    pin = Pin(version, repoHash, yarnHash, protobufDeps=protobufDeps, filename=hash_file)
    pin.write()
    pin.goModulesHash = get_fod_hash(REPO)
    pin.write()

