#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.requests python3Packages.packaging nix curl git argparse

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path

import requests
from packaging import version


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

def fetch_plugin_content(owner: str, repo: str, plugin_pname: str, headers: dict[str, str]) -> str:
    """Fetch the plugin's main.lua content from GitHub"""
    default_branch = get_default_branch(owner, repo, headers)
    plugin_path = f"{plugin_pname}/" if owner == "yazi-rs" else ""
    main_lua_url = f"https://raw.githubusercontent.com/{owner}/{repo}/{default_branch}/{plugin_path}main.lua"

    try:
        response = requests.get(main_lua_url, headers=headers)
        response.raise_for_status()
        return response.text
    except requests.RequestException as e:
        raise RuntimeError(f"Error fetching plugin content: {e}")


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


def get_latest_commit(owner: str, repo: str, plugin_pname: str, headers: dict[str, str]) -> tuple[str, str]:
    """Get the latest commit hash and date for the plugin"""
    default_branch = get_default_branch(owner, repo, headers)

    if owner == "yazi-rs":
        # For official plugins, get commit info for the specific plugin file
        api_url = f"https://api.github.com/repos/{owner}/{repo}/commits?path={plugin_pname}/main.lua&per_page=1"
    else:
        # For third-party plugins, get latest commit on default branch
        api_url = f"https://api.github.com/repos/{owner}/{repo}/commits/{default_branch}"

    try:
        response = requests.get(api_url, headers=headers)
        response.raise_for_status()
        commit_data = response.json()
    except requests.RequestException as e:
        raise RuntimeError(f"Error fetching commit data: {e}")

    if owner == "yazi-rs":
        latest_commit = commit_data[0]["sha"]
        commit_date = commit_data[0]["commit"]["committer"]["date"].split("T")[0]
    else:
        latest_commit = commit_data["sha"]
        commit_date = commit_data["commit"]["committer"]["date"].split("T")[0]

    if not latest_commit:
        raise RuntimeError("Could not get latest commit hash")

    return latest_commit, commit_date


def calculate_sri_hash(owner: str, repo: str, latest_commit: str) -> str:
    """Calculate the SRI hash for the plugin source"""
    prefetch_url = f"https://github.com/{owner}/{repo}/archive/{latest_commit}.tar.gz"

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


def update_nix_file(default_nix_path: str, latest_commit: str, new_version: str, new_hash: str) -> None:
    """Update the default.nix file with new version, revision and hash"""
    default_nix_content = read_nix_file(default_nix_path)

    default_nix_content = re.sub(r'rev = "[^"]*"', f'rev = "{latest_commit}"', default_nix_content)

    if 'version = "' in default_nix_content:
        default_nix_content = re.sub(r'version = "[^"]*"', f'version = "{new_version}"', default_nix_content)
    else:
        default_nix_content = re.sub(r'(pname = "[^"]*";)', f'\\1\n  version = "{new_version}";', default_nix_content)

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
    old_commit_match = re.search(r'rev = "([^"]*)"', nix_content)
    old_commit = old_commit_match.group(1) if old_commit_match else "unknown"

    plugin_info = get_plugin_info(nixpkgs_dir, plugin_name)
    owner = plugin_info["owner"]
    repo = plugin_info["repo"]

    yazi_version = get_yazi_version(nixpkgs_dir)

    headers = get_github_headers()

    plugin_content = fetch_plugin_content(owner, repo, plugin_pname, headers)
    required_version = check_version_compatibility(plugin_content, plugin_name, yazi_version)

    latest_commit, commit_date = get_latest_commit(owner, repo, plugin_pname, headers)
    print(f"Checking {plugin_name} latest commit {latest_commit} ({commit_date})")

    if latest_commit == old_commit:
        print(f"No changes for {plugin_name}, already at latest commit {latest_commit}")
        return None

    print(f"Updating {plugin_name} from commit {old_commit} to {latest_commit}")

    new_version = f"{required_version}-unstable-{commit_date}"

    new_hash = calculate_sri_hash(owner, repo, latest_commit)
    print(f"Generated SRI hash: {new_hash}")

    update_nix_file(default_nix_path, latest_commit, new_version, new_hash)

    print(f"Successfully updated {plugin_name} from {old_version} to {new_version}")

    return {
        "name": plugin_name,
        "old_version": old_version,
        "new_version": new_version,
        "old_commit": old_commit,
        "new_commit": latest_commit
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

        if len(updated_plugins) == 1:
            plugin = updated_plugins[0]
            commit_message = f"yaziPlugins.{plugin['name']}: update from {plugin['old_version']} to {plugin['new_version']}"
        else:
            commit_message = f"yaziPlugins: update on {current_date}\n\n"
            for plugin in sorted(updated_plugins, key=lambda x: x['name']):
                commit_message += f"- {plugin['name']}: {plugin['old_version']} → {plugin['new_version']}\n"

        run_command("git add pkgs/by-name/ya/yazi/plugins/", capture_output=False)

        run_command(f'git commit -m "{commit_message}"', capture_output=False)
        print(f"\nCommitted changes with message: {commit_message}")
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
