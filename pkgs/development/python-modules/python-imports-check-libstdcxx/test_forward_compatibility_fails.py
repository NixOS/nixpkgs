"""
TODO: explain why we want this to fail and how
"""

import os
import sys

assert (
    "EXPECTED_LIBSTDCXX" in os.environ
), "The derivation failed to export EXPECTED_LIBSTDCXX"

expected_libstdcxx_root = os.environ["EXPECTED_LIBSTDCXX"]

import load_libstdcxx_old
import psutil

try:
    import load_libstdcxx_new
except ImportError:
    print(f"python-imports-check-load-libstdcxx successfuly fails", file=sys.stderr)
    sys.exit(0)
print(
    "python-imports-check-load-libstdcxx doesn't fail the naive forward"
    " compatibility test, it probably needs to be updated.",
    file=sys.stderr,
)

loaded_libraries = [x.path for x in psutil.Process(os.getpid()).memory_maps()]
loaded_libraries = [x for x in loaded_libraries if "libstdc++" in x]

assert loaded_libraries, "Didn't load either version of libstdc++"

assert all(x.startswith(expected_libstdcxx_root) for x in loaded_libraries), (
    "The python interpreter didn't load the old version of libstdc++:"
    f" {loaded_libraries=}. Expected one from {expected_libstdcxx_root}"
)

print(
    "The python interpreter has correctly loaded the old version of"
    f" libstdc++ as expected: {loaded_libraries}",
    file=sys.stderr,
)
sys.exit(1)
