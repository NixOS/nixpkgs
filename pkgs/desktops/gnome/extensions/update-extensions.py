#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../.. -i python3 -p python3

### After making change:
### - Format the script by running: nix run nixpkgs#black pkgs/desktops/gnome/extensions/update-extensions.py
### - Run the unit test by running: python3 -m unittest pkgs/desktops/gnome/extensions/update-extensions.py
### - Run the type checking by running: nix run nixpkgs#mypy pkgs/desktops/gnome/extensions/update-extensions.py

import base64
import json
import logging
import argparse
import unittest
import subprocess
import urllib.error
import urllib.request
from contextlib import contextmanager
from operator import itemgetter
from pathlib import Path
from typing import Any

# We don't want all those deprecated legacy extensions
# Group extensions by GNOME "major" version for compatibility reasons
supported_versions = {
    "38": "3.38",
    "40": "40",
    "41": "41",
    "42": "42",
    "43": "43",
    "44": "44",
    "45": "45",
    "46": "46",
    "47": "47",
    "48": "48",
    "49": "49",
}

# shell versions that we want to put into the gnomeExtensions attr set
versions_to_merge = ["47", "48", "49"]

# Some type alias to increase readability of complex compound types
PackageName = str
ShellVersion = str
Uuid = str
ExtensionVersion = int

updater_dir_path = Path(__file__).resolve().parent


def fetch_extension_data(uuid: str, version: str) -> tuple[str, str]:
    """
    Download the extension and hash it. We use `nix-prefetch-url` for this for efficiency reasons.
    Returns a tuple with the hash (Nix-compatible) of the zip file's content and the base64-encoded content of its metadata.json.
    """

    # The download URLs follow this schema
    uuid = uuid.replace("@", "")
    url: str = (
        f"https://extensions.gnome.org/extension-data/{uuid}.v{version}.shell-extension.zip"
    )

    # Download extension and add the zip content to nix-store
    for _ in range(0, 10):
        process = subprocess.run(
            ["nix-prefetch-url", "--unpack", "--print-path", url],
            capture_output=True,
            text=True,
        )
        if process.returncode == 0:
            break
        else:
            logging.warning(f"Nix-prefetch-url failed for {url}:")
            logging.warning(f"Stderr: {process.stderr}")
            logging.warning("Retrying")

    if process.returncode != 0:
        raise Exception(
            "Retried 10 times, but still failed to download the extension. Exiting."
        )

    lines = process.stdout.splitlines()

    # Get hash from first line of nix-prefetch-url output
    hash = lines[0].strip()

    # Get path from second line of nix-prefetch-url output
    path = Path(lines[1].strip())

    # Get metadata.json content from nix-store
    with open(path / "metadata.json", "r") as out:
        metadata = base64.b64encode(out.read().encode("ascii")).decode()

    return hash, metadata


def generate_extension_versions(
    extension_version_map: dict[ShellVersion, ExtensionVersion],
    uuid: str,
) -> dict[ShellVersion, dict[str, str]]:
    """
    Takes in a mapping from shell versions to extension versions and transforms it the way we need it:
    - Only take one extension version per GNOME Shell major version (as per `supported_versions`)
    - Filter out versions that only support old GNOME versions
    - Download the extension and hash it
    """

    # Determine extension version per shell version
    extension_versions: dict[ShellVersion, ExtensionVersion] = {}
    for shell_version, version_prefix in supported_versions.items():
        # Newest compatible extension version
        extension_version: int | None = max(
            (
                int(ext_ver)
                for shell_ver, ext_ver in extension_version_map.items()
                if (shell_ver.startswith(version_prefix))
            ),
            default=None,
        )
        # Extension is not compatible with this GNOME version
        if not extension_version:
            continue

        extension_versions[shell_version] = extension_version

    # Download information once for all extension versions chosen above
    extension_info_cache: dict[ExtensionVersion, tuple[str, str]] = {}
    for extension_version in sorted(set(extension_versions.values())):
        logging.debug(f"[{uuid}] Downloading v{extension_version}")
        extension_info_cache[extension_version] = fetch_extension_data(
            uuid,
            str(extension_version),
        )

    # Fill map
    extension_versions_full: dict[ShellVersion, dict[str, str]] = {}
    for shell_version, extension_version in extension_versions.items():
        sha256, metadata = extension_info_cache[extension_version]

        extension_versions_full[shell_version] = {
            "version": str(extension_version),
            "sha256": sha256,
            # The downloads are impure, their metadata.json may change at any time.
            # Thus, we back it up / pin it to remain deterministic
            # Upstream issue: https://gitlab.gnome.org/Infrastructure/extensions-web/-/issues/137
            "metadata": metadata,
        }
    return extension_versions_full


def pname_from_url(url: str) -> tuple[str, str]:
    """
    Parse something like "/extension/1475/battery-time/" and output ("battery-time", "1475")
    """

    url = url.split("/")  # type: ignore
    return url[3], url[2]


def process_extension(extension: dict[str, Any]) -> dict[str, Any] | None:
    """
    Process an extension. It takes in raw scraped data and downloads all the necessary information that buildGnomeExtension.nix requires

        Input: a json object of one extension queried from the site. It has the following schema (only important key listed):
            {
                "uuid": str,
                "name": str,
                "description": str,
                "link": str,
                "shell_version_map": {
                    str: { "version": int, … },
                    …
                },
                …
            }

            "uuid" is an extension UUID that looks like this (most of the time): "extension-name@username.domain.tld".
                   Don't make any assumptions on it, and treat it like an opaque string!
            "link" follows the following schema: "/extension/$number/$string/"
                   The number is monotonically increasing and unique to every extension.
                   The string is usually derived from the extension name (but shortened, kebab-cased and URL friendly).
                   It may diverge from the actual name.
            The keys of "shell_version_map" are GNOME Shell version numbers.

        Output: a json object to be stored, or None if the extension should be skipped. Schema:
            {
                "uuid": str,
                "name": str,
                "pname": str,
                "description": str,
                "link": str,
                "shell_version_map": {
                    str: { "version": int, "sha256": str, "metadata": <hex> },
                    …
                }
            }

            Only "uuid" gets passed along unmodified. "name", "description" and "link" are taken from the input, but sanitized.
            "pname" gets generated from other fields and "shell_version_map" has a completely different structure than the input
            field with the same name.
    """
    uuid = extension["uuid"]

    # Yeah, there are some extensions without any releases
    if not extension["shell_version_map"]:
        return None
    logging.info(f"Processing '{uuid}'")

    # Input is a mapping str -> { version: int, … }
    # We want to map shell versions to extension versions
    shell_version_map: dict[ShellVersion, int] = {
        k: v["version"] for k, v in extension["shell_version_map"].items()
    }
    # Transform shell_version_map to be more useful for us. Also throw away unwanted versions
    shell_version_map: dict[ShellVersion, dict[str, str]] = generate_extension_versions(shell_version_map, uuid)  # type: ignore

    # No compatible versions found
    if not shell_version_map:
        return None

    # Fetch a human-readable name for the package.
    (pname, _pname_id) = pname_from_url(extension["link"])

    return {
        "uuid": uuid,
        "name": extension["name"],
        "pname": pname,
        "description": extension["description"],
        "link": "https://extensions.gnome.org" + extension["link"],
        "shell_version_map": shell_version_map,
    }


@contextmanager
def request(url: str, retries: int = 5, retry_codes: list[int] = [500, 502, 503, 504]):
    req = urllib.request.Request(
        url,
        headers={
            "User-Agent": "NixpkgsGnomeExtensionUpdate (+https://github.com/NixOS/nixpkgs)"
        },
    )
    for attempt in range(retries + 1):
        try:
            with urllib.request.urlopen(req) as response:
                yield response
                break
        except urllib.error.HTTPError as e:
            if e.code in retry_codes and attempt < retries:
                logging.warning(f"Error while fetching {url}. Retrying: {e}")
            else:
                raise e


def scrape_extensions_index() -> list[dict[str, Any]]:
    """
    Scrape the list of extensions by sending search queries to the API. We simply go over it
    page by page until we hit a non-full page or a 404 error.

    The returned list is sorted by the age of the extension, in order to be deterministic.
    """
    page = 0
    extensions = []
    while True:
        page += 1
        logging.info("Scraping page " + str(page))
        try:

            with request(
                f"https://extensions.gnome.org/extension-query/?n_per_page=25&page={page}"
            ) as response:
                data = json.loads(response.read().decode())["extensions"]
                response_length = len(data)

                for extension in data:
                    extensions.append(extension)

                # If our page isn't "full", it must have been the last one
                if response_length < 25:
                    logging.debug(
                        f"\tThis page only has {response_length} entries, so it must be the last one."
                    )
                    break
        except urllib.error.HTTPError as e:
            if e.code == 404:
                # We reached past the last page and are done now
                break
            else:
                raise

    # `pk` is the primary key in the extensions.gnome.org database. Sorting on it will give us a stable,
    # deterministic ordering.
    extensions.sort(key=itemgetter("pk"))
    return extensions


def fetch_extensions() -> list[dict[str, Any]]:
    raw_extensions = scrape_extensions_index()

    logging.info(f"Downloaded {len(raw_extensions)} extensions. Processing …")
    processed_extensions: list[dict[str, Any]] = []
    for num, raw_extension in enumerate(raw_extensions):
        processed_extension = process_extension(raw_extension)
        if processed_extension:
            processed_extensions.append(processed_extension)
            logging.debug(f"Processed {num + 1} / {len(raw_extensions)}")

    return processed_extensions


def serialize_extensions(processed_extensions: list[dict[str, Any]]) -> None:
    # We micro-manage a lot of the serialization process to keep the diffs optimal.
    # We generally want most of the attributes of an extension on one line,
    # but then each of its supported versions with metadata on a new line.
    with open(updater_dir_path / "extensions.json", "w") as out:
        for index, extension in enumerate(processed_extensions):
            # Manually pretty-print the outermost array level
            if index == 0:
                out.write("[ ")
            else:
                out.write(", ")
            # Dump each extension into a single-line string forst
            serialized_extension = json.dumps(extension, ensure_ascii=False)
            # Inject line breaks for each supported version
            for version in supported_versions:
                # This one only matches the first entry
                serialized_extension = serialized_extension.replace(
                    f'{{"{version}": {{',
                    f'{{\n    "{version}": {{',
                )
                # All other entries
                serialized_extension = serialized_extension.replace(
                    f', "{version}": {{',
                    f',\n    "{version}": {{',
                )
            # One last line break around the closing braces
            serialized_extension = serialized_extension.replace("}}}", "}\n  }}")

            out.write(serialized_extension)
            out.write("\n")
        out.write("]\n")


def find_collisions(
    extensions: list[dict[str, Any]],
    versions: list[str],
) -> dict[PackageName, list[Uuid]]:
    package_name_registry: dict[PackageName, set[Uuid]] = {}
    for extension in extensions:
        pname = extension["pname"]
        uuid = extension["uuid"]
        for shell_version in versions:
            if shell_version in extension["shell_version_map"]:
                package_name_registry.setdefault(pname, set()).add(uuid)
    return {
        pname: sorted(uuids)
        for pname, uuids in sorted(package_name_registry.items())
        if len(uuids) > 1
    }


def main() -> None:
    logging.basicConfig(level=logging.DEBUG)
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--skip-fetch",
        action="store_true",
        help="Skip fetching extensions. When this option is set, the script does not fetch extensions from the internet, but checks for name collisions.",
    )
    args = parser.parse_args()

    if not args.skip_fetch:
        processed_extensions = fetch_extensions()

        serialize_extensions(processed_extensions)

        logging.info(
            f"Done. Writing results to extensions.json ({len(processed_extensions)} extensions in total)"
        )

    with open(updater_dir_path / "extensions.json", "r") as out:
        extensions = json.load(out)

    collisions = find_collisions(extensions, versions_to_merge)

    with open(updater_dir_path / "collisions.json", "w") as out:
        json.dump(collisions, out, indent=2, ensure_ascii=False)
        out.write("\n")

    logging.info(
        "Done. Writing name collisions to collisions.json (please check manually)"
    )


if __name__ == "__main__":
    main()


class FindCollisions(unittest.TestCase):
    extensions = [
        {
            "pname": "foo",
            "uuid": "foo_38_to_40@doe.example",
            "shell_version_map": {
                "38": {},
                "40": {},
            },
        },
        {
            "pname": "bar",
            "uuid": "bar_42_to_45@chulsoo.example",
            "shell_version_map": {
                "42": {},
                "43": {},
                "44": {},
                "45": {},
            },
        },
        {
            "pname": "bar",
            "uuid": "bar_44_to_47@younghee.example",
            "shell_version_map": {
                "44": {},
                "45": {},
                "46": {},
                "47": {},
            },
        },
    ]

    def test_no_collision(self) -> None:
        self.assertEqual(
            {},
            find_collisions(self.extensions, ["40", "41", "42"]),
        )

    def test_collision(self) -> None:
        self.assertEqual(
            {
                "bar": [
                    "bar_42_to_45@chulsoo.example",
                    "bar_44_to_47@younghee.example",
                ],
            },
            find_collisions(self.extensions, ["45", "46", "47"]),
        )
