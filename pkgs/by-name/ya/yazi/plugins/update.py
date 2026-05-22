#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.requests python3Packages.packaging python3Packages.nixpkgs-plugin-update nix curl git argparse

import argparse
import base64
import json
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path

import requests
from nixpkgs_plugin_update import make_unstable_version, normalize_release_version
from packaging import version
from packaging.version import InvalidVersion


@dataclass
class UpdateCandidate:
    """An upstream revision that might be used to update a plugin."""

    rev: str
    commit: str | None
    date: str
    version: str
    kind: str


def run_command(cmd: str, capture_output: bool = True) -> str:
    """Run a shell command and return its output"""
    result = subprocess.run(cmd, shell=True, text=True, capture_output=capture_output)
    if result.returncode != 0:
        if capture_output:
            error_msg = f"Error running command: {cmd}\nstderr: {result.stderr}"
            raise RuntimeError(error_msg)
        else:
            raise RuntimeError(f"Command failed: {cmd}")
    return result.stdout.strip() if capture_output else ""


def get_plugin_info(nixpkgs_dir: str, plugin_name: str) -> dict[str, str]:
    """Get plugin repository information from Nix"""
    owner = run_command(f"nix eval --raw -f {nixpkgs_dir} yaziPlugins.\"{plugin_name}\".src.owner")
    repo = run_command(f"nix eval --raw -f {nixpkgs_dir} yaziPlugins.\"{plugin_name}\".src.repo")

    return {
        "owner": owner,
        "repo": repo
    }


def get_yazi_version(nixpkgs_dir: str) -> str:
    """Get the current Yazi version from Nix"""
    return run_command(f"nix eval --raw -f {nixpkgs_dir} yazi-unwrapped.version")



def get_github_headers() -> dict[str, str]:
    """Create headers for GitHub API requests"""
    headers = {"Accept": "application/vnd.github.v3+json"}
    github_token = os.environ.get("GITHUB_TOKEN")
    if github_token:
        headers["Authorization"] = f"token {github_token}"
    return headers


def get_default_branch(owner: str, repo: str, headers: dict[str, str]) -> str:
    """Get the default branch name for a GitHub repository"""
    api_url = f"https://api.github.com/repos/{owner}/{repo}"

    try:
        response = requests.get(api_url, headers=headers)
        response.raise_for_status()
        repo_data = response.json()
        return repo_data["default_branch"]
    except requests.RequestException as e:
        print(f"Error fetching repository data: {e}")
        print("Falling back to 'main' as default branch")
        return "main"


def github_get(
    owner: str,
    repo: str,
    path: str,
    headers: dict[str, str],
    params: dict[str, str | int] | None = None,
    allow_404: bool = False,
) -> dict | list | None:
    """Fetch JSON from the GitHub API."""
    api_url = f"https://api.github.com/repos/{owner}/{repo}/{path}"

    try:
        response = requests.get(api_url, headers=headers, params=params)
        if allow_404 and response.status_code == 404:
            return None
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        raise RuntimeError(f"Error fetching {api_url}: {e}")


def fetch_plugin_content(
    owner: str,
    repo: str,
    plugin_pname: str,
    ref: str,
    headers: dict[str, str],
) -> str:
    """Fetch the plugin's main.lua content from GitHub"""
    plugin_path = f"{plugin_pname}/" if owner == "yazi-rs" else ""
    content_data = github_get(owner, repo, f"contents/{plugin_path}main.lua", headers, {"ref": ref})
    if not isinstance(content_data, dict) or "content" not in content_data:
        raise RuntimeError(f"Could not fetch main.lua at {ref}")

    return base64.b64decode(content_data["content"]).decode("utf-8")


def check_version_compatibility(plugin_content: str, plugin_name: str, yazi_version: str) -> str:
    """Check if the plugin is compatible with the current Yazi version"""
    required_version_match = re.search(r"since ([0-9.]+)", plugin_content.split("\n")[0])
    required_version = required_version_match.group(1) if required_version_match else "0"

    if required_version == "0":
        print(f"No version requirement found for {plugin_name}, assuming compatible with any Yazi version")
    else:
        if version.parse(required_version) > version.parse(yazi_version):
            message = f"{plugin_name} plugin requires Yazi {required_version}, but we have {yazi_version}"
            print(message)
            raise RuntimeError(message)

    return required_version


def candidate_sort_key(candidate: UpdateCandidate) -> tuple[int, version.Version | str]:
    """Sort candidates by parsed version when possible, then by text."""
    try:
        return (1, version.parse(candidate.version))
    except InvalidVersion:
        return (0, candidate.version)


def normalize_candidate(tag: str | None, kind: str) -> UpdateCandidate | None:
    """Create an unresolved release/tag candidate from a GitHub tag."""
    candidate_version = normalize_release_version(tag) if tag else None
    if candidate_version is None:
        return None

    return UpdateCandidate(
        rev=tag,
        commit=None,
        date="unknown",
        version=candidate_version,
        kind=kind,
    )


def resolve_candidate(owner: str, repo: str, candidate: UpdateCandidate, headers: dict[str, str]) -> UpdateCandidate:
    """Resolve a release/tag candidate to the commit it points at."""
    if candidate.commit is not None:
        return candidate

    commit_data = github_get(owner, repo, f"commits/{candidate.rev}", headers)
    if not isinstance(commit_data, dict):
        raise RuntimeError(f"Could not resolve {candidate.rev}")

    return UpdateCandidate(
        rev=candidate.rev,
        commit=commit_data["sha"],
        date=commit_data["commit"]["committer"]["date"].split("T")[0],
        version=candidate.version,
        kind=candidate.kind,
    )


def get_commit_candidates(owner: str, repo: str, plugin_pname: str, headers: dict[str, str]) -> list[UpdateCandidate]:
    """Get recent default branch commit candidates for a plugin."""
    default_branch = get_default_branch(owner, repo, headers)

    if owner == "yazi-rs":
        commits_data = github_get(
            owner,
            repo,
            "commits",
            headers,
            {"path": f"{plugin_pname}/main.lua", "per_page": 100},
        )
        if not isinstance(commits_data, list) or not commits_data:
            raise RuntimeError(f"Could not get recent commits for {plugin_pname}")
    else:
        commits_data = github_get(
            owner,
            repo,
            "commits",
            headers,
            {"sha": default_branch, "per_page": 100},
        )
        if not isinstance(commits_data, list) or not commits_data:
            raise RuntimeError(f"Could not get recent commits for {owner}/{repo}")

    candidates = []
    for commit_data in commits_data:
        commit = commit_data["sha"]
        commit_date = commit_data["commit"]["committer"]["date"].split("T")[0]
        commit_datetime = datetime.strptime(commit_date, "%Y-%m-%d")

        candidates.append(
            UpdateCandidate(
                rev=commit,
                commit=commit,
                date=commit_date,
                version=make_unstable_version(commit_datetime, None),
                kind="commit",
            )
        )

    return candidates


def get_release_candidates(owner: str, repo: str, headers: dict[str, str]) -> list[UpdateCandidate]:
    """Get non-prerelease GitHub release candidates without resolving tags."""
    releases = github_get(owner, repo, "releases", headers, {"per_page": 100})
    if not isinstance(releases, list):
        return []

    candidates = []
    for release in releases:
        if release.get("draft") or release.get("prerelease"):
            continue

        candidate = normalize_candidate(release.get("tag_name"), "release")
        if candidate is not None:
            candidates.append(candidate)

    candidates.sort(key=candidate_sort_key, reverse=True)
    return candidates


def get_tag_candidates(owner: str, repo: str, headers: dict[str, str]) -> list[UpdateCandidate]:
    """Get GitHub tag candidates without resolving tags."""
    tags = github_get(owner, repo, "tags", headers, {"per_page": 100})
    if not isinstance(tags, list):
        return []

    candidates = []
    for tag in tags:
        candidate = normalize_candidate(tag.get("name"), "tag")
        if candidate is not None:
            candidates.append(candidate)

    candidates.sort(key=candidate_sort_key, reverse=True)
    return candidates


def get_update_candidates(owner: str, repo: str, plugin_pname: str, headers: dict[str, str]) -> list[UpdateCandidate]:
    """Get update candidates, preferring releases, then tags, then commits."""
    release_candidates = get_release_candidates(owner, repo, headers)
    if release_candidates:
        return release_candidates

    tag_candidates = get_tag_candidates(owner, repo, headers)
    if tag_candidates:
        return tag_candidates

    return get_commit_candidates(owner, repo, plugin_pname, headers)


def compare_to_current(
    owner: str,
    repo: str,
    old_commit: str,
    candidate: UpdateCandidate,
    headers: dict[str, str],
) -> str:
    """Compare a candidate to the packaged commit."""
    if old_commit == "unknown":
        print("Current commit is unknown, skipping to avoid a possible regression")
        return "unknown"

    if candidate.commit is None:
        raise RuntimeError(f"Candidate {candidate.rev} is unresolved")

    if old_commit == candidate.commit or old_commit == candidate.rev:
        return "identical"

    compare_data = github_get(owner, repo, f"compare/{old_commit}...{candidate.commit}", headers, allow_404=True)
    if not isinstance(compare_data, dict):
        print(f"Could not compare {old_commit}...{candidate.commit}, skipping to avoid a possible regression")
        return "unknown"

    return str(compare_data.get("status"))


def is_yazi_compatible(
    owner: str,
    repo: str,
    plugin_name: str,
    plugin_pname: str,
    candidate: UpdateCandidate,
    yazi_version: str,
    headers: dict[str, str],
) -> bool:
    """Check if a candidate supports nixpkgs' Yazi version."""
    try:
        plugin_content = fetch_plugin_content(owner, repo, plugin_pname, candidate.rev, headers)
        check_version_compatibility(plugin_content, plugin_name, yazi_version)
        return True
    except RuntimeError as e:
        print(f"Skipping {candidate.rev}: {e}")
        return False


def select_compatible_candidate(
    owner: str,
    repo: str,
    plugin_name: str,
    plugin_pname: str,
    old_ref_attr: str,
    old_ref: str,
    old_commit: str,
    old_version: str,
    yazi_version: str,
    headers: dict[str, str],
) -> UpdateCandidate | None:
    """Select the newest compatible candidate that moves the package forward."""
    candidates = get_update_candidates(owner, repo, plugin_pname, headers)

    for unresolved_candidate in candidates:
        try:
            candidate = resolve_candidate(owner, repo, unresolved_candidate, headers)
        except RuntimeError as e:
            print(f"Skipping {unresolved_candidate.rev}: {e}")
            if unresolved_candidate.kind in ("release", "tag"):
                break
            continue

        print(f"Checking {plugin_name} {candidate.kind} {candidate.rev} ({candidate.date})")

        compare_status = compare_to_current(owner, repo, old_commit, candidate, headers)
        if compare_status == "identical":
            candidate_ref_attr = "rev" if candidate.kind == "commit" else "tag"
            source_ref_changed = old_ref_attr != candidate_ref_attr or old_ref != candidate.rev
            if old_version != candidate.version or source_ref_changed:
                if not is_yazi_compatible(owner, repo, plugin_name, plugin_pname, candidate, yazi_version, headers):
                    break

                return candidate

            print(f"{plugin_name} is already at {candidate.rev}; older candidates will not be used")
            break

        if compare_status != "ahead":
            print(f"Skipping {candidate.rev}: compare status is {compare_status}, not ahead")
            if candidate.kind in ("release", "tag"):
                print(f"{candidate.rev} is not newer than the packaged revision; older {candidate.kind}s will not be used")
                break
            continue

        if not is_yazi_compatible(owner, repo, plugin_name, plugin_pname, candidate, yazi_version, headers):
            continue

        return candidate

    return None


def calculate_sri_hash(owner: str, repo: str, rev: str) -> str:
    """Calculate the SRI hash for the plugin source"""
    prefetch_url = f"https://github.com/{owner}/{repo}/archive/{rev}.tar.gz"

    try:
        new_hash = run_command(f"nix-prefetch-url --unpack --type sha256 {prefetch_url} 2>/dev/null")

        if not new_hash.startswith("sha256-"):
            new_hash = run_command(f"nix --extra-experimental-features nix-command hash to-sri --type sha256 {new_hash} 2>/dev/null")

            if not new_hash.startswith("sha256-"):
                print("Warning: Failed to get SRI hash directly, trying alternative method...")
                raw_hash = run_command(f"nix-prefetch-url --type sha256 {prefetch_url} 2>/dev/null")
                new_hash = run_command(f"nix --extra-experimental-features nix-command hash to-sri --type sha256 {raw_hash} 2>/dev/null")
    except Exception as e:
        raise RuntimeError(f"Error calculating hash: {e}")

    if not new_hash.startswith("sha256-"):
        raise RuntimeError(f"Failed to generate valid SRI hash. Output was: {new_hash}")

    return new_hash


def read_nix_file(file_path: str) -> str:
    """Read the content of a Nix file"""
    try:
        with open(file_path, 'r') as f:
            return f.read()
    except IOError as e:
        raise RuntimeError(f"Error reading file {file_path}: {e}")


def write_nix_file(file_path: str, content: str) -> None:
    """Write content to a Nix file"""
    try:
        with open(file_path, 'w') as f:
            f.write(content)
    except IOError as e:
        raise RuntimeError(f"Error writing to file {file_path}: {e}")


def get_source_ref(nix_content: str) -> tuple[str, str]:
    """Get the source ref attribute from a Nix file."""
    source_ref_match = re.search(r'\b(rev|tag) = "([^"]*)"', nix_content)
    if source_ref_match is None:
        raise RuntimeError("Could not find rev or tag attribute")

    return source_ref_match.group(1), source_ref_match.group(2)


def resolve_ref_commit(owner: str, repo: str, ref: str, headers: dict[str, str]) -> str:
    """Resolve a GitHub ref to its commit."""
    commit_data = github_get(owner, repo, f"commits/{ref}", headers)
    if not isinstance(commit_data, dict):
        raise RuntimeError(f"Could not resolve {ref}")

    return commit_data["sha"]


def update_nix_file(default_nix_path: str, candidate: UpdateCandidate, new_hash: str) -> None:
    """Update the default.nix file with new version, revision and hash"""
    default_nix_content = read_nix_file(default_nix_path)

    source_ref_attr = "rev" if candidate.kind == "commit" else "tag"
    default_nix_content = re.sub(
        r'\b(rev|tag) = "[^"]*"',
        f'{source_ref_attr} = "{candidate.rev}"',
        default_nix_content,
    )

    if 'version = "' in default_nix_content:
        default_nix_content = re.sub(r'version = "[^"]*"', f'version = "{candidate.version}"', default_nix_content)
    else:
        default_nix_content = re.sub(r'(pname = "[^"]*";)', f'\\1\n  version = "{candidate.version}";', default_nix_content)

    if 'hash = "' in default_nix_content:
        default_nix_content = re.sub(r'hash = "[^"]*"', f'hash = "{new_hash}"', default_nix_content)
    elif 'fetchFromGitHub' in default_nix_content:
        default_nix_content = re.sub(r'sha256 = "[^"]*"', f'sha256 = "{new_hash}"', default_nix_content)
    else:
        raise RuntimeError(f"Could not find hash attribute in {default_nix_path}")

    write_nix_file(default_nix_path, default_nix_content)

    updated_content = read_nix_file(default_nix_path)
    if f'hash = "{new_hash}"' in updated_content or f'sha256 = "{new_hash}"' in updated_content:
        print(f"Successfully updated hash to: {new_hash}")
    else:
        raise RuntimeError(f"Failed to update hash in {default_nix_path}")


def get_all_plugins(nixpkgs_dir: str) -> list[dict[str, str]]:
    """Get all available Yazi plugins from the Nix expression"""
    try:
        plugin_names_json = run_command(f'nix eval --impure --json --expr "builtins.attrNames (import {nixpkgs_dir} {{}}).yaziPlugins"')
        plugin_names = json.loads(plugin_names_json)

        excluded_attrs = ["mkYaziPlugin", "override", "overrideDerivation", "overrideAttrs", "recurseForDerivations"]
        plugin_names = [name for name in plugin_names if name not in excluded_attrs]
        plugin_names = [
            name
            for name in plugin_names
            if Path(nixpkgs_dir, "pkgs/by-name/ya/yazi/plugins", name, "default.nix").exists()
        ]

        plugins = []
        for name in plugin_names:
            try:
                pname = run_command(f'nix eval --raw -f {nixpkgs_dir} "yaziPlugins.{name}.pname"')
                plugins.append({
                    "name": name,  # Attribute name in yaziPlugins set
                    "pname": pname  # Package name (used in repo paths)
                })
            except Exception as e:
                print(f"Warning: Could not get pname for plugin {name}, skipping: {e}")
                continue

        return plugins
    except Exception as e:
        raise RuntimeError(f"Error getting plugin list: {e}")


def validate_environment(plugin_name: str | None = None, plugin_pname: str | None = None) -> tuple[str, str | None, str | None]:
    """Validate environment variables and paths"""
    nixpkgs_dir = os.getcwd()

    if plugin_name and not plugin_pname:
        raise RuntimeError(f"pname not provided for plugin {plugin_name}")

    if plugin_name:
        plugin_dir = f"{nixpkgs_dir}/pkgs/by-name/ya/yazi/plugins/{plugin_name}"
        if not Path(f"{plugin_dir}/default.nix").exists():
            raise RuntimeError(f"Could not find default.nix for plugin {plugin_name} at {plugin_dir}")

    return nixpkgs_dir, plugin_name, plugin_pname


def update_single_plugin(nixpkgs_dir: str, plugin_name: str, plugin_pname: str) -> dict[str, str] | None:
    """Update a single Yazi plugin

    Returns:
        dict with update info including old_version, new_version, etc. or None if no change
    """
    plugin_dir = f"{nixpkgs_dir}/pkgs/by-name/ya/yazi/plugins/{plugin_name}"
    default_nix_path = f"{plugin_dir}/default.nix"

    nix_content = read_nix_file(default_nix_path)
    old_version_match = re.search(r'version = "([^"]*)"', nix_content)
    old_version = old_version_match.group(1) if old_version_match else "unknown"
    old_ref_attr, old_ref = get_source_ref(nix_content)

    plugin_info = get_plugin_info(nixpkgs_dir, plugin_name)
    owner = plugin_info["owner"]
    repo = plugin_info["repo"]

    yazi_version = get_yazi_version(nixpkgs_dir)

    headers = get_github_headers()
    try:
        old_commit = old_ref if old_ref_attr == "rev" else resolve_ref_commit(owner, repo, old_ref, headers)
    except RuntimeError as e:
        print(f"Could not resolve current {old_ref_attr} {old_ref}: {e}")
        old_commit = "unknown"

    candidate = select_compatible_candidate(
        owner,
        repo,
        plugin_name,
        plugin_pname,
        old_ref_attr,
        old_ref,
        old_commit,
        old_version,
        yazi_version,
        headers,
    )
    if candidate is None:
        print(f"No forward compatible update found for {plugin_name}")
        return None

    print(f"Updating {plugin_name} from {old_commit} to {candidate.rev}")

    new_hash = calculate_sri_hash(owner, repo, candidate.rev)
    print(f"Generated SRI hash: {new_hash}")

    update_nix_file(default_nix_path, candidate, new_hash)

    print(f"Successfully updated {plugin_name} from {old_version} to {candidate.version}")

    return {
        "name": plugin_name,
        "old_version": old_version,
        "new_version": candidate.version,
        "old_commit": old_commit,
        "new_commit": candidate.commit,
        "owner": owner,
        "repo": repo,
    }


def update_all_plugins(nixpkgs_dir: str) -> list[dict[str, str]]:
    """Update all available Yazi plugins

    Returns:
        list[dict[str, str]]: List of successfully updated plugin info dicts
    """
    plugins = get_all_plugins(nixpkgs_dir)
    updated_plugins = []

    if not plugins:
        print("No plugins found to update")
        return updated_plugins

    print(f"Found {len(plugins)} plugins to update")

    checked_count = 0
    updated_count = 0
    failed_plugins = []

    for plugin in plugins:
        plugin_name = plugin["name"]
        plugin_pname = plugin["pname"]

        try:
            print(f"\n{'=' * 50}")
            print(f"Checking plugin: {plugin_name}")
            print(f"{'=' * 50}")

            try:
                update_info = update_single_plugin(nixpkgs_dir, plugin_name, plugin_pname)
                checked_count += 1

                if update_info:
                    updated_count += 1
                    updated_plugins.append(update_info)
            except KeyboardInterrupt:
                print("\nUpdate process interrupted by user")
                sys.exit(1)
            except Exception as e:
                print(f"Error updating plugin {plugin_name}: {e}")
                failed_plugins.append({"name": plugin_name, "error": str(e)})
                continue
        except Exception as e:
            print(f"Unexpected error with plugin {plugin_name}: {e}")
            failed_plugins.append({"name": plugin_name, "error": str(e)})
            continue

    print(f"\n{'=' * 50}")
    print(f"Update summary: {updated_count} plugins updated out of {checked_count} checked")

    if updated_count > 0:
        print("\nUpdated plugins:")
        for plugin in updated_plugins:
            print(f"  - {plugin['name']}: {plugin['old_version']} → {plugin['new_version']}")

    if failed_plugins:
        print(f"\nFailed to update {len(failed_plugins)} plugins:")
        for plugin in failed_plugins:
            print(f"  - {plugin['name']}: {plugin['error']}")

    return updated_plugins


def commit_changes(updated_plugins: list[dict[str, str]]) -> None:
    """Commit all changes after updating plugins"""
    if not updated_plugins:
        print("No plugins were updated, skipping commit")
        return

    try:
        status_output = run_command("git status --porcelain", capture_output=True)
        if not status_output:
            print("No changes to commit")
            return

        current_date = run_command("date +%Y-%m-%d", capture_output=True)

        def get_compare_url(plugin: dict[str, str]) -> str | None:
            if plugin["old_commit"] != "unknown":
                owner = plugin['owner'].strip()
                repo = plugin['repo'].strip()
                return f"https://github.com/{owner}/{repo}/compare/{plugin['old_commit']}...{plugin['new_commit']}"
            return None

        if len(updated_plugins) == 1:
            plugin = updated_plugins[0]
            commit_message = f"yaziPlugins.{plugin['name']}: {plugin['old_version']} -> {plugin['new_version']}"
            compare_url = get_compare_url(plugin)
            if compare_url:
                commit_message += f"\n\nCompare: {compare_url}"
        else:
            commit_message = f"yaziPlugins: update on {current_date}\n\n"
            for plugin in sorted(updated_plugins, key=lambda x: x['name']):
                commit_message += f"- {plugin['name']}: {plugin['old_version']} → {plugin['new_version']}\n"
                compare_url = get_compare_url(plugin)
                if compare_url:
                    commit_message += f"  Compare: {compare_url}\n"

        run_command("git add pkgs/by-name/ya/yazi/plugins/", capture_output=False)

        subprocess.run(["git", "commit", "--no-verify", "-m", commit_message], check=True)
        print(f"\nCommitted changes with message:\n{commit_message}")
    except Exception as e:
        print(f"Error committing changes: {e}")


def main():
    """Main function to update Yazi plugins"""

    parser = argparse.ArgumentParser(description="Update Yazi plugins")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--all", action="store_true", help="Update all Yazi plugins")
    group.add_argument("--plugin", type=str, help="Update a specific plugin by name")
    parser.add_argument("--commit", action="store_true", help="Commit changes after updating")
    args = parser.parse_args()

    nixpkgs_dir = os.getcwd()
    updated_plugins = []

    if args.all:
        print("Updating all Yazi plugins...")
        updated_plugins = update_all_plugins(nixpkgs_dir)

    elif args.plugin:
        plugin_name = args.plugin
        try:
            plugin_pname = run_command(f'nix eval --raw -f {nixpkgs_dir} "yaziPlugins.{plugin_name}.pname"')
            print(f"Updating Yazi plugin: {plugin_name}")
            update_info = update_single_plugin(nixpkgs_dir, plugin_name, plugin_pname)
            if update_info:
                updated_plugins.append(update_info)
        except Exception as e:
            print(f"Error: {e}")
            sys.exit(1)
    else:
        nixpkgs_dir, plugin_name, plugin_pname = validate_environment()

        if plugin_name and plugin_pname:
            print(f"Updating Yazi plugin: {plugin_name}")
            update_info = update_single_plugin(nixpkgs_dir, plugin_name, plugin_pname)
            if update_info:
                updated_plugins.append(update_info)
        else:
            parser.print_help()
            sys.exit(0)

    if args.commit and updated_plugins:
        commit_changes(updated_plugins)


if __name__ == "__main__":
    main()
