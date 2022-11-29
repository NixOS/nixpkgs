#! /usr/bin/env python3

from itertools import chain
import json
import logging
from pathlib import Path
import os
import re
import subprocess
import sys
from typing import Dict, List, Optional, Set, TextIO
from urllib.request import urlopen
from urllib.error import HTTPError
import yaml

PKG_SET = "pkgs.python3Packages"

# If some requirements are matched by multiple or no Python packages, the
# following can be used to choose the correct one
PKG_PREFERENCES = {
    "dnspython": "dnspython",
    "google-api-python-client": "google-api-python-client",
    "psycopg2-binary": "psycopg2",
    "requests_toolbelt": "requests-toolbelt",
}

# Requirements missing from the airflow provider metadata
EXTRA_REQS = {
    "sftp": ["pysftp"],
}


def get_version():
    with open(os.path.dirname(sys.argv[0]) + "/default.nix") as fh:
        # A version consists of digits, dots, and possibly a "b" (for beta)
        m = re.search('version = "([\\d\\.b]+)";', fh.read())
        return m.group(1)


def get_file_from_github(version: str, path: str):
    with urlopen(
        f"https://raw.githubusercontent.com/apache/airflow/{version}/{path}"
    ) as response:
        return yaml.safe_load(response)


def repository_root() -> Path:
    return Path(os.path.dirname(sys.argv[0])) / "../../../.."


def dump_packages() -> Dict[str, Dict[str, str]]:
    # Store a JSON dump of Nixpkgs' python3Packages
    output = subprocess.check_output(
        [
            "nix-env",
            "-f",
            repository_root(),
            "-qa",
            "-A",
            PKG_SET,
            "--arg",
            "config",
            "{ allowAliases = false; }",
            "--json",
        ]
    )
    return json.loads(output)


def remove_version_constraint(req: str) -> str:
    return re.sub(r"[=><~].*$", "", req)


def name_to_attr_path(req: str, packages: Dict[str, Dict[str, str]]) -> Optional[str]:
    if req in PKG_PREFERENCES:
        return f"{PKG_SET}.{PKG_PREFERENCES[req]}"
    attr_paths = []
    names = [req]
    # E.g. python-mpd2 is actually called python3.6-mpd2
    # instead of python-3.6-python-mpd2 inside Nixpkgs
    if req.startswith("python-") or req.startswith("python_"):
        names.append(req[len("python-") :])
    for name in names:
        # treat "-" and "_" equally
        name = re.sub("[-_]", "[-_]", name)
        # python(minor).(major)-(pname)-(version or unstable-date)
        # we need the version qualifier, or we'll have multiple matches
        # (e.g. pyserial and pyserial-asyncio when looking for pyserial)
        pattern = re.compile(
            f"^python\\d+\\.\\d+-{name}-(?:\\d|unstable-.*)", re.I
        )
        for attr_path, package in packages.items():
            # logging.debug("Checking match for %s with %s", name, package["name"])
            if pattern.match(package["name"]):
                attr_paths.append(attr_path)
    # Let's hope there's only one derivation with a matching name
    assert len(attr_paths) <= 1, f"{req} matches more than one derivation: {attr_paths}"
    if attr_paths:
        return attr_paths[0]
    return None


def provider_reqs_to_attr_paths(reqs: List, packages: Dict) -> List:
    no_version_reqs = map(remove_version_constraint, reqs)
    filtered_reqs = [
        req for req in no_version_reqs if not re.match(r"^apache-airflow", req)
    ]
    attr_paths = []
    for req in filtered_reqs:
        attr_path = name_to_attr_path(req, packages)
        if attr_path is not None:
            # Add attribute path without "python3Packages." prefix
            pname = attr_path[len(PKG_SET + ".") :]
            attr_paths.append(pname)
        else:
            # If we can't find it, we just skip and warn the user
            logging.warning("Could not find package attr for %s", req)
    return attr_paths


def get_cross_provider_reqs(
    provider: str, provider_reqs: Dict, cross_provider_deps: Dict, seen: List = None
) -> Set:
    # Unfortunately there are circular cross-provider dependencies, so keep a
    # list of ones we've seen already
    seen = seen or []
    reqs = set(provider_reqs[provider])
    if len(cross_provider_deps[provider]) > 0:
        reqs.update(
            chain.from_iterable(
                get_cross_provider_reqs(
                    d, provider_reqs, cross_provider_deps, seen + [provider]
                )
                if d not in seen
                else []
                for d in cross_provider_deps[provider]
            )
        )
    return reqs


def get_provider_reqs(version: str, packages: Dict) -> Dict:
    provider_dependencies = get_file_from_github(
        version, "generated/provider_dependencies.json"
    )
    provider_reqs = {}
    cross_provider_deps = {}
    for provider, provider_data in provider_dependencies.items():
        provider_reqs[provider] = list(
            provider_reqs_to_attr_paths(provider_data["deps"], packages)
        ) + EXTRA_REQS.get(provider, [])
        cross_provider_deps[provider] = [
            d for d in provider_data["cross-providers-deps"] if d != "common.sql"
        ]
    transitive_provider_reqs = {}
    # Add transitive cross-provider reqs
    for provider in provider_reqs:
        transitive_provider_reqs[provider] = get_cross_provider_reqs(
            provider, provider_reqs, cross_provider_deps
        )
    return transitive_provider_reqs


def get_provider_yaml(version: str, provider: str) -> Dict:
    provider_dir = provider.replace(".", "/")
    path = f"airflow/providers/{provider_dir}/provider.yaml"
    try:
        return get_file_from_github(version, path)
    except HTTPError:
        logging.warning("Couldn't get provider yaml for %s", provider)
        return {}


def get_provider_imports(version: str, providers) -> Dict:
    provider_imports = {}
    for provider in providers:
        provider_yaml = get_provider_yaml(version, provider)
        imports: List[str] = []
        if "hooks" in provider_yaml:
            imports.extend(
                chain.from_iterable(
                    hook["python-modules"] for hook in provider_yaml["hooks"]
                )
            )
        if "operators" in provider_yaml:
            imports.extend(
                chain.from_iterable(
                    operator["python-modules"]
                    for operator in provider_yaml["operators"]
                )
            )
        provider_imports[provider] = imports
    return provider_imports


def to_nix_expr(provider_reqs: Dict, provider_imports: Dict, fh: TextIO) -> None:
    fh.write("# Warning: generated by update-providers.py, do not update manually\n")
    fh.write("{\n")
    for provider, reqs in provider_reqs.items():
        provider_name = provider.replace(".", "_")
        fh.write(f"  {provider_name} = {{\n")
        fh.write(
            "    deps = [ " + " ".join(sorted(f'"{req}"' for req in reqs)) + " ];\n"
        )
        fh.write(
            "    imports = [ "
            + " ".join(sorted(f'"{imp}"' for imp in provider_imports[provider]))
            + " ];\n"
        )
        fh.write("  };\n")
    fh.write("}\n")


def main() -> None:
    logging.basicConfig(level=logging.INFO)
    version = get_version()
    packages = dump_packages()
    logging.info("Generating providers.nix for version %s", version)
    provider_reqs = get_provider_reqs(version, packages)
    provider_imports = get_provider_imports(version, provider_reqs.keys())
    with open("providers.nix", "w") as fh:
        to_nix_expr(provider_reqs, provider_imports, fh)


if __name__ == "__main__":
    main()
