import argparse
import json
import os
import shutil
from dataclasses import dataclass
from pathlib import Path


@dataclass
class RuntimeDependencies:
    source: Path
    destination: Path
    workspaces: dict[str, list[str]]

    def stage(self) -> None:
        store = self.source / "node_modules/.pnpm"
        pending = []
        links = {}

        for workspace, dependencies in self.workspaces.items():
            for dependency in dependencies:
                link = Path(workspace) / "node_modules" / dependency
                target = (self.source / link).resolve(strict=True)
                if not target.is_relative_to(store):
                    raise ValueError(
                        f"Runtime dependency is outside the pnpm store: {target}"
                    )
                links[link] = target.relative_to(self.source)
                pending.append(store / target.relative_to(store).parts[0])

        required = set()
        while pending:
            entry = pending.pop()
            if entry in required:
                continue
            required.add(entry)

            for directory, directories, files in os.walk(entry / "node_modules"):
                directories[:] = [name for name in directories if name != ".bin"]
                for name in directories + files:
                    link = Path(directory) / name
                    if not link.is_symlink():
                        continue

                    target = link.resolve()
                    if target.is_relative_to(store):
                        pending.append(store / target.relative_to(store).parts[0])
                    elif target.is_relative_to(self.source):
                        raise ValueError(
                            f"Runtime dependency points outside the pnpm store: {link}"
                        )

        for entry in sorted(required):
            # Relative dependency links require the original virtual-store layout.
            shutil.copytree(
                entry,
                self.destination / entry.relative_to(self.source),
                symlinks=True,
            )

        for link, target in links.items():
            destination = self.destination / link
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.symlink_to(
                os.path.relpath(self.destination / target, destination.parent)
            )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("destination", type=Path)
    parser.add_argument("manifest", type=Path)
    arguments = parser.parse_args()

    dependencies = RuntimeDependencies(
        source=arguments.source.resolve(),
        destination=arguments.destination.resolve(),
        workspaces=json.loads(arguments.manifest.read_text()),
    )
    dependencies.stage()


if __name__ == "__main__":
    main()
