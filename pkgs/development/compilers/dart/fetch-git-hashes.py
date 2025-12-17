#! /usr/bin/env nix-shell
#! nix-shell -i python3 --packages python3 nix-prefetch-git

import argparse
import json
import subprocess
from pathlib import Path


def fetch_git_hash(url: str, rev: str) -> str:
    result = subprocess.run(
        ["nix-prefetch-git", "--url", url, "--rev", rev],
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(result.stdout)["hash"]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-i",
        "--input",
        type=Path,
        default=Path(__file__).parent.resolve() / "pubspec.lock.json",
    )
    parser.add_argument("-o", "--output", type=Path, default=None)
    args = parser.parse_args()
    output_file: Path | None = args.output
    output: dict[str, str] = {}
    for name, info in json.loads(args.input.read_text()).get("packages", {}).items():
        if info.get("source") != "git":
            continue
        desc = info.get("description")
        if not isinstance(desc, dict):
            continue
        url = desc.get("url")
        rev = desc.get("resolved-ref")
        if not (isinstance(url, str) and isinstance(rev, str)):
            continue
        output[name] = fetch_git_hash(url, rev)
    output_json = json.dumps(output, indent=2, sort_keys=True) + "\n"
    if output_file:
        output_file.write_text(output_json)
    else:
        print(output_json, end="")


if __name__ == "__main__":
    main()
