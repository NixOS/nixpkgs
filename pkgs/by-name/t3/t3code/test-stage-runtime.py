import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


class StageRuntimeTest(unittest.TestCase):
    def test_rejects_dependencies_outside_the_virtual_store(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "source"
            workspace = source / "apps/server/node_modules"
            workspace.mkdir(parents=True)
            outside = source / "packages/local"
            outside.mkdir(parents=True)
            (workspace / "local").symlink_to(os.path.relpath(outside, workspace))
            manifest = root / "runtime.json"
            manifest.write_text(json.dumps({"apps/server": ["local"]}))

            result = subprocess.run(
                [
                    sys.executable,
                    str(Path(__file__).with_name("stage-runtime.py")),
                    str(source),
                    str(root / "output"),
                    str(manifest),
                ],
                capture_output=True,
                check=False,
                text=True,
            )

            self.assertEqual(1, result.returncode)
            self.assertIn("Runtime dependency is outside the pnpm store", result.stderr)
            self.assertFalse((root / "output").exists())

    def test_preserves_runtime_dependencies_and_peer_contexts(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "source"
            output = root / "output"
            store = source / "node_modules/.pnpm"

            packages = {
                "app@1": "app",
                "app@2": "app",
                "dep@1": "dep",
                "dep@2": "dep",
                "@scope+native@1": "@scope/native",
                "unused@1": "unused",
            }
            for entry, package in packages.items():
                directory = store / entry / "node_modules" / package
                directory.mkdir(parents=True)
                (directory / "index.js").write_text(entry)

            links = {
                "apps/server/node_modules/app": "node_modules/.pnpm/app@1/node_modules/app",
                "apps/desktop/node_modules/app": "node_modules/.pnpm/app@2/node_modules/app",
                "apps/desktop/node_modules/@scope/native": "node_modules/.pnpm/@scope+native@1/node_modules/@scope/native",
                "node_modules/.pnpm/app@1/node_modules/dep": "node_modules/.pnpm/dep@1/node_modules/dep",
                "node_modules/.pnpm/app@2/node_modules/dep": "node_modules/.pnpm/dep@2/node_modules/dep",
                "node_modules/.pnpm/dep@1/node_modules/app": "node_modules/.pnpm/app@1/node_modules/app",
            }
            for link, target in links.items():
                path = source / link
                path.parent.mkdir(parents=True, exist_ok=True)
                path.symlink_to(os.path.relpath(source / target, path.parent))

            manifest = root / "runtime.json"
            manifest.write_text(
                json.dumps(
                    {
                        "apps/server": ["app"],
                        "apps/desktop": ["app", "@scope/native"],
                    }
                )
            )
            subprocess.run(
                [
                    sys.executable,
                    str(Path(__file__).with_name("stage-runtime.py")),
                    str(source),
                    str(output),
                    str(manifest),
                ],
                check=True,
            )

            actual = {}
            for path in output.rglob("*"):
                relative = str(path.relative_to(output))
                if path.is_symlink():
                    actual[relative] = {"symlink": os.readlink(path)}
                elif path.is_file():
                    actual[relative] = {"contents": path.read_text()}

            expected = {
                f"node_modules/.pnpm/{entry}/node_modules/{package}/index.js": {
                    "contents": entry
                }
                for entry, package in packages.items()
                if entry != "unused@1"
            }
            expected.update(
                {
                    link: {"symlink": os.path.relpath(target, os.path.dirname(link))}
                    for link, target in links.items()
                }
            )
            self.assertEqual(expected, actual)


if __name__ == "__main__":
    unittest.main()
