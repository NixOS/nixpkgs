"""Check regenerated XLA CUDA configuration against the selected nixpkgs flags."""

import ast
import json
import re
import runpy
import sys
from pathlib import Path


def main():
    root = Path(sys.argv[1])
    flags = json.loads(Path(sys.argv[2]).read_text())
    architectures = flags["realArches"].copy()
    if flags["cudaForwardCompat"]:
        architectures[-1] = flags["virtualArches"][-1]
    # The pinned rules deduplicate rendered capabilities, after PTX selection.
    # Distinct sm_* and compute_* entries can still emit the same SASS flag.
    architectures = list(dict.fromkeys(architectures))
    sass = [arch.replace("compute_", "sm_") for arch in architectures]
    ptx = [
        arch.replace("compute_", "sm_")
        for arch in architectures
        if arch.startswith("compute_")
    ]

    config = runpy.run_path(str(root / "cuda" / "cuda_config.py"))["config"]
    assert config["cuda_compute_capabilities"] == architectures, config
    defs = (root / "build_defs.bzl").read_text()
    match = re.search(
        r"def cuda_gpu_architectures\(\):.*?return (\[[^\n]*\])", defs, re.DOTALL
    )
    assert match is not None, "missing generated cuda_gpu_architectures definition"
    assert ast.literal_eval(match.group(1)) == architectures, match.group(1)
    actual_sass = re.findall(r"--cuda-gpu-arch=(sm_[0-9a-z]+)", defs)
    actual_ptx = re.findall(r"--cuda-include-ptx=(sm_[0-9a-z]+)", defs)
    assert actual_sass == sass, (actual_sass, sass)
    assert actual_ptx == ptx, (actual_ptx, ptx)
    print(f"PASS regenerated config, SASS {sass}, PTX {ptx}")


if __name__ == "__main__":
    main()
