"""Exercise the configure checker with independent generated-repository fixtures."""

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

CHECKER = Path(sys.argv.pop(1)).resolve()


class CudaConfigureCheckTest(unittest.TestCase):
    def check_fixture(self, real, forward, architectures, sass, ptx, *, valid=True):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "cuda").mkdir()
            (root / "cuda" / "cuda_config.py").write_text(
                f"config = {{'cuda_compute_capabilities': {architectures!r}}}\n"
            )
            (root / "build_defs.bzl").write_text(
                f"def cuda_gpu_architectures():\n    return {architectures!r}\n"
                f"cuda_copts = {[f'--cuda-gpu-arch=sm_{arch}' for arch in sass] + [f'--cuda-include-ptx=sm_{arch}' for arch in ptx]!r}\n"
            )
            expected = root / "expected.json"
            expected.write_text(
                json.dumps(
                    {
                        "realArches": [f"sm_{arch}" for arch in real],
                        "virtualArches": [f"compute_{arch}" for arch in real],
                        "cudaForwardCompat": forward,
                    }
                )
            )
            result = subprocess.run(
                [sys.executable, str(CHECKER), str(root), str(expected)],
                capture_output=True,
                text=True,
                check=False,
            )
            if valid:
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn("PASS regenerated config", result.stdout)
            else:
                self.assertEqual(result.returncode, 1, result.stderr)
                self.assertIn("AssertionError", result.stderr)

    def test_duplicate_capabilities(self):
        # Literal outputs follow the pinned rules, not checker normalization.
        # Distinct sm_80/compute_80 entries intentionally emit SASS twice.
        fixtures = [
            (["80", "80"], False, ["sm_80"], ["80"], []),
            (["80", "80"], True, ["sm_80", "compute_80"], ["80", "80"], ["80"]),
            (["80", "80", "80"], True, ["sm_80", "compute_80"], ["80", "80"], ["80"]),
            (["80", "89", "80"], False, ["sm_80", "sm_89"], ["80", "89"], []),
            (
                ["80", "89", "80"],
                True,
                ["sm_80", "sm_89", "compute_80"],
                ["80", "89", "80"],
                ["80"],
            ),
            (
                ["80", "89", "80", "90"],
                False,
                ["sm_80", "sm_89", "sm_90"],
                ["80", "89", "90"],
                [],
            ),
            (
                ["80", "89", "80", "90"],
                True,
                ["sm_80", "sm_89", "compute_90"],
                ["80", "89", "90"],
                ["90"],
            ),
        ]
        for fixture in fixtures:
            with self.subTest(real=fixture[0], forward=fixture[1]):
                self.check_fixture(*fixture)

    def test_reject_stale_configuration(self):
        self.check_fixture(["80", "89"], True, ["sm_80"], ["80"], [], valid=False)

    def test_reject_incorrect_ptx(self):
        for ptx in ([], ["89"], ["80", "80"]):
            with self.subTest(ptx=ptx):
                self.check_fixture(
                    ["80", "89", "80"],
                    True,
                    ["sm_80", "sm_89", "compute_80"],
                    ["80", "89", "80"],
                    ptx,
                    valid=False,
                )

    def test_reject_unwanted_ptx(self):
        self.check_fixture(["80", "80"], False, ["sm_80"], ["80"], ["80"], valid=False)

    def test_reject_deduplicated_sass(self):
        self.check_fixture(
            ["80", "89", "80"],
            True,
            ["sm_80", "sm_89", "compute_80"],
            ["80", "89"],
            ["80"],
            valid=False,
        )

    def test_reject_ptx_selected_after_raw_deduplication(self):
        self.check_fixture(
            ["80", "89", "80"],
            True,
            ["sm_80", "compute_89"],
            ["80", "89"],
            ["89"],
            valid=False,
        )


if __name__ == "__main__":
    unittest.main()
