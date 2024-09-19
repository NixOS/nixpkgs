import json
from argparse import ArgumentParser, Namespace
from pathlib import Path

from cuda_redist_lib.index import mk_index


def setup_argparse() -> ArgumentParser:
    parser = ArgumentParser(description="Generate the index of sha256 and relative path for the cuda redist lib")
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
        default=Path(".")
        / "pkgs"
        / "development"
        / "cuda-modules"
        / "redist-index"
        / "data"
        / "indices"
        / "sha256-and-relative-path.json",
    )
    return parser


def main() -> None:
    parser = setup_argparse()
    args: Namespace = parser.parse_args()
    tensorrt_manifest_dir: Path = args.tensorrt_manifest_dir
    output: Path = args.output

    with open(output, "w", encoding="utf-8") as file:
        json.dump(
            mk_index(tensorrt_manifest_dir).model_dump(
                by_alias=True,
                exclude_none=True,
                exclude_unset=True,
                mode="json",
            ),
            file,
            indent=2,
            sort_keys=True,
        )
        file.write("\n")


if __name__ == "__main__":
    main()
