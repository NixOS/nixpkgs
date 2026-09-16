"""Run with the Python environment under review, outside setup-hook activation.

cpu-dot checks cross BLAS selection. csr-promotion checks the shared CPU/CUDA
CSR sum/product dtype and empty-result contract. Neither check compiles code;
run both against the installed artifacts being reviewed.
"""

import argparse
import json

import torch


def cpu_dot():
    cases = 0
    for dtype in (torch.float32, torch.float64, torch.complex64, torch.complex128):
        values = torch.arange(1, 18, dtype=torch.float64).to(dtype)
        if dtype.is_complex:
            values = values + 0.25j * values.flip(0)
        for lhs, rhs in (
            (values, values),
            (values[::2], values.flip(0)[::2]),
            (values.conj(), values),
        ):
            torch.testing.assert_close(torch.dot(lhs, rhs), (lhs * rhs).sum())
            torch.testing.assert_close(torch.vdot(lhs, rhs), (lhs.conj() * rhs).sum())
            cases += 2
    return {"passed": True, "cases": cases}


def csr_promotion(operators=None):
    # The private product reduces stored entries, as used by torch.masked.prod.
    # Implicit zeros are absent from the product, and empty groups stay absent.
    # Dense product is a valid reference only for our completely filled lines.
    operators = operators or {
        "sum": lambda x, dim, keepdim, dtype: x.sum(
            dim=dim, keepdim=keepdim, dtype=dtype
        ),
        "prod": torch._sparse_csr_prod,
    }
    cases = []
    dimensions = ((0,), (1,), (0, 1), (1, 0), (-2,), (-1,), ())
    profiles = (
        (torch.int8, [1] * 129, [8] * 3),
        (torch.uint8, [1] * 257, [8] * 3),
        (torch.int16, [2**14] * 3, [64] * 3),
        (torch.int32, [2**30] * 3, [1024] * 4),
        (torch.int64, [2, 3, 5], [2, 3, 5]),
        (torch.bool, [True] * 129, [True, False, True]),
        (torch.float16, [1024, 0.5, -1024], [256, 256, 1 / 256, 1 / 256]),
        (torch.bfloat16, [256, 1, -256], [1 + 1 / 128] * 128),
        (torch.float32, [1.5, -2, 3], [1.5, -2, 3]),
        (torch.float64, [1.5, -2, 3], [1.5, -2, 3]),
        (torch.complex64, [1 + 2j, -2 + 1j, 3 - 1j], [1 + 2j, -2 + 1j, 3 - 1j]),
        (torch.complex128, [1 + 2j, -2 + 1j, 3 - 1j], [1 + 2j, -2 + 1j, 3 - 1j]),
    )

    def output_dtype(dtype, requested):
        return requested or (
            dtype if dtype.is_floating_point or dtype.is_complex else torch.int64
        )

    def check(csr, operation, dim, requested, expected, kind):
        case = {
            "kind": kind, "device": str(csr.device), "operation": operation,
            "dtype": str(csr.dtype), "index_dtype": str(csr.crow_indices().dtype),
            "dim": dim, "requested_dtype": str(requested), "shape": list(csr.shape),
            "values_stride": list(csr.values().stride()),
            "values_storage_offset": csr.values().storage_offset(),
        }
        try:
            result = operators[operation](csr, dim, True, dtype=requested)
            case["result_dtype"] = str(result.dtype)
            # Validate the sparse representation before densifying. The old
            # empty dim01 result has a scalar values tensor with zero indices.
            assert result.values().ndim == 1, tuple(result.values().shape)
            assert result.values().numel() == result.col_indices().numel()
            assert result.crow_indices().dtype == csr.crow_indices().dtype
            assert result.col_indices().dtype == csr.col_indices().dtype
            torch.sparse_csr_tensor(
                result.crow_indices(), result.col_indices(), result.values(),
                size=result.shape, check_invariants=True,
            )
            # Wide floating products can associate differently across CPU
            # and GPU. Keep low-precision rounding and all integer checks exact.
            rtol = (8 * torch.finfo(expected.dtype).eps if expected.dtype in
                    (torch.float32, torch.float64, torch.complex64, torch.complex128)
                    else 0)
            torch.testing.assert_close(result.to_dense().cpu(), expected, rtol=rtol, atol=0)
            case["passed"] = True
        except Exception as error:
            case.update(passed=False, error=f"{type(error).__name__}: {error}")
        cases.append(case)

    for dtype, sum_values, prod_values in profiles:
        wide = (
            torch.complex128 if dtype == torch.complex64 else
            torch.complex64 if dtype == torch.complex128 else
            torch.float32 if dtype == torch.float64 else
            torch.float64 if dtype.is_floating_point else torch.int64
        )
        for operation, values in (("sum", sum_values), ("prod", prod_values)):
            for dim in dimensions:
                normalized = tuple(axis % 2 for axis in dim) or (0, 1)
                shape = (len(values), 1) if normalized == (0,) else (1, len(values))
                dense = torch.tensor(values, dtype=dtype).reshape(shape)
                for requested in (None, dtype, wide):
                    result_dtype = output_dtype(dtype, requested)
                    # Compute floating/complex products in the accumulator
                    # dtype, then round once; narrow per-step arithmetic is
                    # precisely one of the regressions being checked.
                    accumulation_dtype = (
                        torch.float32 if result_dtype in (torch.float16, torch.bfloat16)
                        else result_dtype
                    )
                    converted = dense.to(result_dtype).to(accumulation_dtype)
                    if operation == "sum":
                        expected = converted.sum(dim=normalized, keepdim=True)
                    elif len(normalized) == 2:
                        expected = converted.flatten().prod().reshape(1, 1)
                    else:
                        expected = converted.prod(dim=normalized[0], keepdim=True)
                    expected = expected.to(result_dtype)
                    for index_dtype in (torch.int32, torch.int64):
                        for device in ("cpu", "cuda"):
                            # Construct explicitly so stored zero values (in
                            # particular False) participate in the product.
                            column = normalized == (0,)
                            csr = torch.sparse_csr_tensor(
                                torch.arange(len(values) + 1, dtype=index_dtype, device=device)
                                if column else torch.tensor([0, len(values)], dtype=index_dtype, device=device),
                                torch.zeros(len(values), dtype=index_dtype, device=device)
                                if column else torch.arange(len(values), dtype=index_dtype, device=device),
                                dense.flatten().to(device), size=shape, check_invariants=True,
                            )
                            check(csr, operation, dim, requested, expected, "promotion")

    for dtype in (torch.int8, torch.float32):
        for shape in ((0, 0), (0, 3), (3, 0), (3, 4)):
            for dim in ((0,), (1,), (0, 1)):
                result_shape = tuple(1 if axis in dim else size for axis, size in enumerate(shape))
                for requested in (None, dtype):
                    expected = torch.zeros(result_shape, dtype=output_dtype(dtype, requested))
                    for index_dtype in (torch.int32, torch.int64):
                        for device in ("cpu", "cuda"):
                            csr = torch.sparse_csr_tensor(
                                torch.zeros(shape[0] + 1, dtype=index_dtype, device=device),
                                torch.empty(0, dtype=index_dtype, device=device),
                                torch.empty(0, dtype=dtype, device=device),
                                size=shape, check_invariants=True,
                            )
                            for operation in operators:
                                check(csr, operation, dim, requested, expected, "empty")

    # CSR permits arbitrary value strides, unlike its index tensors. Poison
    # the skipped storage, including for stride zero, so pointer indexing has
    # a deterministic wrong answer without accessing outside the allocation.
    for dtype, _, _ in profiles:
        for value_stride in (0, 2):
            if value_stride == 2:
                data = ([False, True, True, True, True, False, False]
                        if dtype == torch.bool else [99, 2, 99, 3, 99, 5, 99])
            else:
                data = [False, True, True] if dtype == torch.bool else [2, 99, 99]
            for index_dtype in (torch.int32, torch.int64):
                for device in ("cpu", "cuda"):
                    storage = torch.tensor(data, dtype=dtype, device=device)
                    values = storage[1::2] if value_stride == 2 else storage[:1].expand(3)
                    for dim in ((0,), (1,), (0, 1)):
                        column = dim == (0,)
                        csr = torch.sparse_csr_tensor(
                            torch.arange(4, dtype=index_dtype, device=device) if column
                            else torch.tensor([0, 3], dtype=index_dtype, device=device),
                            torch.zeros(3, dtype=index_dtype, device=device) if column
                            else torch.arange(3, dtype=index_dtype, device=device),
                            values, size=(3, 1) if column else (1, 3), check_invariants=True,
                        )
                        assert csr.values().stride() == (value_stride,)
                        for operation in operators:
                            for requested in (None, dtype):
                                expected = getattr(values.cpu(), operation)(dtype=requested).reshape(1, 1)
                                check(csr, operation, dim, requested, expected, "strided-values")

    # Holes and an empty row/column must preserve stored-entry product
    # semantics, rather than multiplying the dense representation's zeros.
    for index_dtype in (torch.int32, torch.int64):
        for device in ("cpu", "cuda"):
            csr = torch.sparse_csr_tensor(
                torch.tensor([0, 2, 2, 3], dtype=index_dtype, device=device),
                torch.tensor([0, 2, 0], dtype=index_dtype, device=device),
                torch.tensor([2, 3, 5], dtype=torch.int8, device=device),
                size=(3, 4), check_invariants=True,
            )
            for operation, references in (
                ("sum", ([[7, 0, 3, 0]], [[5], [0], [5]], [[10]])),
                ("prod", ([[10, 0, 3, 0]], [[6], [0], [5]], [[30]])),
            ):
                for dim, expected in zip(((0,), (1,), (0, 1)), references):
                    check(csr, operation, dim, None, torch.tensor(expected), "masked-structure")
    return {"passed": all(case["passed"] for case in cases), "count": len(cases),
            "failures": sum(not case["passed"] for case in cases), "cases": cases}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("check", choices=("cpu-dot", "csr-promotion"))
    args = parser.parse_args()
    torch.set_num_threads(2)
    result = cpu_dot() if args.check == "cpu-dot" else csr_promotion()
    print(
        json.dumps(
            {
                "check": args.check,
                "torch": torch.__version__,
                "torch_path": torch.__file__,
                "cuda": torch.version.cuda,
                **result,
            },
            indent=2,
        )
    )
    raise SystemExit(0 if result["passed"] else 1)
