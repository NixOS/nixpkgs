`managed-memory-test.py` requires a real NVIDIA GPU with managed-memory support
and a working driver. It uses the installed PyCUDA extension and its packaged
NVCC to compile and execute a small kernel. No stdenv setup hooks or compiler
on `PATH` are needed. The separate `passthru.tests.jit` test only compiles code
with a driver stub and does not exercise managed allocation or GPU execution.

For example, from the repository root on an SM 8.9 GPU:

```sh
pycudaEnv=$(nix build --impure --no-link --print-out-paths --expr '
  let
    pkgs = import ./. {
      config = {
        allowUnfree = true;
        cudaSupport = true;
        cudaCapabilities = [ "8.9" ];
      };
    };
  in pkgs.python3.withPackages (ps: [ ps.pycuda ])
')
env -i HOME="$HOME" TMPDIR="${TMPDIR:-/tmp}" PATH="$PATH" \
  LD_LIBRARY_PATH=/run/opengl-driver/lib \
  OMP_NUM_THREADS=2 OPENBLAS_NUM_THREADS=2 \
  "$pycudaEnv/bin/python" \
  pkgs/development/python-modules/pycuda/managed-memory-test.py --arch sm_89
```

Choose one capability and matching `--arch` for the GPU being tested. The driver
directory above is the NixOS location; on another system, use the directory
containing the real driver libraries, never the CUDA SDK stubs. To select another
release, replace `ps.pycuda` with, for example,
`(ps.pycuda.override { cudaPackages = pkgs.cudaPackages_12_9; })`. Cross-built
Python environments must be run on their HOST platform.

Each run checks all four managed-array APIs in C and Fortran order: defaults
and explicit `GLOBAL` allocations receive GPU updates, explicit `HOST`
allocations are checked on the CPU, and explicit zero flags must still fail.
GPU work is synchronized before inspecting or releasing its arrays. A successful
run prints JSON containing 32 checks; a missing GPU or unsupported allocation
fails instead of silently skipping.

The [CUDA review and archived acceptance evidence](../../cuda-modules/review/README.md)
covers CUDA 12.9 and 13.3, native x86_64 and cross-built AArch64 packages: 128
checks, including 64 GPU updates. This is a focused default-argument regression,
not exhaustive coverage of managed-memory migration or stream association.

`passthru.tests.curandBuffers` runs `curand-buffer-test.py` with the SDK driver
stub, without a GPU context. It checks the guarded direction-vector and scramble
table bindings: valid counts (including repetition beyond 20,000 entries),
rejected counts and buffer sizes, writable contiguous storage, untouched trailing
capacity, and release of Python buffer exports. Run this regression only against
the patched package; its rejected-input cases are not baseline reproductions.
