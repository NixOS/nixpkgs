"""Check managed allocation defaults and explicit flags on a real CUDA device."""
import argparse
import json

import numpy as np
import pycuda.autoinit
import pycuda.driver as cuda
from pycuda.compiler import SourceModule

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--arch", required=True)
args = parser.parse_args()
module = SourceModule(
    """
    __global__ void update(float *a, int n) {
        int i = blockIdx.x * blockDim.x + threadIdx.x;
        if (i < n) a[i] = 2*a[i] + 3;
    }
    """,
    arch=args.arch,
)
update = module.get_function("update")
results = []
for name in ("managed_empty", "managed_zeros", "managed_empty_like", "managed_zeros_like"):
    allocate = getattr(cuda, name)
    for order in ("C", "F"):
        template = np.empty((3, 5), dtype=np.float32, order=order)
        positional = (template,) if name.endswith("_like") else ((3, 5), np.float32)
        keywords = {} if name.endswith("_like") else {"order": order}
        for mode in ("default", "GLOBAL", "HOST"):
            flags = {} if mode == "default" else {"mem_flags": getattr(cuda.mem_attach_flags, mode)}
            array = allocate(*positional, **keywords, **flags)
            assert array.shape == template.shape
            assert array.flags.c_contiguous if order == "C" else array.flags.f_contiguous
            if "zeros" in name:
                assert np.count_nonzero(array) == 0
            flat = array.ravel(order=order)
            flat[:] = np.arange(array.size, dtype=np.float32)
            expected = flat.copy()
            if mode != "HOST":
                # Pass the managed array itself, without an In/Out copy helper.
                update(array, np.int32(array.size), block=(32, 1, 1), grid=(1, 1))
                cuda.Context.synchronize()
                np.testing.assert_array_equal(flat, 2*expected + 3)
            else:
                # Explicit HOST association remains accepted without silently
                # upgrading it to globally accessible device memory.
                np.testing.assert_array_equal(flat, expected)
            results.append({"api": name, "order": order, "flags": mode,
                            "gpu_updated": mode != "HOST", "passed": True})
            del flat, array
        # Zero is still an invalid explicit flag; changing the default must not
        # rewrite the caller's value or hide the driver's validation.
        try:
            allocate(*positional, **keywords, mem_flags=0)
        except cuda.LogicError as error:
            assert "invalid argument" in str(error), str(error)
            results.append({"api": name, "order": order, "flags": 0,
                            "rejected": True, "passed": True})
        else:
            raise AssertionError((name, "explicit zero unexpectedly accepted"))
print(json.dumps({"passed": True, "checks": results, "arch": args.arch}))
