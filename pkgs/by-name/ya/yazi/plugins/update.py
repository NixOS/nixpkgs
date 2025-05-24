#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.requests python3Packages.packaging nix curl git

import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Dict, Tuple

import requests
from packaging import version


def run_command(cmd: str, capture_output: bool = True) -> str:
    """Run a shell command and return its output"""
    result = subprocess.run(cmd, shell=True, text=True, capture_output=capture_output)
    if result.returncode != 0:
        if capture_output:
            print(f"Error running command: {cmd}")
            print(f"stderr: {result.stderr}")
        sys.exit(1)
    return result.stdout.strip() if capture_output else ""


def get_plugin_info(nixpkgs_dir: str, plugin_name: str) -> Dict[str, str]:
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



def get_github_headers() -> Dict[str, str]:
    """Create headers for GitHub API requests"""
    headers = {"Accept": "application/vnd.github.v3+json"}
    github_token = os.environ.get("GITHUB_TOKEN")
    if github_token:
        headers["Authorization"] = f"token {github_token}"
    return headers


def get_default_branch(owner: str, repo: str, headers: Dict[str, str]) -> str:
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

def fetch_plugin_content(owner: str, repo: str, plugin_pname: str, headers: Dict[str, str]) -> str:
    """Fetch the plugin's main.lua content from GitHub"""
    default_branch = get_default_branch(owner, repo, headers)
    plugin_path = f"{plugin_pname}/" if owner == "yazi-rs" else ""
    main_lua_url = f"https://raw.githubusercontent.com/{owner}/{repo}/{default_branch}/{plugin_path}main.lua"

    try:
        response = requests.get(main_lua_url, headers=headers)
        response.raise_for_status()
        return response.text
    except requests.RequestException as e:
        print(f"Error fetching plugin content: {e}")
        sys.exit(1)


def check_version_compatibility(plugin_content: str, plugin_name: str, yazi_version: str) -> str:
    """Check if the plugin is compatible with the current Yazi version"""
    required_version_match = re.search(r"since ([0-9.]+)", plugin_content.split("\n")[0])
    required_version = required_version_match.group(1) if required_version_match else "0"

    if required_version == "0":
        print(f"No version requirement found for {plugin_name}, assuming compatible with any Yazi version")
    else:
        # Check if the plugin is compatible with current Yazi version
        if version.parse(required_version) > version.parse(yazi_version):
            print(f"{plugin_name} plugin requires Yazi {required_version}, but we have {yazi_version}")
            sys.exit(0)

    return required_version


def get_latest_commit(owner: str, repo: str, plugin_pname: str, headers: Dict[str, str]) -> Tuple[str, str]:
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
        print(f"Error fetching commit data: {e}")
        sys.exit(1)

    if owner == "yazi-rs":
        latest_commit = commit_data[0]["sha"]
        commit_date = commit_data[0]["commit"]["committer"]["date"].split("T")[0]
    else:
        latest_commit = commit_data["sha"]
        commit_date = commit_data["commit"]["committer"]["date"].split("T")[0]

    if not latest_commit:
        print("Error: Could not get latest commit hash")
        sys.exit(1)

    return latest_commit, commit_date


def calculate_sri_hash(owner: str, repo: str, latest_commit: str) -> str:
    """Calculate the SRI hash for the plugin source"""
    prefetch_url = f"https://github.com/{owner}/{repo}/archive/{latest_commit}.tar.gz"

    try:
        new_hash = run_command(f"nix-prefetch-url --unpack --type sha256 {prefetch_url} 2>/dev/null")

        # If the hash is not in SRI format, convert it
        if not new_hash.startswith("sha256-"):
            # Try to convert the hash to SRI format
            new_hash = run_command(f"nix hash to-sri --type sha256 {new_hash} 2>/dev/null")

            # If that fails, try another approach
            if not new_hash.startswith("sha256-"):
                print("Warning: Failed to get SRI hash directly, trying alternative method...")
                raw_hash = run_command(f"nix-prefetch-url --type sha256 {prefetch_url} 2>/dev/null")
                new_hash = run_command(f"nix hash to-sri --type sha256 {raw_hash} 2>/dev/null")
    except Exception as e:
        print(f"Error calculating hash: {e}")
        sys.exit(1)

    # Verify we got a valid SRI hash
    if not new_hash.startswith("sha256-"):
        print(f"Error: Failed to generate valid SRI hash. Output was: {new_hash}")
        sys.exit(1)

    return new_hash


def read_nix_file(file_path: str) -> str:
    """Read the content of a Nix file"""
    try:
        with open(file_path, 'r') as f:
            return f.read()
    except IOError as e:
        print(f"Error reading file {file_path}: {e}")
        sys.exit(1)


def write_nix_file(file_path: str, content: str) -> None:
    """Write content to a Nix file"""
    try:
        with open(file_path, 'w') as f:
            f.write(content)
    except IOError as e:
        print(f"Error writing to file {file_path}: {e}")
        sys.exit(1)


def update_nix_file(default_nix_path: str, latest_commit: str, new_version: str, new_hash: str) -> None:
    """Update the default.nix file with new version, revision and hash"""
    default_nix_content = read_nix_file(default_nix_path)

    # Update the revision in default.nix
    default_nix_content = re.sub(r'rev = "[^"]*"', f'rev = "{latest_commit}"', default_nix_content)

    # Update the version in default.nix
    if 'version = "' in default_nix_content:
        default_nix_content = re.sub(r'version = "[^"]*"', f'version = "{new_version}"', default_nix_content)
    else:
        # Add version attribute after pname if it doesn't exist
        default_nix_content = re.sub(r'(pname = "[^"]*";)', f'\\1\n  version = "{new_version}";', default_nix_content)

    # Update hash in default.nix
    if 'hash = "' in default_nix_content:
        default_nix_content = re.sub(r'hash = "[^"]*"', f'hash = "{new_hash}"', default_nix_content)
    elif 'fetchFromGitHub' in default_nix_content:
        default_nix_content = re.sub(r'sha256 = "[^"]*"', f'sha256 = "{new_hash}"', default_nix_content)
    else:
        print(f"Error: Could not find hash attribute in {default_nix_path}")
        sys.exit(1)

    # Write the updated content back to the file
    write_nix_file(default_nix_path, default_nix_content)

    # Verify the hash was updated
    updated_content = read_nix_file(default_nix_path)
    if f'hash = "{new_hash}"' in updated_content or f'sha256 = "{new_hash}"' in updated_content:
        print(f"Successfully updated hash to: {new_hash}")
    else:
        print(f"Error: Failed to update hash in {default_nix_path}")
        sys.exit(1)


def validate_environment() -> Tuple[str, str, str]:
    """Validate environment variables and paths"""
    nixpkgs_dir = os.getcwd()

    plugin_name = os.environ.get("PLUGIN_NAME")
    plugin_pname = os.environ.get("PLUGIN_PNAME")

    if not plugin_name or not plugin_pname:
        print("Error: PLUGIN_NAME and PLUGIN_PNAME environment variables must be set")
        sys.exit(1)

    plugin_dir = f"{nixpkgs_dir}/pkgs/by-name/ya/yazi/plugins/{plugin_name}"
    if not Path(f"{plugin_dir}/default.nix").exists():
        print(f"Error: Could not find default.nix for plugin {plugin_name} at {plugin_dir}")
        sys.exit(1)

    return nixpkgs_dir, plugin_name, plugin_pname


def main():
    """Main function to update a Yazi plugin"""
    # Basic setup and validation
    nixpkgs_dir, plugin_name, plugin_pname = validate_environment()
    plugin_dir = f"{nixpkgs_dir}/pkgs/by-name/ya/yazi/plugins/{plugin_name}"
    default_nix_path = f"{plugin_dir}/default.nix"

    # Get repository info
    plugin_info = get_plugin_info(nixpkgs_dir, plugin_name)
    owner = plugin_info["owner"]
    repo = plugin_info["repo"]

    # Get Yazi version separately
    yazi_version = get_yazi_version(nixpkgs_dir)

    # Setup GitHub API headers
    headers = get_github_headers()

    # Check plugin compatibility with current Yazi version
    plugin_content = fetch_plugin_content(owner, repo, plugin_pname, headers)
    required_version = check_version_compatibility(plugin_content, plugin_name, yazi_version)

    # Get latest commit info
    latest_commit, commit_date = get_latest_commit(owner, repo, plugin_pname, headers)
    print(f"Updating {plugin_name} to commit {latest_commit} ({commit_date})")

    # Generate new version string
    new_version = f"{required_version}-unstable-{commit_date}"

    # Calculate hash for the plugin
    new_hash = calculate_sri_hash(owner, repo, latest_commit)
    print(f"Generated SRI hash: {new_hash}")

    # Update the default.nix file
    update_nix_file(default_nix_path, latest_commit, new_version, new_hash)

    print(f"Successfully updated {plugin_name} to version {new_version} (commit {latest_commit})")


if __name__ == "__main__":
    main()
