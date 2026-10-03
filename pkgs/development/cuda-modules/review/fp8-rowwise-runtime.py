#!/usr/bin/env python3
"""Separate supported-GB10 FP8 rowwise check; --profile observes dispatch separately."""
import argparse
import json
import os
from pathlib import Path
import time

import torch
from torch.nn.functional import ScalingType, scaled_mm



def prepare(shape, exact):
    m, k, n = shape
    generator = torch.Generator().manual_seed(545092 + m + k + n)
    if exact:
        a_cpu = torch.full((m, k), 0.5)
        b_storage_cpu = torch.full((n, k), 0.5)
        scale_a_cpu = (2.0 ** (torch.arange(m) % 3 - 1)).reshape(m, 1)
        scale_b_cpu = (2.0 ** (torch.arange(n) % 3 - 1)).reshape(1, n)
        bias_cpu = None
    else:
        # Bounded inputs avoid overflow/saturation, while quantization is real.
        a_cpu = torch.rand((m, k), generator=generator) * 2 - 1
        b_storage_cpu = torch.rand((n, k), generator=generator) * 2 - 1
        scale_a_cpu = (0.5 + (torch.arange(m) % 8) / 16).reshape(m, 1)
        scale_b_cpu = (0.5 + (torch.arange(n) % 8) / 16).reshape(1, n)
        bias_cpu = torch.linspace(-0.25, 0.25, n).to(torch.bfloat16)
    a_fp8_cpu = a_cpu.to(torch.float8_e4m3fn)
    b_storage_fp8_cpu = b_storage_cpu.to(torch.float8_e4m3fn)
    a_dequant = a_fp8_cpu.float().double() * scale_a_cpu.double()
    b_dequant = b_storage_fp8_cpu.float().double().t() * scale_b_cpu.double()
    reference = a_dequant @ b_dequant
    if bias_cpu is not None:
        reference += bias_cpu.double()
    reference = reference.to(torch.bfloat16)
    if exact:
        analytic = (k * 0.25 * scale_a_cpu * scale_b_cpu).to(torch.bfloat16)
        torch.testing.assert_close(reference, analytic, atol=0, rtol=0)
    prepared = {
        "a": a_fp8_cpu.cuda(),
        # Form the transpose after upload so B is definitely column-major.
        "b": b_storage_fp8_cpu.cuda().t(),
        "scale_a": scale_a_cpu.cuda(),
        "scale_b": scale_b_cpu.cuda(),
        "bias": None if bias_cpu is None else bias_cpu.cuda(),
        "reference": reference,
    }
    assert prepared["a"].stride() == (k, 1)
    assert prepared["b"].stride() == (1, k)
    assert prepared["scale_a"].shape == (m, 1)
    assert prepared["scale_b"].shape == (1, n)
    assert k % 16 == n % 16 == 0
    return prepared


def invoke(api, data):
    if api == "legacy":
        return torch._scaled_mm(
            data["a"], data["b"], data["scale_a"], data["scale_b"],
            bias=data["bias"], out_dtype=torch.bfloat16, use_fast_accum=False,
        )
    return scaled_mm(
        data["a"], data["b"], data["scale_a"], ScalingType.RowWise,
        data["scale_b"], ScalingType.RowWise,
        bias=data["bias"], output_dtype=torch.bfloat16, use_fast_accum=False,
    )


def numerical(properties):
    rows = []
    # First two choose TileShape.M=64; the third chooses M=128 on 48-SM GB10.
    cases = [((64, 128, 128), True), ((128, 512, 256), False), ((1024, 128, 512), False)]
    observed_tiles = set()
    for shape, exact in cases:
        m, k, n = shape
        tile_m = 64 if ((m + 63) // 64) * ((n + 127) // 128) <= properties.multi_processor_count else 128
        observed_tiles.add(tile_m)
        data = prepare(shape, exact)
        for api in ("legacy", "functional_v2"):
            start = time.monotonic()
            actual = invoke(api, data)
            torch.cuda.synchronize()
            assert actual.dtype == torch.bfloat16 and actual.shape == (m, n)
            actual_cpu = actual.cpu()
            assert torch.isfinite(actual_cpu).all()
            atol, rtol = (0.0, 0.0) if exact else (0.001, 0.01)
            torch.testing.assert_close(actual_cpu, data["reference"], atol=atol, rtol=rtol)
            error = (actual_cpu.float() - data["reference"].float()).abs()
            rows.append({"api": api, "shape_mkn": shape, "tile_m_from_dispatch": tile_m,
                         "exact_control": exact, "bias": data["bias"] is not None,
                         "atol": atol, "rtol": rtol, "max_absolute_error": error.max().item(),
                         "rms_error": error.square().mean().sqrt().item(),
                         "seconds": time.monotonic() - start, "status": "passed"})
    assert observed_tiles == {64, 128}, observed_tiles
    return {"mode": "numerical", "cases": rows, "status": "passed"}


def observe_dispatch():
    data = prepare((128, 512, 256), exact=False)
    invoke("functional_v2", data)
    torch.cuda.synchronize()
    with torch.profiler.profile(activities=[torch.profiler.ProfilerActivity.CPU,
                                           torch.profiler.ProfilerActivity.CUDA]) as trace:
        actual = invoke("functional_v2", data)
        torch.cuda.synchronize()
    torch.testing.assert_close(actual.cpu(), data["reference"], atol=0.001, rtol=0.01)
    names = sorted({event.name for event in trace.events() if "CUDA" in str(event.device_type)})
    selected = [name for name in names if "sm120" in name.lower()]
    result = {"mode": "profile", "cuda_kernel_names": names, "sm120_kernel_names": selected,
              "status": "passed" if selected else "sm120_path_not_observed"}
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--profile", action="store_true")
    parser.add_argument("--metadata", type=Path, required=True)
    args = parser.parse_args()
    metadata = json.loads(args.metadata.read_text())
    assert Path(torch.__file__).resolve().is_relative_to(metadata["torch"]["outputs"]["out"])
    assert not any(key.startswith("NIX_") for key in os.environ)
    assert "CC" not in os.environ and "CXX" not in os.environ
    assert torch.cuda.is_available() and torch.version.cuda == "13.3"
    assert torch.cuda.get_device_capability() == (12, 1)
    assert "sm_121a" in torch.cuda.get_arch_list()
    assert torch._C._get_sm_carveout_experimental() is None
    torch.set_num_threads(2)
    properties = torch.cuda.get_device_properties(0)
    result = observe_dispatch() if args.profile else numerical(properties)
    result.update({"torch": torch.__version__, "torch_file": str(Path(torch.__file__).resolve()),
                   "torch_drv": metadata["torch"]["drv"], "cuda": torch.version.cuda,
                   "device": properties.name, "capability": torch.cuda.get_device_capability(),
                   "num_sms": properties.multi_processor_count,
                   "input_dtype": "float8_e4m3fn", "output_dtype": "bfloat16",
                   "scaling": "nonuniform FP32 [M,1] and [1,N] decoding scales",
                   "reference": "CPU FP64 matmul after FP8 dequantization, then BF16 rounding",
                   "use_fast_accum": False})
    print(json.dumps(result, indent=2), flush=True)
    return 0 if result["status"] == "passed" else 2


if __name__ == "__main__":
    raise SystemExit(main())
