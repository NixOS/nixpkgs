#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p nix python3 python3Packages.loguru nodePackages.semver vsce nix-update gitMinimal coreutils common-updater-scripts

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Optional

from loguru import logger


class VSCodeExtensionUpdater:
    """
    A class to update VSCode extension version.
    """

    def __init__(self):
        self.parser = argparse.ArgumentParser(
            description="Update VSCode extension version."
        )
        self.parser.add_argument(
            "attribute",
            nargs="?",
            default=os.getenv("UPDATE_NIX_ATTR_PATH"),
            help="nix attribute path of the extension",
        )
        self.parser.add_argument(
            "--override-filename", help="override-filename for nix-update"
        )
        self.parser.add_argument(
            "--pre-release",
            action="store_true",
            help="allow check pre-release versions",
        )
        self.parser.add_argument(
            "--commit", action="store_true", help="commit the updated package"
        )
        self.args = self.parser.parse_args()
        self.attribute_path = self.args.attribute
        if not self.attribute_path:
            logger.error("Error: Attribute path is required.")
            sys.exit(1)
        self.target_vscode_version = self._get_nix_vscode_version()
        self.current_version = self._get_nix_vscode_extension_version()
        self.override_filename = self.args.override_filename
        self.allow_pre_release = self.args.pre_release
        self.commit = self.args.commit
        self.extension_publisher = self._get_nix_vscode_extension_publisher()
        self.extension_name = self._get_nix_vscode_extension_name()
        self.extension_marketplace_id = (
            f"{self.extension_publisher}.{self.extension_name}"
        )
        self.nix_system = self.get_nix_system()
        nix_vscode_extension_platforms = self._get_nix_vscode_extension_platforms()
        if not nix_vscode_extension_platforms and self._has_platform_source():
            logger.error("Error: not found meta.platforms.")
            sys.exit(1)
        self.nix_vscode_extension_platforms = nix_vscode_extension_platforms or [
            self.nix_system
        ]
        if self.nix_system in self.nix_vscode_extension_platforms:
            self.nix_vscode_extension_platforms.remove(self.nix_system)
            self.nix_vscode_extension_platforms.insert(0, self.nix_system)
        self.supported_nix_systems = self.get_supported_nix_systems()
        logger.info(f"VSCode version: {self.target_vscode_version}")
        logger.info(f"Extension Marketplace ID: {self.extension_marketplace_id}")
        logger.info(f"Extension Current Version: {self.current_version}")

    def execute_command(
        self, commandline: list[str], env: Optional[dict[str, str]] = None
    ) -> str:
        """
        Executes a shell command and returns its output.
        """
        logger.debug("Executing command: {}", commandline)
        return subprocess.run(
            commandline,
            check=True,
            capture_output=True,
            text=True,
            env=env,
        ).stdout.strip()

    def _get_nix_attribute(self, attribute_path: str) -> str:
        """
        Retrieves a raw Nix attribute value.
        """
        return self.execute_command([
            "nix",
            "--extra-experimental-features",
            "nix-command",
            "eval",
            "--raw",
            "-f",
            ".",
            attribute_path
        ])

    def get_nix_system(self) -> str:
        """
        Retrieves system from Nix.
        """
        return self._get_nix_attribute("stdenv.hostPlatform.system")

    def get_supported_nix_systems(self) -> list[str]:
        nix_config = self.execute_command([
            "nix",
            "--extra-experimental-features",
            "nix-command",
            "config",
            "show"
        ])
        system = None
        extra_platforms = []
        for line in nix_config.splitlines():
            if "=" not in line:
                continue
            key, value = line.split("=", 1)
            key = key.strip()
            value = value.strip()
            if key == "system":
                system = value
            elif key == "extra-platforms":
                extra_platforms = value.strip("[]").replace('"', "").split()
        return ([system] if system is not None else []) + extra_platforms

    def _has_platform_source(self) -> bool:
        source_url = self._get_nix_attribute(f"{self.attribute_path}.src.url")
        return "targetPlatform=" in source_url

    def _get_nix_vscode_extension_src_hash(self, system: str) -> str:
        url = self.execute_command([
            "nix",
            "--extra-experimental-features",
            "nix-command",
            "eval",
            "--raw",
            "-f",
            ".",
            f"{self.attribute_path}.src.url",
            "--system",
            system,
        ])
        sha256 = self.execute_command(["nix-prefetch-url", url])
        return self.execute_command([
            "nix",
            "--extra-experimental-features",
            "nix-command",
            "hash",
            "convert",
            "--to",
            "sri",
            "--hash-algo",
            "sha256",
            sha256,
        ])

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
        try:
            return platform_mapping[nix_system]
        except KeyError:
            logger.error(
                f"Error: Unknown Nix system '{nix_system}'. Cannot determine targetPlatform."
            )
            sys.exit(1)

    def _get_nix_vscode_version(self) -> str:
        """
        Retrieves the current VSCode version from Nix.
        """
        return self._get_nix_attribute("vscode.version")

    def _get_nix_vscode_extension_version(self) -> str:
        """
        Retrieves the extension current version from Nix.
        """
        return os.getenv("UPDATE_NIX_OLD_VERSION") or self._get_nix_attribute(
            f"{self.attribute_path}.version"
        )

    def _get_nix_vscode_extension_platforms(self) -> list[str]:
        """
        Retrieves the extension meta.platforms from Nix.
        """
        try:
            return json.loads(
                self.execute_command([
                    "nix",
                    "--extra-experimental-features",
                    "nix-command",
                    "eval",
                    "--json",
                    "-f",
                    ".",
                    f"{self.attribute_path}.meta.platforms",
                ])
            )
        except subprocess.CalledProcessError:
            return []

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
        command = ["vsce", "show", extension_id, "--json"]
        try:
            output = self.execute_command(command)
            return json.loads(output)
        except (json.JSONDecodeError, subprocess.CalledProcessError) as e:
            logger.exception(e)
            sys.exit(1)

    def find_compatible_extension_version(
        self, extension_versions: list, target_platform: str
    ) -> str:
        """
        Finds the first compatible extension version based on Target Platform and VSCode compatibility.
        """
        for version_info in extension_versions:
            candidate_platform = version_info.get("targetPlatform", None)
            if candidate_platform is not None and candidate_platform != target_platform:
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
                logger.debug(f"Skipping PreRelease version {candidate_version}")
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
                logger.debug(
                    f"Testing extension version: {candidate_version} with VSCode {self.target_vscode_version} (constraint: {engine_version_constraint})"
                )
                engine_version_constraint = self.replace_version_symbol(
                    engine_version_constraint
                )
                try:
                    self.execute_command([
                        "semver",
                        self.target_vscode_version,
                        "-r",
                        engine_version_constraint,
                    ])
                    logger.info(f"Compatible version found: {candidate_version}")
                    return candidate_version
                except (ValueError, subprocess.CalledProcessError):
                    logger.debug(
                        f"Version {candidate_version} is not compatible with VSCode {self.target_vscode_version} (constraint: {engine_version_constraint})."
                    )
                continue
            return candidate_version
        logger.error("Error: not found compatible version.")
        sys.exit(1)

    def replace_version_symbol(self, version: str) -> str:
        return re.sub(r"^\^", ">=", version)

    def update_version_for_default_nix(self, content: str, new_version: str):
        target_name = self.attribute_path.removeprefix("vscode-extensions.")
        pattern = re.compile(
            rf"{re.escape(target_name)}\s*=\s*buildVscodeMarketplaceExtension\s*\{{",
            re.MULTILINE,
        )
        match = pattern.search(content)
        if not match:
            raise ValueError("Target block not found.")
        brace_start = content.find("{", match.end() - 1)
        if brace_start == -1:
            raise ValueError("Opening brace not found.")
        count = 0
        pos = brace_start
        text_len = len(content)
        while pos < text_len:
            if content[pos] == "{":
                count += 1
            elif content[pos] == "}":
                count -= 1
                if count == 0:
                    break
            pos += 1
        if count != 0:
            raise ValueError("Braces mismatch.")
        block_end = pos
        block_text = content[brace_start : block_end + 1]
        version_pattern = re.compile(r'(version\s*=\s*")([^"]+)(";)')

        def repl(m):
            match_version = m.group(2)
            if self.current_version == match_version:
                return f"{m.group(1)}{new_version}{m.group(3)}"
            return m.group(0)

        new_block_text, count_sub = version_pattern.subn(repl, block_text)
        if count_sub == 0:
            raise ValueError("No version field updated.")
        updated_content = (
            content[:brace_start] + new_block_text + content[block_end + 1 :]
        )
        Path(self.override_filename).write_text(updated_content, encoding="utf-8")

    def run_nix_update(self, new_version: str, system: str) -> None:
        """
        Builds and executes the nix-update command.
        """
        if not self.override_filename:
            self.override_filename = self.execute_command(
                [
                    "nix",
                    "edit",
                    "--extra-experimental-features",
                    "nix-command",
                    "-f",
                    ".",
                    self.attribute_path,
                ],
                env={**os.environ, "EDITOR": "echo"},
            )
            if (
                "pkgs/applications/editors/vscode/extensions/vscode-utils.nix"
                in self.override_filename
            ) and Path(
                "pkgs/applications/editors/vscode/extensions/default.nix"
            ).exists():
                self.override_filename = (
                    "pkgs/applications/editors/vscode/extensions/default.nix"
                )
        if (
            new_version != "skip"
            and "pkgs/applications/editors/vscode/extensions/default.nix"
            in self.override_filename
        ):
            with logger.catch(exception=(IOError, ValueError)):
                content = Path(self.override_filename).read_text(encoding="utf-8")
                if content.count(self.current_version) > 1:
                    self.update_version_for_default_nix(content, new_version)
                    new_version = "skip"
        if system not in self.supported_nix_systems:
            src_hash = self._get_nix_vscode_extension_src_hash(system)
            update_command = [
                "update-source-version",
                self.attribute_path,
                self.new_version,
                src_hash,
                f"--system={system}",
                "--ignore-same-version",
                "--ignore-same-hash",
                f"--file={self.override_filename}",
            ]
        else:
            update_command = [
                "nix-update",
                self.attribute_path,
                "--version",
                new_version,
                "--override-filename",
                self.override_filename,
                "--system",
                system,
            ]
        self.execute_command(update_command)

    def run(self):
        marketplace_data = self.get_marketplace_extension_data(
            self.extension_marketplace_id
        )
        available_versions = marketplace_data.get("versions", [])
        logger.info(
            f"Total versions found for {self.extension_marketplace_id}: {len(available_versions)}"
        )
        self.new_version = self.find_compatible_extension_version(
            available_versions,
            self.get_target_platform(self.nix_vscode_extension_platforms[0]),
        )
        try:
            self.execute_command([
                "semver",
                self.current_version,
                "-r",
                f"<{self.new_version}",
            ])
        except subprocess.CalledProcessError:
            logger.info("Already up to date or new version is older!")
            sys.exit(0)
        for i, system in enumerate(self.nix_vscode_extension_platforms):
            version = self.new_version if i == 0 else "skip"
            self.run_nix_update(version, system)
        if self.commit:
            self.execute_command(["git", "add", self.override_filename])
            self.execute_command([
                "git",
                "commit",
                "-m",
                f"{self.attribute_path}: {self.current_version} -> {self.new_version}",
            ])


if __name__ == "__main__":
    updater = VSCodeExtensionUpdater()
    updater.run()
