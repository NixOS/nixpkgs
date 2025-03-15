#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p nix python3 nodePackages.semver vsce nix-update gitMinimal

import argparse
import json
import os
import subprocess
import sys


class VSCodeExtensionUpdater:
    """
    A class to manage updating VSCode extension versions in a Nix environment.
    """

    def __init__(self):
        self.parser = argparse.ArgumentParser(
            description="Update VSCode extension version in Nix."
        )
        self.parser.add_argument(
            "attribute",
            default=os.getenv("UPDATE_NIX_ATTR_PATH"),
            help="Nix attribute path of the extension",
        )
        self.parser.add_argument(
            "--override-filename", help="Override-filename for nix-update"
        )
        self.parser.add_argument(
            "--pre-release",
            action="store_true",
            help="Allow updating to PreRelease version",
        )
        self.parser.add_argument(
            "--platforms",
            action="store_true",
            help="Set systems according to meta.platforms",
        )
        self.args = self.parser.parse_args()
        self.attribute_path = self.args.attribute
        self.target_vscode_version = self._get_nix_vscode_version()
        self.current_version = (
            os.getenv("UPDATE_NIX_OLD_VERSION")
            or self._get_nix_vscode_extension_version()
        )
        self.override_filename = self.args.override_filename
        self.allow_pre_release = self.args.pre_release
        self.extension_publisher = self._get_nix_vscode_extension_publisher()
        self.extension_name = self._get_nix_vscode_extension_name()
        self.extension_marketplace_id = (
            f"{self.extension_publisher}.{self.extension_name}"
        )
        if not self.attribute_path:
            print("Error: Attribute path is required.", file=sys.stderr)
            sys.exit(1)
        self.systems = []
        if self.args.platforms:
            self.systems = self._get_nix_vscode_extension_platforms()
        else:
            self.systems = [self.get_nix_system()]
        print(f"VSCode version: {self.target_vscode_version}")
        print(f"Extension Marketplace ID: {self.extension_marketplace_id}")
        print(f"Extension Current Version: {self.current_version}")

    def execute_command(self, command: str) -> str:
        """
        Executes a shell command and returns its output.
        Raises an error if the command fails.
        """
        return subprocess.run(
            command,
            shell=True,
            check=True,
            capture_output=True,
            text=True,
        ).stdout.strip()

    def _get_nix_attribute(self, attribute_path: str) -> str:
        """
        Retrieves a raw Nix attribute value.
        """
        return self.execute_command(f"nix eval --raw -f . {attribute_path}")

    def get_nix_system(self) -> str:
        """
        Retrieves system from Nix.
        """
        return self._get_nix_attribute("system")

    def get_target_platform(self, nix_system: str) -> str:
        """
        Retrieves the VS Code targetPlatform variable based on the Nix system.
        """
        platform_mapping = {
            "x86_64-linux": "linux-x64",
            "aarch64-linux": "linux-arm64",
            "armv7l-linux": "linux-armhf",
            "x86_64-darwin": "darwin-x64",
            "aarch64-darwin": "darwin-arm64",
            "x86_64-windows": "win32-x64",
            "aarch64-windows": "win32-arm64",
        }
        target_platform = platform_mapping.get(nix_system)
        if not target_platform:
            print(
                f"Warning: Unknown Nix system '{nix_system}'. Cannot determine targetPlatform.",
                file=sys.stderr,
            )
            sys.exit(1)
        return target_platform

    def _get_nix_vscode_version(self) -> str:
        """
        Retrieves the current VSCode version from Nix.
        """
        return self._get_nix_attribute("vscode.version")

    def _get_nix_vscode_extension_version(self) -> str:
        """
        Retrieves the extension current version from Nix.
        """
        return self._get_nix_attribute(f"{self.attribute_path}.version")

    def _get_nix_vscode_extension_platforms(self) -> str:
        """
        Retrieves the extension meta.platforms from Nix.
        """
        return json.loads(
            self.execute_command(
                f"nix eval --json -f . {self.attribute_path}.meta.platforms"
            )
        )

    def _get_nix_vscode_extension_publisher(self) -> str:
        """
        Retrieves the extension publisher from Nix.
        """
        return self._get_nix_attribute(f"{self.attribute_path}.vscodeExtPublisher")

    def _get_nix_vscode_extension_name(self) -> str:
        """
        Retrieves the extension name from Nix.
        """
        return self._get_nix_attribute(f"{self.attribute_path}.vscodeExtName")

    def get_marketplace_extension_data(self, extension_id: str) -> dict:
        """
        Retrieves extension data from the VSCode Marketplace using vsce.
        """
        try:
            extension_data_json = self.execute_command(
                f"vsce show {extension_id} --json"
            )
            return json.loads(extension_data_json)
        except json.JSONDecodeError:
            print(
                f"Error: Extension '{extension_id}' not found in the VSCode Marketplace.",
                file=sys.stderr,
            )
            sys.exit(1)

    def find_compatible_extension_version(
        self, extension_versions: list, target_platform: str
    ) -> str:
        """
        Finds the first compatible extension version based on Target Platform and VSCode compatibility.
        """
        for version_info in extension_versions:
            candidate_platform = version_info.get("targetPlatform", "")
            if (
                target_platform
                and candidate_platform
                and candidate_platform != target_platform
            ):
                continue
            candidate_version = version_info.get("version")
            candidate_pre_release = next(
                (
                    prop.get("value")
                    for prop in version_info.get("properties", [])
                    if prop.get("key") == "Microsoft.VisualStudio.Code.PreRelease"
                ),
                None,
            )
            if candidate_pre_release and not self.allow_pre_release:
                print(f"Skipping PreRelease version {candidate_version}")
                continue
            engine_version_constraint = next(
                (
                    prop.get("value")
                    for prop in version_info.get("properties", [])
                    if prop.get("key") == "Microsoft.VisualStudio.Code.Engine"
                ),
                None,
            )
            if engine_version_constraint:
                print(
                    f"Testing extension version: {candidate_version} with VSCode {self.target_vscode_version} (constraint: {engine_version_constraint})"
                )
                try:
                    self.execute_command(
                        f"semver {self.target_vscode_version} -r '{engine_version_constraint}'"
                    )
                    print(f"Compatible version found: {candidate_version}")
                    return candidate_version
                except (ValueError, subprocess.CalledProcessError):
                    print(
                        f"Version {candidate_version} is not compatible with VSCode {self.target_vscode_version} (constraint: {engine_version_constraint})."
                    )
                continue
            return candidate_version
        print(
            "Error: not found compatible version.",
            file=sys.stderr,
        )
        sys.exit(1)

    def run_nix_update(self, new_version: str, system: str) -> None:
        """
        Builds and executes the nix-update command.
        """
        if not self.override_filename:
            self.override_filename = self.execute_command(
                f'EDITOR=echo nix edit --extra-experimental-features nix-command -f . "{self.attribute_path}"'
            )
            if (
                "pkgs/applications/editors/vscode/extensions/vscode-utils.nix"
                in self.override_filename
            ):
                self.override_filename = (
                    "pkgs/applications/editors/vscode/extensions/default.nix"
                )
        update_command = f'nix-update "{self.attribute_path}" --version "{new_version}" --override-filename "{self.override_filename}" --system "{system}"'
        print(f"Running update command:\n  {update_command}")
        self.execute_command(update_command)

    def run(self):
        marketplace_data = self.get_marketplace_extension_data(
            self.extension_marketplace_id
        )
        available_versions = marketplace_data.get("versions", [])
        print(
            f"Total versions found for {self.extension_marketplace_id}: {len(available_versions)}"
        )
        new_version = self.find_compatible_extension_version(
            available_versions, self.get_target_platform(self.systems[0])
        )
        try:
            self.execute_command(f"semver {self.current_version} -r '<{new_version}'")
        except subprocess.CalledProcessError:
            print("Already up to date or new version is older!")
            sys.exit(0)
        print(f"Selected extension version from Marketplace: {new_version}")
        for i, system in enumerate(self.systems):
            version = new_version if i == 0 else "skip"
            self.run_nix_update(version, system)


if __name__ == "__main__":
    if not os.path.exists("nixos/release.nix"):
        print("Please run this script in the nixpkgs root directory.", file=sys.stderr)
        sys.exit(1)
    updater = VSCodeExtensionUpdater()
    updater.run()
