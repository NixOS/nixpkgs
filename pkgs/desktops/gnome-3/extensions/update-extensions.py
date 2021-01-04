#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../.. -i python3 -p python3

import json
import urllib.request
import urllib.error
from typing import List, Dict, Optional, Any, Tuple
import logging
from operator import itemgetter
import subprocess

# We don't want all those deprecated legacy extensions
# Group extensions by Gnome "major" version for compatibility reasons
supported_versions = {
    "36": "3.36",
    "38": "3.38",
}


# Keep track of all names that have been used till now to detect collisions.
# This works because we deterministically process all extensions in historical order
# The outer dict level is the shell version, as we are tracking duplicates only per same Shell version.
# key: shell version, value: Dict with key: pname, value: list of UUIDs with that pname
package_name_registry: Dict[str, Dict[str, List[str]]] = {}
for shell_version in supported_versions.keys():
    package_name_registry[shell_version] = {}


def fetch_sha256sum(uuid: str, version: str) -> str:
    """
    Download the extension and hash it. We use `nix-prefetch-url` for this for efficiency reasons
    """

    # The download URLs follow this schema
    uuid = uuid.replace("@", "")
    url: str = f"https://extensions.gnome.org/extension-data/{uuid}.v{version}.shell-extension.zip"

    return subprocess.run(
        ["nix-prefetch-url", url], capture_output=True, text=True
    ).stdout.strip()


def generate_extension_versions(
    extension_version_map: Dict[str, str], uuid: str
) -> Dict[str, Dict[str, str]]:
    """
    Takes in a mapping from shell versions to extension versions and transforms it the way we need it:
    - Only take one extension version per Gnome Shell major version (as per `supported_versions`)
    - Filter out versions that support old Gnome versions
    - Download the extension and hash it
    """
    extension_versions: Dict[str, Dict[str, str]] = {}
    for shell_version, version_prefix in supported_versions.items():
        # Newest compatible extension version
        extension_version: Optional[int] = max(
            (
                int(ext_ver)
                for shell_ver, ext_ver in extension_version_map.items()
                if (shell_ver.startswith(version_prefix))
            ),
            default=None,
        )
        # Extension is not compatible with this Gnome version
        if not extension_version:
            continue
        logging.debug(
            f"[{shell_version}] Downloading '{uuid}' v{str(extension_version)}"
        )
        sha256 = fetch_sha256sum(uuid, str(extension_version))
        extension_versions[shell_version] = {
            "version": str(extension_version),
            "sha256": sha256,
        }
    return extension_versions


def pname_from_url(url: str) -> Tuple[str, str]:
    """
    Parse something like "/extension/1475/battery-time/" and output ("battery-time", "1475")
    """

    url = url.split("/")  # type: ignore
    return (url[3], url[2])


def sanitize_string(string: str) -> str:
    """
    Replace thinkgs like "\\u0123" in strings. This is required for nix < 2.3.10, as it does not support "\\u"
    """
    # The encode-decode trick also produces "\\n", but Nix supports "\n".
    return string.encode("unicode-escape").decode().replace("\\n", "\n")


def process_extension(extension: Dict[str, Any]) -> Optional[Dict[str, Any]]:
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
                   The number is some monotonically increasing and unique to every extension.
                   The string is usually derived from the extensions's name (but shortened, kebab-cased and URL friendly).
                   It may diverge from the actual name.
            The keys of "shell_version_map" are Gnome Shell version numbers.

        Output: a json object to be stored, or None if the extension should be skipped. Schema:
            {
                "uuid": str,
                "name": str,
                "pname": str,
                "description": str,
                "link": str,
                "shell_version_map": {
                    str: { "version": int, "sha256": str },
                    …
                }
            }
    """
    uuid = extension["uuid"]

    # Yeah, there are some extensions without any releases
    if not extension["shell_version_map"]:
        return None
    logging.info("Processing '" + uuid + "'")

    # Input is a mapping str -> { version: int, … }
    # We want to map shell versions to extension versions
    shell_version_map: Dict[str, int] = {
        k: v["version"] for k, v in extension["shell_version_map"].items()
    }
    # Transform shell_version_map to be more useful for us. Also throw away unwanted versions
    shell_version_map: Dict[str, Dict[str, str]] = generate_extension_versions(shell_version_map, uuid)  # type: ignore

    # No compatible versions found
    if not shell_version_map:
        return None

    # Fetch a human-readable name for the package. If it is already taken by some package,
    # append an ID number to make it unique. This is the first thing we have to do, as the filtering
    # may change over time and thus result in extensions being retroactively renamed. Which we don't want.
    (pname, pname_id) = pname_from_url(extension["link"])

    for shell_version in shell_version_map.keys():
        if pname in package_name_registry[shell_version]:
            logging.warning(f"Package name '{pname}' is colliding.")
            package_name_registry[shell_version][pname] += [uuid]
        else:
            package_name_registry[shell_version][pname] = [uuid]

    return {
        "uuid": uuid,
        "name": sanitize_string(extension["name"]),
        "pname": pname,
        "description": sanitize_string(extension["description"]),
        "link": "https://extensions.gnome.org" + extension["link"],
        "shell_version_map": shell_version_map,
    }


def fetch_extensions() -> List[Dict[str, Any]]:
    """
    Fetch the extensions. The extensions database is scraped by using the search query. We simply go over it
    page by page until we hit a non-full page or a 404 error.

    The returned list is sorted by the age of the extension, in order to be deterministic.
    """
    page = 0
    extensions = []
    while True:
        page += 1
        logging.info("Scraping page " + str(page))
        try:
            with urllib.request.urlopen(
                f"https://extensions.gnome.org/extension-query/?n_per_page=25&page={page}"
            ) as url:
                data = json.loads(url.read().decode())["extensions"]
                responseLength = len(data)

                for extension in data:
                    extensions += [extension]

                # If our page isn't "full", it must have been the last one
                if responseLength < 25:
                    logging.debug(
                        f"\tThis page only has {responseLength} entries, so it must be the last one."
                    )
                    break
        except urllib.error.HTTPError:
            # Assume this error is a 404. We hit the last page; we're done.
            break

    extensions.sort(key=itemgetter("pk"))
    return extensions


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)

    raw_extensions = fetch_extensions()

    logging.info(f"Downloaded {len(raw_extensions)} extensions. Processing …")
    processed_extensions: List[Dict[str, Any]] = []
    for raw_extension in raw_extensions:
        processed_extension = process_extension(raw_extension)
        if processed_extension:
            processed_extensions += [processed_extension]

    logging.info(
        f"Done. Writing results to extensions.json ({len(processed_extensions)} extensions in total)"
    )

    with open("extensions.json", "w") as out:
        # Manually pretty-print the outer level, but then do one compact line per extension
        # This allows for the diffs to be manageable (one line of change per extension) despite their quantity
        for index, extension in enumerate(processed_extensions):
            if index == 0:
                out.write("[   ")
            else:
                out.write(",   ")
            json.dump(extension, out)
            out.write("\n")
        out.write("]\n")

    with open("extensions.json", "r") as out:
        # Check that the generated file actually is valid JSON, just to be sure
        json.load(out)

    logging.info(
        "Done. Writing name collisions to collisions.json (please check manually)"
    )
    with open("collisions.json", "w") as out:
        # Filter out those that are not duplicates
        for shell_version, collisions in package_name_registry.items():
            package_name_registry[shell_version] = {
                k: v for k, v in collisions.items() if len(v) > 1
            }
        json.dump(package_name_registry, out, indent=2)
        out.write("\n")
