import json
from argparse import ArgumentParser, Namespace
from pathlib import Path

from cuda_redist_lib.extra_types import RedistNames
from cuda_redist_lib.manifest import (
    get_nvidia_manifest_str,
    get_nvidia_manifest_versions,
)
from cuda_redist_lib.utilities import mk_sri_hash


def setup_argparse() -> ArgumentParser:
    parser = ArgumentParser(description="Generate the index of SRI hashes for each CUDA redistributable manifest")
    _ = parser.add_argument(
        "--tensorrt-manifest-dir",
        type=Path,
        help="The directory of the tensorrt manifests",
        required=True,
    )
    _ = parser.add_argument(
        "--output",
        type=Path,
        help="The output file",
        required=False,
        default=Path(".") / "pkgs" / "development" / "cuda-modules" / "redist-index" / "data" / "manifest-hashes.json",
    )
    return parser


def main() -> None:
    parser = setup_argparse()
    args: Namespace = parser.parse_args()
    tensorrt_manifest_dir: Path = args.tensorrt_manifest_dir
    output: Path = args.output

    d = {
        redist_name: {
            version: mk_sri_hash(get_nvidia_manifest_str(redist_name, version, tensorrt_manifest_dir))
            for version in get_nvidia_manifest_versions(redist_name, tensorrt_manifest_dir)
        }
        for redist_name in RedistNames
    }

    with open(output, mode="w", encoding="utf-8") as file:
        json.dump(
            d,
            file,
            indent=2,
            sort_keys=True,
        )
        file.write("\n")
