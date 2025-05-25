#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p nix python3 python3Packages.loguru nix-search-tv vscode-extension-update gitMinimal

import argparse
import subprocess

from loguru import logger


class VSCodeExtensionBatchUpdater:
    # Extensions to be skipped
    _excluded_extensions = [
        # wrong upstream constraint: 0.10.x
        "vscode-extensions.ms-vscode.theme-tomorrowkit",
        "vscode-extensions.richie5um2.snake-trail",
        # not supported
        "vscode-extensions.ms-ceintl.vscode-language-pack-cs",
        "vscode-extensions.ms-ceintl.vscode-language-pack-de",
        "vscode-extensions.ms-ceintl.vscode-language-pack-es",
        "vscode-extensions.ms-ceintl.vscode-language-pack-fr",
        "vscode-extensions.ms-ceintl.vscode-language-pack-it",
        "vscode-extensions.ms-ceintl.vscode-language-pack-ja",
        "vscode-extensions.ms-ceintl.vscode-language-pack-ko",
        "vscode-extensions.ms-ceintl.vscode-language-pack-pl",
        "vscode-extensions.ms-ceintl.vscode-language-pack-pt-br",
        "vscode-extensions.ms-ceintl.vscode-language-pack-qps-ploc",
        "vscode-extensions.ms-ceintl.vscode-language-pack-ru",
        "vscode-extensions.ms-ceintl.vscode-language-pack-tr",
        "vscode-extensions.ms-ceintl.vscode-language-pack-zh-hans",
        "vscode-extensions.ms-ceintl.vscode-language-pack-zh-hant",
    ]

    # Unable to determine the correct file location
    _extension_file_map = {
        "vscode-extensions.hashicorp.terraform": "pkgs/applications/editors/vscode/extensions/hashicorp.terraform/default.nix",
        "vscode-extensions.betterthantomorrow.calva": "pkgs/applications/editors/vscode/extensions/betterthantomorrow.calva/default.nix",
    }

    def __init__(self):
        self.parser = argparse.ArgumentParser(
            description="Batch update VSCode extensions"
        )

    def execute_command(
        self, command, env: dict[str, str] = None, shell: bool = False
    ) -> str:
        logger.debug("Executing command: {} (shell={})", command, shell)
        return subprocess.run(
            command,
            check=True,
            capture_output=True,
            text=True,
            env=env,
            shell=shell,
        ).stdout.strip()

    def _get_extension_list(self) -> list[str]:
        # Get extension list from nix-search-tv output
        command = "nix-search-tv print | grep '^nixpkgs/ vscode-extensions\\.' | cut -d' ' -f2-"
        output = self.execute_command(command, shell=True)
        extension_list = output.splitlines()
        logger.info("Found {} extensions: {}", len(extension_list), extension_list)
        return extension_list

    def _has_update_script(self, extension: str) -> bool:
        try:
            result = self._get_nix_attribute(f"{extension}.updateScript")
            return "not found" not in result
        except subprocess.CalledProcessError:
            return False

    def _get_nix_attribute(self, attribute: str) -> str:
        return self.execute_command(["nix", "eval", "--raw", "-f", ".", attribute])

    def _get_extension_filename(self, extension: str) -> str | None:
        return self._extension_file_map.get(extension)

    def _update_extension(self, extension: str) -> None:
        logger.info("Updating extension: {}", extension)
        if extension in self._excluded_extensions:
            return
        try:
            if self._has_update_script(extension):
                return
            update_command = ["vscode-extension-update", extension, "--commit"]
            filename = self._get_extension_filename(extension)
            if filename:
                update_command.extend(["--override-filename", filename])
            self.execute_command(update_command)
            logger.info("Updated extension: {}", extension)
        except subprocess.CalledProcessError:
            logger.error("Failed to update extension: {}", extension)
            self.execute_command(["git", "restore", "."])

    def run(self) -> None:
        for extension in self._get_extension_list():
            self._update_extension(extension)


if __name__ == "__main__":
    updater = VSCodeExtensionBatchUpdater()
    updater.run()
