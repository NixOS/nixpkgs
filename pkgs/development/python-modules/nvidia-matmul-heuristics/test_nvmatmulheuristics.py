import math

import pytest

import nvMatmulHeuristics as mmh


def make_interface(gpu):
    # The configuration cutlass.operators uses (cutlass/operators/heuristics/nvmatmul/_provider.py).
    return mmh.NvMatmulHeuristicsInterfaceEx(
        backend=mmh.NvMatmulHeuristicsTarget["CUTLASS3"],
        flags=mmh.NvMatmulHeuristicsFlags.PERF_MODEL_BASED_AUTO_TUNING,
        gpu=mmh.NvMatmulHeuristicsNvidiaGpu[gpu],
        load_discovery_implicitly=True,
    )


def problem(interface, m, n, k):
    return interface.makeNvMatmulHeuristicsProblem(
        m, n, k, mmh.NvMatmulHeuristicsMatmulLayout["NN_ROW_MAJOR"]
    )


@pytest.mark.parametrize("gpu", ["H100_SXM", "B200"])
def test_configs(gpu):
    interface = make_interface(gpu)
    configs = interface.get(problem(interface, 4096, 4096, 4096), 8)

    assert configs
    runtimes = [c["runtime"] for c in configs]
    assert all(math.isfinite(r) and r > 0 for r in runtimes)

    for c in configs:
        kernel = c["kernel"]
        for tile in (kernel.cta_tile_m, kernel.cta_tile_n, kernel.cta_tile_k):
            assert tile > 0 and tile % 16 == 0, f"unexpected tile in {kernel}"
        assert kernel.stages >= 1 and kernel.split_k >= 1


def test_runtime_scales_with_problem_size():
    interface = make_interface("B200")
    small = interface.get(problem(interface, 256, 256, 256), 1)[0]["runtime"]
    large = interface.get(problem(interface, 8192, 8192, 8192), 1)[0]["runtime"]
    # 32768x the FLOPs: the small problem is latency-bound, but the estimate must still grow by well over 10x.
    assert large > 10 * small
