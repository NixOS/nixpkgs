"""Exercise the guarded cuRAND table bindings without a GPU context."""

import argparse
import importlib
import json

import numpy as np


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--module", default="pycuda._driver")
    args = parser.parse_args()
    driver = importlib.import_module(args.module)
    cases = []
    for bits in (32, 64):
        dtype = np.dtype(f"uint{bits}")
        cases.append(
            (f"scramble{bits}", getattr(driver, f"_get_scramble_constants{bits}"), dtype, 1)
        )
        for prefix in ("", "SCRAMBLED_"):
            name = f"{prefix}VECTOR_{bits}"
            direction = getattr(driver.direction_vector_set, name)
            cases.append(
                (
                    name,
                    lambda dst, count, direction=direction: driver._get_direction_vectors(
                        direction, dst, count
                    ),
                    dtype,
                    bits,
                )
            )

    results = []
    for name, fill, dtype, width in cases:
        reference = np.empty((20000, width), dtype=dtype)
        fill(reference, 20000)
        for count in (0, 1, 17, 19999, 20000, 20001, 40003):
            result = np.empty((count, width), dtype=dtype)
            fill(result, count)
            np.testing.assert_array_equal(result, reference[np.arange(count) % 20000])
            results.append({"case": name, "count": count, "result": "table matches"})

        oversized = np.full((3, width), 123, dtype=dtype)
        fill(oversized, 1)
        np.testing.assert_array_equal(oversized[:1], reference[:1])
        assert np.all(oversized[1:] == 123)
        results.append({"case": name, "result": "unused destination tail preserved"})

        # These rejected-input controls must only run against the patched binding.
        for count, capacity in ((-1, 1), (1, 0), (2, 1), (2147483647, 1)):
            result = np.zeros((capacity, width), dtype=dtype)
            before = result.tobytes()
            try:
                fill(result, count)
            except ValueError as error:
                assert "count" in str(error) and "buffer" in str(error)
            else:
                raise AssertionError(f"{name} accepted invalid count/capacity")
            assert result.tobytes() == before
            results.append({"case": name, "count": count, "capacity": capacity, "result": "rejected"})

        for count in (1, 2):
            raw = bytearray(width * dtype.itemsize)
            try:
                fill(raw, count)
            except ValueError:
                assert count == 2
            else:
                assert count == 1
            # Resizing fails if a Py_buffer export was retained after the call.
            raw.extend(b"x")
            results.append({"case": name, "count": count, "result": "buffer released"})

        # The buffer protocol still enforces writable, contiguous storage.
        readonly = np.zeros((1, width), dtype=dtype)
        readonly.flags.writeable = False
        noncontiguous = np.zeros((4, width), dtype=dtype)[::2]
        for label, result in (("readonly", readonly), ("noncontiguous", noncontiguous)):
            try:
                fill(result, 1)
            except (ValueError, BufferError):
                pass
            else:
                raise AssertionError(f"{name} accepted {label} buffer")
            results.append({"case": name, "buffer": label, "result": "rejected"})

    print(json.dumps({"curandVersion": list(driver.get_curand_version()), "checks": results}))


if __name__ == "__main__":
    main()
