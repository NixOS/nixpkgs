import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


resolver = sys.argv.pop(1)


class ResolverTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)

    def manifest(self, band, name, version):
        path = self.root / "sdk-manifests" / band / name / version / "WorkloadManifest.json"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps({"version": version, "workloads": {}, "packs": {}}))
        return path

    def select(self, version, names, env=None):
        directory = self.root / "sdk" / version
        directory.mkdir(parents=True, exist_ok=True)
        (directory / "KnownWorkloadManifests.txt").write_text("\n".join(names))
        result = subprocess.run(
            [resolver, str(self.root), version], env=env,
            check=True, capture_output=True, text=True,
        )
        return json.loads(result.stdout)

    def test_fallback_is_per_manifest(self):
        aspire = self.manifest("8.0.100", "microsoft.net.sdk.aspire", "8.2.2")
        android = self.manifest("9.0.100", "microsoft.net.sdk.android", "35.0.7")
        result = self.select("9.0.115", ["microsoft.net.sdk.aspire", "microsoft.net.sdk.android"])
        self.assertEqual({entry["path"] for entry in result["manifests"]}, {str(aspire), str(android)})
        self.assertEqual(result["sdkFeatureBand"], "9.0.100")

    def test_preview_uses_base_band_and_previous_preview(self):
        mobile = self.manifest("11.0.100-preview.1", "microsoft.net.sdk.android", "36.1.0")
        wasm = self.manifest("11.0.100", "microsoft.net.workload.mono.toolchain.current", "11.0.0")
        result = self.select(
            "11.0.100-preview.2.26159.112",
            ["microsoft.net.sdk.android", "microsoft.net.workload.mono.toolchain.current"],
        )
        self.assertEqual({entry["path"] for entry in result["manifests"]}, {str(mobile), str(wasm)})

    def test_latest_manifest_version_wins_without_using_future_band(self):
        name = "microsoft.net.sdk.android"
        self.manifest("10.0.100", name, "36.0.9")
        newest = self.manifest("10.0.100", name, "36.0.10")
        self.manifest("10.0.300", name, "37.0.0")
        result = self.select("10.0.201", [name])
        self.assertEqual([entry["path"] for entry in result["manifests"]], [str(newest)])

    def test_unknown_older_manifest_and_ambient_roots_are_ignored(self):
        self.manifest("8.0.100", "microsoft.net.sdk.aspire", "8.2.2")
        android = self.manifest("10.0.100", "microsoft.net.sdk.android", "36.0.0")
        environment = os.environ | {
            "DOTNETSDK_WORKLOAD_MANIFEST_IGNORE_DEFAULT_ROOTS": "1",
            "DOTNETSDK_WORKLOAD_MANIFEST_ROOTS": str(self.root / "nonexistent"),
        }
        result = self.select("10.0.105", ["microsoft.net.sdk.android"], environment)
        self.assertEqual([entry["path"] for entry in result["manifests"]], [str(android)])


unittest.main()
