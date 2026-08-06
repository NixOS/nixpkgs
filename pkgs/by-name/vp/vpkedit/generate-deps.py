# Modified version of the dependencies script found at
# https://github.com/underscorejoser/MareTF/blob/4968d457674bcda3c6f92c54b0b1c70a33829dd8/.build-aux/fetchcontent2flatpak.py
# Under the MIT License
import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Final

FETCHCONTENT_REGEX: Final[str] = (
    r"^--\ Fetching\ (?P<name>.+)\ (?P<url>.+)\ (?P<commit>.+)\n?$"
)
SHA1_REGEX: Final[str] = r"^[0-9a-f]{40}$"


class FetchContent:
    name: str
    url: str
    branch: str | None = None
    commit: str | None = None
    tag: str | None = None
    custom_flag: str | None = None

    def __init__(
        self, name: str, url: str, rev: str, custom_flag: str | None = None
    ) -> None:
        self.name = name
        self.url = url

        if custom_flag:
            self.custom_flag = custom_flag

        if not re.match(SHA1_REGEX, rev, re.IGNORECASE):
            self.branch = rev

            # Maybe not a good idea running processes on __init__?
            result = subprocess.run(
                ["git", "ls-remote", url, rev], stdout=subprocess.PIPE, text=True
            )
            if result.returncode == 0:
                output = result.stdout.rstrip().split()

                if re.match(SHA1_REGEX, output[0], re.IGNORECASE):
                    self.commit = output[0]
                if output[1].startswith("refs/tags/"):
                    self.tag = output[1].split("/")[2]
        else:
            self.commit = rev


def parse_stdout(command: list[str]) -> list[FetchContent]:
    matches: list[FetchContent] = []

    process = subprocess.Popen(
        command,
        stdout=subprocess.PIPE,
        stderr=sys.stderr,
        text=True,
        bufsize=1,
    )

    if process.stdout:
        for line in process.stdout:
            line = line.rstrip()
            print(line)

            try_match = re.match(FETCHCONTENT_REGEX, line)
            if try_match:
                name, url, rev = try_match.groups()
                matches.append(FetchContent(name, url, rev))

        process.stdout.close()

    returncode = process.wait()
    if returncode != 0:
        raise subprocess.CalledProcessError(returncode, command)

    return matches


def flatpak_configure(
    build_dir: str, runtime: str, additional_args: list[str] = []
) -> list[FetchContent]:
    flatpak = shutil.which("flatpak")
    cwd = os.getcwd()

    if not flatpak:
        raise FileNotFoundError("flatpak")

    command = [
        flatpak,
        "run",
        "--devel",
        "--share=network",
        f"--filesystem={cwd}",
        f"--filesystem={build_dir}",
        "--command=cmake",
        runtime,
        "-B",
        build_dir,
        *additional_args,
    ]
    return parse_stdout(command)


def local_configure(
    build_dir: str, additional_args: list[str] = []
) -> list[FetchContent]:
    cmake = shutil.which("cmake")

    if not cmake:
        raise FileNotFoundError("cmake")

    command = [cmake, "-B", build_dir, *additional_args]
    return parse_stdout(command)


def to_flatpak(sources: list[FetchContent]):
    sources_array: list[dict[str, str]] = []
    flags: list[str] = []

    for source in sources:
        obj = {
            "type": "git",
            "url": source.url,
            "dest": f"_deps/{source.name.lower()}",
        }

        if source.commit:
            obj.update({"commit": source.commit})
        if source.tag:
            obj.update({"tag": source.tag})
        # elif source.branch:
        #     obj.update({"branch": source.branch})

        sources_array.append(obj)

        env = (
            source.custom_flag
            if source.custom_flag
            else f"FETCHCONTENT_SOURCE_DIR_{source.name.upper()}"
        )
        # Assumes `builddir: true` on manifest
        flags.append(f"-D{env}=../_deps/{source.name.lower()}")

    sources_json = json.dumps(sources_array, indent=4)

    return (sources_json, "\n".join(flags))

def parse_nixout(command: list[str]) -> str:
    out: str = ""

    process = subprocess.run(
        command,
        text=True,
        bufsize=1,
        capture_output=True,
    )

    if process.stdout:
        out = process.stdout
    return out

def nix_fetch(url: str, rev: str, tag: str):
    nix_prefetch_git = shutil.which("nix-prefetch-git")
    hash: str = "FAILED"
    if not nix_prefetch_git:
        raise FileNotFoundError("nix-prefetch-git")

    if rev:
        command = [
            nix_prefetch_git,
            "--url",
            url,
            "--rev",
            rev,
            "--quiet",
            "--fetch-submodules",
            "--no-add-path"
        ]
    elif tag:
        command = [
            nix_prefetch_git,
            "--url",
            url,
            "--rev",
            f"refs/tags/{tag}",
            "--quiet",
            "--fetch-submodules",
            "--no-add-path"
        ]
    else:
        command = []

    print(f"nix-prefetch-git: fetching {url}")
    try:
        hash = json.loads(f"{parse_nixout(command)}")['hash']
    except ValueError:
        print(f"nix-prefetch-git: failed to fetch {url}. re-run or fetch manually")

    return hash

def to_nix(sources: list[FetchContent]):
    lines: list[str] = []
    flags: list[str] = []

    flags.append("cmakeFlags = with finalAttrs; [")

    for source in sources:
        lines.append(f"{source.name.lower()}-src = fetchgit {{")
        lines.append(f'  url = "{source.url}";')
        if source.tag:
            lines.append(f'  tag = "{source.tag}";')
        elif source.commit:
            lines.append(f'  rev = "{source.commit}";')
        lines.append(f'  hash = "{nix_fetch(f"{source.url}",f"{source.commit}",f"{source.tag}")}";')
        lines.append("};\n")

        env = (
            source.custom_flag
            if source.custom_flag
            else f"FETCHCONTENT_SOURCE_DIR_{source.name.upper()}"
        )
        flags.append(f'  (lib.cmakeFeature "{env}" "${{{source.name.lower()}-src}}")')

    flags.append("];")

    return ("\n".join(lines), "\n".join(flags))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--runtime", "-r")
    parser.add_argument("--output", "-o")
    parser.add_argument("--to-flatpak", "-f", action="store_true")
    parser.add_argument("--to-nix", "-n", action="store_true")
    parser.add_argument("--args", action="store_true")

    opts, args = parser.parse_known_args()
    args = args if opts.args else []

    matches: list[FetchContent] = []

    if opts.to_flatpak or opts.to_nix:
        with tempfile.TemporaryDirectory() as build_dir:
            try:
                if opts.runtime:
                    matches.extend(flatpak_configure(build_dir, opts.runtime, args))
                else:
                    matches.extend(local_configure(build_dir, args))
            except FileNotFoundError as err:
                print(f'File "{err}" was not found!')
                return 1
            except subprocess.CalledProcessError as err:
                print(f'Subprocess "{" ".join(err.cmd)}" failed!')
                return 1
    else:
        print("You need to specify either --to-flatpak or --to-nix")
        return 1

# appended manually because of how it gets fetched
# for any others that also don't get picked up by the script add them here

    matches.append(
        FetchContent(
            "cryptopp",
            "https://github.com/weidai11/cryptopp",
            "master",
            "CRYPTOPP_SOURCES",
        )
    )

    if opts.to_flatpak:
        sources, flags = to_flatpak(matches)

        print()
        if opts.output:
            path = Path(opts.output)
            path.write_text(sources)
        else:
            print(sources)

        print(flags)
    elif opts.to_nix:
        sources, flags = to_nix(matches)
        print()
        print(sources)
        print(flags)

    return 0


if __name__ == "__main__":
    sys.exit(main())
