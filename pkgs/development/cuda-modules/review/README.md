# CUDA role, cross-build, and installed-interface review

The implementation uses Nixpkgs dependency roles and existing output selectors.
Named CUDA scopes preserve automatic transitive release selection through a
shared package graph per originating context. Runtime compilers are selected
for HOST/HOST before nested compiler attributes are projected. No shared
cc-wrapper, bintools-wrapper, or stdenv setup hook was added.

The complete historical audit, negative controls, exact derivation identities,
source hashes, profiling results and machine-specific evidence are preserved
on local branch `review/cuda-545092-20260916`, commit `70043ec2a10b38e62bd695f02ed0c71166a2661e`.
They were moved out of the implementation diff, not discarded. For example:

```sh
git show review/cuda-545092-20260916:pkgs/development/cuda-modules/review/README.md
git ls-tree -r --name-only review/cuda-545092-20260916 -- pkgs/development/cuda-modules/review
```

## Repairs and validation

| Area | Result and validation scope |
| --- | --- |
| Scope/stage construction | Generic stage tests pass; 60 foundational native/cross derivations retain master identities. NIX_SHOW_STATS traces remain in the audit branch. |
| NVCC roles, outputs, JIT, CMake discovery | Four CUDA 12.9/13.3 native/cross contexts cover declared output mappings, caller flag precedence, standalone compiler use and CXX-only toolkit discovery. Final NVCC subset: 20 builds pass. CUDA 13.3 SAXPY runs with zero error on RTX 4090 and cross-built GB10/SM 121a. |
| Compatibility archives | Exact-minor selection precedes major fallback. All six restored CUDA 13.1/13.2/13.3 native/cross packages and 16 selection fixtures build. Commit `91116f64e2b9` isolates this repair. |
| pkg-config | 400 installed entries across 299 output roots inspected; 116 isolated compile/link consumers, 195 archive repair controls, and merged metadata queries pass. Ordinary `--static` queries do not establish completeness of NVIDIA's separately named static archives. |
| NVPL exports | Seven split-output search repairs, 18 discovery tests and 14 actual AArch64 links pass. |
| CUTLASS | Actual 12.9/13.3 native/cross packages, including default Python wheels, and four installed consumers pass. Public CUDA usage is exported through CUDA::toolkit. |
| Public headers | CUPTI, cuDNN, cuSPARSELt, cuBLASMp, cuSOLVERMp, cuTENSOR and cuQuantum propagate their public dependencies. All 28 native/cross consumers pass; 28 missing-provider controls fail and 28 declared-provider controls pass. Driver stubs are confined to test-only link-time lookup and do not enter runtime paths. |
| cuDSS | Public toolkit headers and the static runtime closure are exported. Both CUDA 12.9 native/cross shared and static imported-target consumers pass clean compilation/linkage and empty-environment version queries on desktop and Spark. |
| NVSHMEM | Public CUDA/CCCL dependencies and config-version discovery repaired without changing private static-runtime linkage. All four 12.9/13.3 native/cross producers and consumers pass, including version acceptance/rejection, host/device linkage and host API execution on desktop and Spark. |
| cuDNN frontend | Public CUDA, cuDNN, NVRTC and optional JSON dependencies exported; source-directory leakage removed. All eight 12.9/13.3 native/cross consumers pass, covering JSON enabled and disabled, installed exports and empty-environment version queries on desktop and Spark. Optional/missing dependency and retry controls pass. |
| Torch/Triton/MAGMA/MPI integration | Earlier full native and cross builds, installed metadata/wheels, CPU numerics and GPU/JIT workloads passed on RTX 4090 and GB10. Exact older artifacts are retained in the audit. Subsequent metadata, LLVM and NNPACK edits have focused validation; a full final-source integration rebuild is not claimed. |
| CSR reductions | Native and CUDA integer promotion, explicit result dtype, accumulator width, value strides and empty results repaired. Both native and cross-built artifacts pass numerical controls. Permanent Torch regression included. |
| LLVM initial state | Actual affected translation units compile without the reproduced initialization warnings; focused iterator/value/SFrame runtime controls pass. No full LLVM rebuild after this patch. |
| NNPACK contracts | Flat storage and valid pointer/alias contracts preserve arithmetic. GCC and Clang optimized/sanitized AArch64 runs each pass 350144 cases; unpatched source fails the pointer guard. The permanent x86_64 Nix regression also passes optimized and ASan/UBSan runs, each with 350144 cases and no object-size diagnostics. |

The final installed-interface/source-test batch realizes all 47 exact goals on
`nixos-desktop`. Formatting, shell syntax, Python parsing and patch syntax checks
also pass. The archived acceptance record includes exact outputs and source hashes.

## Reproduction

Run from the repository root. These expressions select ordinary packages and
retain default compatibility-driver selection. Integration and interface builds
use one capability: SM 89 on desktop, SM 121a for the AArch64 Spark. The smaller
compile/link regression matrix uses SM 89 for both roles.
`cudaForwardCompat = false` controls PTX policy; it does not disable `cuda_compat`.

```sh
# Installed public interfaces; select individual attributes to shorten a run.
nix-build pkgs/development/cuda-modules/review/interface-matrix.nix \
  -A cross.13_3.cudnn-frontend --builders 'ssh-ng://nixos-desktop x86_64-linux' --max-jobs 0
nix-build pkgs/development/cuda-modules/review/interface-matrix.nix \
  -A cross.12_9.cudss \
  --builders 'ssh-ng://nixos-desktop x86_64-linux' --max-jobs 0

# Wrapper, role, output, scope and fortify regressions.
nix-build pkgs/development/cuda-modules/review/regression-matrix.nix \
  -A cross.13_3.nvcc-cmake --builders 'ssh-ng://nixos-desktop x86_64-linux' --max-jobs 0

# Full integration targets: torch, magma, mpi, nvshmem, saxpy, runtime.
nix-build pkgs/development/cuda-modules/review/rebuild.nix \
  -A torch --builders 'ssh-ng://nixos-desktop x86_64-linux' --max-jobs 0
# Add --arg cross false for native desktop artifacts.
```

Package-owned tests are the primary regressions. `torch.tests.nnpackPSIMD`
tests pinned vendored sources without building Torch; its instructions are in
`../../python-modules/torch/tests/nnpack-psimd.md`. The retained runtime scripts
exercise already installed artifacts and record numerical results. GPU execution
requires a compatible machine outside the ordinary sandbox.

## Explicit limits

The consumer tests establish headers, discovery and linkage, not exhaustive API
or GPU numerical correctness. NVSHMEM's device consumer is linked, not executed.
Both NVSHMEM releases are built for native and cross roles.
Frontend interface builds disable samples/tests and cover JSON both on and off.
A full Clang/libc++ Torch stack, every optional backend and all architectures are
not covered.

No blanket warning suppression was added. ORC ownership refutes the specific
reported null-load path, not arbitrary JIT concurrency safety. Other retained
limits include compiler-internal discarded-instantiation warnings and Torch
ABI consistency under arbitrary CPU tuning. Inherited libtool target-ldconfig
finishing diagnostics and Boost disabled-MPI alias diagnostics are separate
owner issues; shared toolchain changes remain outside this CUDA rewrite.

Graph sharing is contextual, not a global cache by release: repeated release
switching through already rebound graphs can allocate more graphs. The audit
records the measured costs and why a release-only cache would change semantics.

The interface matrix shares its two primary imports across release selections.
A NIX_SHOW_STATS comparison preserved all 46 interface derivations while reducing
value allocation from 231,568,464 to 197,848,352 bytes; the single timing sample
was slower and does not establish a speedup.
