import importlib.util
import base64
import hashlib
import io
import json
import subprocess
import sys
import tempfile
import unittest
import urllib.error
from pathlib import Path
from unittest.mock import MagicMock, patch


sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location(
    "workloads", Path(__file__).resolve().parents[1] / "generate-workload-data.py"
)
workloads = importlib.util.module_from_spec(spec)
spec.loader.exec_module(workloads)


class WorkloadTests(unittest.TestCase):
    def setUp(self):
        workloads.fetch_nuget_hash.cache_clear()
        base_url = patch.object(workloads, "nuget_package_base_url",
                                return_value="https://example.invalid/flat")
        base_url.start()
        self.addCleanup(base_url.stop)

    def test_hash_metadata_avoids_downloading_content(self):
        encoded = base64.b64encode(bytes(64)).decode()
        response = MagicMock()
        response.__enter__.return_value.headers = {"x-ms-meta-sha512": encoded}
        with patch.object(workloads.urllib.request, "urlopen", return_value=response) as fetch:
            self.assertEqual(workloads.fetch_nuget_hash("Demo.Pack", "1.0.0"), "sha512-" + encoded)
        self.assertEqual(fetch.call_count, 1)
        self.assertEqual(fetch.call_args.args[0].method, "HEAD")

    def test_hash_falls_back_to_package_content(self):
        response = MagicMock()
        response.__enter__.return_value.headers = {}
        content = b"package content"
        with patch.object(workloads.urllib.request, "urlopen",
                          side_effect=[response, io.BytesIO(content)]):
            self.assertEqual(
                workloads.fetch_nuget_hash("Demo.Pack", "1.0.0"),
                "sha512-" + base64.b64encode(hashlib.sha512(content).digest()).decode(),
            )

    def test_missing_required_pack_fails(self):
        with self.assertRaisesRegex(RuntimeError, "Missing"):
            workloads.resolve_workload_packs(
                "demo", {"demo": {"packs": ["Missing"]}}, {}, "linux-x64"
            )

    def test_missing_inherited_workload_fails(self):
        with self.assertRaisesRegex(RuntimeError, "base"):
            workloads.resolve_workload_packs(
                "demo", {"demo": {"extends": ["base"]}}, {}, "linux-x64"
            )

    def test_unsupported_platform_is_not_a_missing_dependency(self):
        self.assertEqual(
            workloads.resolve_workload_packs(
                "demo", {"demo": {"platforms": ["osx-arm64"], "packs": ["Missing"]}},
                {}, "linux-x64"
            ),
            [],
        )

    def test_404_is_fatal_without_retrying(self):
        error = urllib.error.HTTPError("https://example.invalid", 404, "Missing", {}, None)
        with patch.object(workloads.urllib.request, "urlopen", side_effect=error) as fetch:
            with self.assertRaisesRegex(RuntimeError, "Demo.Pack.*1.0.0.*404"):
                workloads.fetch_nuget_hash("Demo.Pack", "1.0.0")
        self.assertEqual(fetch.call_count, 1)

    def test_fetch_failure_identifies_affected_workload_and_rid(self):
        with patch.object(workloads, "fetch_nuget_hash", side_effect=RuntimeError("404")):
            with self.assertRaisesRegex(RuntimeError, "demo.*linux-x64"):
                workloads.generate_nix(
                    ["demo"], {"demo": {"packs": ["Demo.Pack"]}},
                    {"Demo.Pack": {"version": "1.0.0"}}, "9.0.100"
                )

    def test_library_pack_role_and_preview_metadata_survive_generation(self):
        with patch.object(workloads, "fetch_nuget_hash", return_value="sha512-test"):
            result = workloads.generate_nix(
                ["demo"], {"demo": {"packs": ["Library"]}},
                {"Library": {"version": "1.0.0", "kind": "library"}},
                "11.0.100-preview.2",
                feature_bands={"11.0.100-preview.2.123": "11.0.100-preview.2"},
            )
        self.assertIn('kind = "library";', result)
        self.assertIn('"11.0.100-preview.2.123" = "11.0.100-preview.2";', result)

    def test_catalog_comparison_ignores_store_paths_but_not_definitions(self):
        with tempfile.TemporaryDirectory() as tmp:
            manifests = []
            for name in ("one", "two"):
                path = Path(tmp) / name
                path.write_text(json.dumps({"workloads": {"demo": {}}, "packs": {}}))
                manifests.append({
                    "manifests": [{"id": "demo", "path": str(path),
                                   "featureBand": "8.0.100", "version": "1.0.0"}]
                })
            first = workloads.load_selected_manifests(manifests[0])
            second = workloads.load_selected_manifests(manifests[1])
            self.assertEqual(first, second)
            Path(tmp, "two").write_text('{"workloads": {"different": {}}, "packs": {}}')
            changed = workloads.load_selected_manifests(manifests[1])
            with self.assertRaisesRegex(RuntimeError, "sdk-two.*demo"):
                workloads.check_catalog_compatibility("sdk-one", first, "sdk-two", changed)

    def test_omitted_sdk_channels_fail_before_sdk_discovery(self):
        with patch.object(workloads, "discover_sdks",
                          side_effect=AssertionError("An omitted SDK must not be evaluated")):
            for version in ("8.0", "9.0"):
                with self.subTest(version=version):
                    with self.assertRaisesRegex(ValueError, "No workload data registered"):
                        workloads.generate_workload_data(version)

    def test_later_channel_failure_preserves_all_files(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            for version in ("8.0", "9.0"):
                (directory / f"{version}.nix").write_text(f"old {version}")
            with (
                patch.object(workloads, "generate_workload_data",
                             side_effect=["{}", RuntimeError("required pack missing")]),
                patch.object(workloads.subprocess, "run"),
            ):
                with self.assertRaisesRegex(RuntimeError, "required pack missing"):
                    workloads.update_workload_data(directory, ["8.0", "9.0"])
            for version in ("8.0", "9.0"):
                self.assertEqual((directory / f"{version}.nix").read_text(), f"old {version}")
            self.assertEqual(len(list(directory.iterdir())), 2)

    def test_validation_failure_preserves_file(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            (directory / "9.0.nix").write_text("old")
            with (
                patch.object(workloads, "generate_workload_data", return_value="{}"),
                patch.object(workloads.subprocess, "run",
                             side_effect=subprocess.CalledProcessError(1, "nixfmt")),
            ):
                with self.assertRaises(subprocess.CalledProcessError):
                    workloads.update_workload_data(directory, ["9.0"])
            self.assertEqual((directory / "9.0.nix").read_text(), "old")

    def test_success_publishes_only_requested_channels(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            for version in ("8.0", "9.0"):
                (directory / f"{version}.nix").write_text("old")
            with (
                patch.object(workloads, "generate_workload_data", return_value="{}"),
                patch.object(workloads.subprocess, "run"),
            ):
                workloads.update_workload_data(directory, ["9.0"])
            self.assertEqual((directory / "9.0.nix").read_text(), "{}\n")
            self.assertEqual((directory / "8.0.nix").read_text(), "old")


if __name__ == "__main__":
    unittest.main()
