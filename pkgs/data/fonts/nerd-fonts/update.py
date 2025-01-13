#! /usr/bin/env nix-shell
#! nix-shell -p python3 -i python3
import os
import urllib.request as ureq
import json
import html

if not all(
    f"UPDATE_NIX_{v}" in os.environ
    for v in ["NAME", "PNAME", "OLD_VERSION", "ATTR_PATH"]
) or not os.environ['UPDATE_NIX_ATTR_PATH'].startswith("nerd-fonts."):
    raise Exception(
        "Please don't run this script manually, only with:\n"
        "nix-shell maintainers/scripts/update.nix --argstr path nerd-fonts "
        "--argstr commit true"
    )

RELEASE_INFO_URL = "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest"
FONTS_INFO_URL_TEMPLATE = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/refs/tags/{}/bin/scripts/lib/fonts.json"
SHA256_URL_TEMPLATE = "https://github.com/ryanoasis/nerd-fonts/releases/download/{}/SHA-256.txt"

RELEASE_INFO_FILENAME = "release.json"
FONTS_INFO_FILENAME = "fonts.json"
CHECKSUMS_FILENAME = "checksums.json"

def fetchjson(url):
    with ureq.urlopen(url) as r:
        return json.loads(r.read())

def storejson(path, obj):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f, indent=2, ensure_ascii=False)
        # Needed to satisfy EditorConfig's rules
        f.write('\n')

def slicedict(d, ks):
    return {k: html.unescape(d[k]) for k in ks}

os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), "manifests"))

release_info = slicedict(
    fetchjson(RELEASE_INFO_URL),
    ["tag_name"]
)

tag_name = release_info["tag_name"]
with open(RELEASE_INFO_FILENAME, "r", encoding="utf-8") as f:
    former_tag_name = json.load(f)["tag_name"]
if tag_name == former_tag_name:
    raise Exception("no newer version available")
# See: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#supported-features
print(json.dumps(
    [
        {
            "attrPath": "nerd-fonts",
            "oldVersion": former_tag_name.removeprefix("v"),
            "newVersion": tag_name.removeprefix("v"),
        },
    ],
    indent=2
))

storejson(RELEASE_INFO_FILENAME, release_info)

storejson(
    FONTS_INFO_FILENAME,
    [
        slicedict(
            item,
            [
                "caskName",
                "description",
                "folderName",
                "licenseId",
                "patchedName",
                "version",
            ]
        )
        for item in fetchjson(FONTS_INFO_URL_TEMPLATE.format(tag_name))["fonts"]
    ],
)

storejson(
    CHECKSUMS_FILENAME,
    {
        filename: sha256
        for row in ureq.urlopen(SHA256_URL_TEMPLATE.format(tag_name))
        for sha256, filename in [row.decode('utf-8').split()]
        if filename.endswith(".tar.xz")
    },
)
