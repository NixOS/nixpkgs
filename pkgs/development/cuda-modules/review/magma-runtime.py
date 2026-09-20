"""Run six bounded MAGMA correctness suites against an installed test output.

Run on HOST, outside stdenv, with its NVIDIA driver available. For example:
  python3 magma-runtime.py --test-output /nix/store/...-magma-...-test \
    --evidence-dir ./magma-runtime --machine aarch64 \
    --driver-library-path /run/opengl-driver/lib

Upstream suites calculate normwise errors and compare them with LAPACK machine
precision. Require their success markers and exact dimensions/stride coverage;
exit success alone also admits missing or accidentally skipped test cases.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess


COMMON = ["-N", "128", "-N", "256", "--lapack", "--niter", "1"]
CASES = {
    "sgemm": ["testing_sgemm", *COMMON],
    "sgesv-gpu": ["testing_sgesv_gpu", *COMMON, "--nrhs", "4"],
    "zgemm-nn": ["testing_zgemm", *COMMON, "-NN"],
    "zgemm-cn": ["testing_zgemm", *COMMON, "-CN"],
    "zgesv-gpu": ["testing_zgesv_gpu", *COMMON, "--nrhs", "4"],
    "complex-dot": ["testing_cblas_z", "-N", "17", "-N", "128", "--niter", "1"],
}


def validate_rows(name, rows):
    assert len(rows) == (72 if name == "complex-dot" else 2), len(rows)
    assert all(row.split()[-1] == "ok" for row in rows), "failed numerical row"
    assert not any(re.search(r"\b(?:nan|inf)\b", row, re.I) for row in rows)
    if name == "complex-dot":
        expected = {
            (size, size, size, x, y, operation)
            for size in (17, 128)
            for operation in ("zdotc", "zdotu")
            for x in (-2, -1, 1, 2)
            for y in (-2, -1, 1, 2)
        } | {
            (size, size, size, stride, stride, operation)
            for size in (17, 128)
            for operation in ("dzasum", "dznrm2")
            for stride in (1, 2)
        }
        actual = set()
        for row in rows:
            columns = row.split()
            actual.add((*map(int, columns[:5]), columns[5]))
            # The CBLAS reference may be disabled, but Fortran and inline
            # complex-return conventions must both actually be checked.
            for value in columns[-3:-1]:
                assert 0 <= float(value) < 1e-12, row
        assert actual == expected, (actual - expected, expected - actual)
    else:
        prefix_length = 2 if "gesv" in name else 3
        expected = [(size, 4) if prefix_length == 2 else (size,) * 3 for size in (128, 256)]
        assert [tuple(map(int, row.split()[:prefix_length])) for row in rows] == expected
        for row in rows:
            errors = row.split()[-2:-1] if prefix_length == 2 else row.split()[-3:-1]
            # Additional coarse bound on printed values; upstream applies
            # its tighter precision-dependent tolerance before printing ok.
            limit = 1e-5 if name.startswith("s") else 1e-12
            assert all(0 <= float(error) < limit for error in errors), row


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--test-output", type=Path, required=True)
    parser.add_argument("--evidence-dir", type=Path, required=True)
    parser.add_argument("--machine", choices=("aarch64", "x86_64"), required=True)
    parser.add_argument("--driver-library-path", default="/run/opengl-driver/lib")
    args = parser.parse_args()
    args.evidence_dir.mkdir(parents=True, exist_ok=True)
    home = args.evidence_dir.resolve() / "home"
    home.mkdir(exist_ok=True)
    env = {
        "HOME": str(home), "PATH": os.defpath,
        "LD_LIBRARY_PATH": args.driver_library_path,
        "OMP_NUM_THREADS": "2", "OPENBLAS_NUM_THREADS": "2",
    }
    results = []
    for name, command in CASES.items():
        command = [str(args.test_output / "bin" / command[0]), *command[1:]]
        result = {"case": name, "command": command, "validated": False}
        try:
            binary = Path(command[0]).read_bytes()
            assert binary[:6] == b"\x7fELF\x02\x01", "expected ELF64 little-endian"
            result["elf_machine"] = int.from_bytes(binary[18:20], "little")
            assert result["elf_machine"] == {"aarch64": 183, "x86_64": 62}[args.machine]
            result["binary_sha256"] = hashlib.sha256(binary).hexdigest()
            with (args.evidence_dir / f"{name}.log").open("w") as output:
                completed = subprocess.run(command, env=env, stdout=output, stderr=subprocess.STDOUT, timeout=120)
            result["status"] = completed.returncode
            output = (args.evidence_dir / f"{name}.log").read_text()
            rows = [line for line in output.splitlines() if re.match(r"\s*\d", line)]
            result["numerical_rows"] = rows
            assert completed.returncode == 0, completed.returncode
            validate_rows(name, rows)
            result["validated"] = True
        except (AssertionError, OSError, ValueError, subprocess.TimeoutExpired) as error:
            result["error"] = f"{type(error).__name__}: {error}"
        results.append(result)
        print(json.dumps({key: value for key, value in result.items() if key != "numerical_rows"}), flush=True)
    evidence = {
        "test_output": str(args.test_output), "machine": args.machine,
        "environment": env, "passed": all(case["validated"] for case in results),
        "results": results,
    }
    (args.evidence_dir / "results.json").write_text(json.dumps(evidence, indent=2) + "\n")
    raise SystemExit(not evidence["passed"])


if __name__ == "__main__":
    main()
