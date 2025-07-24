#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i python3 -p nix nix-prefetch-github platformio python3

from pathlib import Path
import argparse
import json
import os
import shutil
import subprocess as sp
import sys
import tempfile
import urllib.request


def run(cmd, *args, check=True, **kwargs):
    print(f"running command: {' '.join(list(map(str, cmd)))}", file=sys.stderr)
    return sp.run(cmd, *args, **kwargs, check=check)


def latest_tag():
    req = urllib.request.urlopen(
        "https://api.github.com/repos/arendst/Tasmota/releases/latest"
    ).read()
    return json.loads(req)["tag_name"]


def fetch_source(repo, tag):
    if repo.exists():
        run(["git", "fetch", "--all"], cwd=repo)
        run(["git", "checkout", tag], cwd=repo)
    else:
        run(["git", "clone", "https://github.com/arendst/Tasmota", repo])
        run(["git", "checkout", tag], cwd=repo)


def source_info(tag):
    print(
        f"fetching source info for tag {tag}",
    )
    return json.loads(
        run(
            [
                "nix-prefetch-github",
                "arendst",
                "Tasmota",
                "--json",
                "--rev",
                tag,
            ],
            capture_output=True,
        ).stdout
    )


def package_attrs(attr_path):
    nixpkgs_path = "."
    return json.loads(sp.run(
        [
            "nix",
            "--extra-experimental-features", "nix-command",
            "eval",
            "--json",
            "--file", nixpkgs_path,
            "--apply", """p: {
            dir = builtins.dirOf p.meta.position;
            version = p.version;
            sourceHash = p.src.outputHash;
            }""",
            "--",
            attr_path,
        ],
        stdout=sp.PIPE,
        text=True,
        check=True,
    ).stdout)


def patch_nix_file(tag, source_hash, package_attrs):
    file = Path(package_attrs["dir"] + "/generic.nix")
    old_version = package_attrs["version"]
    old_hash = package_attrs["sourceHash"]
    new_text = file.read_text().replace(old_version, tag).replace(old_hash, source_hash)
    file.write_text(new_text)


def sort_dict(d):
    return {k: d[k] for k in sorted(d)}


def get_url_from_piopm(piopm_data):
    if "uri" in piopm_data["spec"] and piopm_data["spec"]["uri"]:
        return piopm_data["spec"]["uri"]
    name = piopm_data["name"]
    version = piopm_data["version"]
    type_ = piopm_data["type"]
    owner = piopm_data["spec"]["owner"]
    # TODO: compute for more systems
    system = "linux_x86_64"
    req = urllib.request.urlopen(
        f"https://api.registry.platformio.org/v3/packages/{owner}/{type_}/"
        f"{name}"
    )
    data = json.loads(req.read())
    release = next(filter(lambda v: v["name"] == version, data["versions"]))
    files_for_system =\
        list(filter(lambda f: (
            system in f["system"]
            if isinstance(f["system"], list)
            else f["system"] == system
        ), release["files"]))
    if files_for_system:
        file = files_for_system[0]
    else:
        file = next(filter(lambda f: f["system"] == "*", release["files"]))
    return file["download_url"]


def get_hash(url):
    sha256 = (
        run(["nix-prefetch-url", url, "--unpack"], capture_output=True)
        .stdout.decode()
        .strip()
    )
    return f"sha256:{sha256}"


def get_flavors():
    # providing an invalid environment returns the list of all environments
    error = (
        run(
            ["platformio", "run", "--environment", "foo"],
            capture_output=True,
            check=False,
        )
        .stderr.decode()
        .strip()
    )
    names = error.partition("Valid names are '")[2][:-1]
    flavors = names.split(", ")
    return sorted(flavors)


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--source",
        type=str,
        help="path to the source directory to copy from instead of fetching",
    )
    parser.add_argument(
        "--temp-dir",
        type=str,
        help=\
            "override temporary working directory. Useful for debugging",
    )
    args = parser.parse_args()
    return args


args = parse_args()

with tempfile.TemporaryDirectory() as tmpdir:
    if args.temp_dir:
        tmpdir = Path(args.temp_dir)
        tmpdir.mkdir(exist_ok=True)
    nix_attrs = package_attrs("tasmota")
    package_dir = Path(nix_attrs["dir"])
    temp = Path(tmpdir)
    platformio_dir = temp / ".platformio"
    os.environ["PLATFORMIO_CORE_DIR"] = str(platformio_dir)
    # get latest tag
    tag = latest_tag()
    # fetch or copy the source
    if args.source:
        run(["cp", "-r", args.source, temp / "src"])
    else:
        fetch_source(temp / "src", tag)
    os.chdir(temp / "src")
    run(["chmod", "-R", "+w", temp])
    # write flavors.json
    with open(package_dir / "flavors.json", "w") as f:
        json.dump(get_flavors(), f, indent=2)
        f.write("\n")
    # install packages to later extract .piopm files from
    # only install for espressif32, and hope that the deps for expressif8266 are the same
    # (they aren,'t, which is why we need to override the esptool version later)
    # run(["platformio", "pkg", "install", "--platform", "espressif32"])
    # Not sure exactly what is fetched without passing any arguments, but it seems to work
    run(["platformio", "pkg", "install"])
    packages, platforms = {}, {}
    for platform in platformio_dir.glob("platforms/*"):
        with open(platform / ".piopm", "r") as f:
            platforms[platform.name] = json.load(f)
    for package in platformio_dir.glob("packages/*"):
        with open(package / ".piopm", "r") as f:
            packages[package.name] = json.load(f)
    # gather all urls and hashes from packages
    if not (package_dir / "hashes.json").exists():
        hashes_prev = dict(packages={}, platforms={})
    else:
        with open(package_dir / "hashes.json", "r") as f:
            hashes_prev = json.load(f)
    # update the hashes.json file with the metadata gathered from the .piopm files
    # keep the old hashes, wherever the URL did not change to avoid unnecessary re-hashing
    hashes = dict(packages={}, platforms={})
    for name, package in packages.items():
        url = get_url_from_piopm(package)
        if name in hashes_prev["packages"] and hashes_prev["packages"][name]["url"] == url:
            hashes["packages"][name] = hashes_prev["packages"][name]
            continue
        url = get_url_from_piopm(package)
        if url:
            hashes["packages"][name] = dict(
                hash=get_hash(url),
                url=url,
            )
            hashes["packages"] = sort_dict(hashes["packages"])
    for name, platform in platforms.items():
        url = get_url_from_piopm(platform)
        if name in hashes_prev["platforms"] and hashes_prev["platforms"][name]["url"] == url:
            hashes["platforms"][name] = hashes_prev["platforms"][name]
            continue
        url = get_url_from_piopm(platform)
        if url:
            hashes["platforms"][name] = dict(
                hash=get_hash(url),
                url=url,
            )
            hashes["platforms"] = sort_dict(hashes["platforms"])
    with open(package_dir / "hashes.json", "w") as f:
        json.dump(hashes, f, indent=2)
        f.write("\n")
    # copy .piopm files to package dir
    # these need to be kept for the nix build to work
    # Potentially this could be generated in the future, but there is additional
    # metadata in the .piopm files that I don't know how to get.
    shutil.rmtree(package_dir / ".platformio" / "packages")
    for package in platformio_dir.glob("packages/*"):
        target = (
            package_dir / ".platformio" / "packages" / package.name / ".piopm"
        )
        target.parent.mkdir(parents=True, exist_ok=True)
        with open(package / ".piopm", "r") as f, open(target, "w") as t:
            json.dump(json.load(f), t, indent=2)
            t.write("\n")
    for platform in platformio_dir.glob("platforms/*"):
        target = (
            package_dir
            / ".platformio"
            / "platforms"
            / platform.name
            / ".piopm"
        )
        target.parent.mkdir(parents=True, exist_ok=True)
        with open(platform / ".piopm", "r") as f, open(target, "w") as t:
            json.dump(json.load(f), t, indent=2)
            t.write("\n")
    # update nix expression
    source_hash = source_info(tag)["hash"]
    new_version = tag.removeprefix("v")
    print(f"updating nix code")
    patch_nix_file(new_version, source_hash, nix_attrs)
