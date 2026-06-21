import json
import os
import string
import subprocess
from pathlib import Path
from typing import TypedDict

from gftools.fonts_public_pb2 import FamilyProto
from gftools.util.google_fonts import FontDirs
from google.protobuf import text_format


class FontFamily(TypedDict):
    name: str
    designer: str
    minisite: str
    category: str  # `classifications` and `strokes` are not always present
    license: str
    path: str


def collect_font(google_fonts_src: Path, font_dir: Path) -> FontFamily:
    family = FamilyProto()

    # Parsing is done similar to `gftools.util.google_fonts.Metadata`, but we
    # need to set `allow_unknown_field=True` as some `METADATA.pb` files in
    # the Google Fonts repo contain a key that isn't defined in the
    # `FamilyProto` message, and we don't want to fail on those.
    # https://github.com/googlefonts/gftools/blob/v0.9.995/Lib/gftools/util/google_fonts.py#L179
    with (font_dir / "METADATA.pb").open("r") as f:
        text_format.Merge(f.read(), family, allow_unknown_field=True)

    # Verify that the name only contains alphanumeric characters and spaces
    # because the Nix attribute name will be derived from it under this
    # assumption.
    allowed_chars = string.ascii_letters + string.digits + " "
    assert all(c in allowed_chars for c in family.name)

    # https://googlefonts.github.io/gf-guide/metadata.html#description-of-keys
    return FontFamily(
        name=family.name,
        designer=family.designer,
        minisite=family.minisite_url,
        # Google Fonts only uses the last category
        # https://github.com/googlefonts/gftools/blob/v0.9.995/Lib/gftools/fonts_public.proto#L25-L26
        category=family.category[-1],
        license=family.license,
        path=str(font_dir.relative_to(google_fonts_src)),
    )


def collect_fonts(google_fonts_src: Path) -> list[FontFamily]:
    fonts = list(
        sorted(
            (
                collect_font(google_fonts_src, Path(font_dir))
                for font_dir in FontDirs(google_fonts_src)
                if not font_dir.endswith("_todelist")  # Fonts to be delisted
            ),
            key=lambda font: font["name"],
        )
    )

    # Sanity check that there are no duplicate font family names
    assert len(fonts) == len(set(font["name"] for font in fonts))

    return fonts


def main():
    # Absolute path to the nixpkgs top-level directory
    nixpkgs = Path(
        subprocess.check_output(["git", "rev-parse", "--show-toplevel"])
        .decode("utf-8")
        .strip()
    )

    # Absolute path to the `google-fonts` package directory
    nixpkgs_google_fonts = nixpkgs / "pkgs/data/fonts/google-fonts"

    # Nothing to do if the unstable updater didn't change anything
    if not subprocess.check_output(
        ["git", "status", "--porcelain", nixpkgs_google_fonts]
    ):
        print("[]")
        return

    # Absolute path to new source
    google_fonts_src = Path(
        subprocess.check_output(
            [
                "nix-build",
                nixpkgs,
                "--no-out-link",
                "-A",
                "google-fonts-full.src",
            ]
        )
        .decode("utf-8")
        .strip()
    )

    old_version = os.environ["UPDATE_NIX_OLD_VERSION"]
    new_version = (
        subprocess.check_output(
            [
                "nix-instantiate",
                nixpkgs,
                "--eval",
                "--raw",
                "-A",
                "google-fonts-full.version",
            ]
        )
        .decode("utf-8")
        .strip()
    )

    # Collect metadata and write it to `fonts.json`
    fonts = collect_fonts(google_fonts_src)
    with (nixpkgs_google_fonts / "fonts.json").open("w") as f:
        json.dump(fonts, f, indent=2, ensure_ascii=False)
        f.write("\n")

    # Describe the commit that will be made to update the package
    print(
        json.dumps(
            [
                {
                    "attrPath": "google-fonts",
                    "oldVersion": old_version,
                    "newVersion": new_version,
                    "files": [
                        str(nixpkgs_google_fonts / "default.nix"),
                        str(nixpkgs_google_fonts / "fonts.json"),
                    ],
                },
            ],
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
