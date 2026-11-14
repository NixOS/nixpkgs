# CUDA integration validation

Package-owned tests are the permanent regressions. `rebuild.nix` selects a CUDA
release and platform pair for integration packages, public interfaces and
compiler regressions. Defaults are CUDA 13.4, an x86-64 builder, an AArch64 HOST
and SM 121a; `--arg cross false` selects native x86-64 and SM 89.

Use the existing Tribuchet hub's store so it schedules builds on its registered
workers. These examples select bounded targets before the full integration:

```sh
nix-build --store ssh-ng://nixos-ext \
  pkgs/development/cuda-modules/review/rebuild.nix \
  -A interfaces.cudnn-frontend
nix-build --store ssh-ng://nixos-ext \
  pkgs/development/cuda-modules/review/rebuild.nix \
  -A regressions.nvcc-cmake --arg cudaCapabilities '[ "8.9" ]'
nix-build --store ssh-ng://nixos-ext \
  pkgs/development/cuda-modules/review/rebuild.nix -A torch
```

Run `-A matrix.regressions` for both `--arg cross true` and `--arg cross false`,
with `--arg cudaCapabilities '[ "8.9" ]'` supported by both CUDA 12.9 and 13.4.
The matrix shares one Nixpkgs import. Run `-A matrix.interfaces` for both platform
pairs with their default capabilities; this includes NVPL CMake tests on
supported hosts and renamed component outputs. `--argstr release 12_9` selects
an individual release. Test groups retain named child tests.

Compilation, linking and installed execution are separate acceptance stages.
Cross-built programs must run on HOST; GPU tests require its real driver outside
the build sandbox. The supported production matrix is Linux x86-64 native and
x86-64→AArch64. Darwin, FreeBSD and MinGW evaluation or script controls do not
establish compiler execution. Three distinct platforms are rejected; this is not
Canadian-cross support.

## Recorded integration acceptance

The branch is based on upstream master `14ebaca18b41`, retaining upstream's
nvlink wrapper and CUDA 13.5 updates. The default integration fixture is CUDA 13.4.

Rebuilt GCC 16 and Clang 21 passed full wrapper and focused GNU/LLD regressions,
including Clang with libstdc++ and libc++. Native CUDA 12.9/13.4 and cross CUDA
13.4 runtime checks passed through Tribuchet. The LLVM 23 producer passed its
configured suite with the bounded exegesis backport enabled. The separate
Triton LLVM producer also passed its configured LLVM/MLIR suite; installed
controls exercised both ready and bounded no-sample behavior.

Fresh native and cross CUDA 13.4 production integration completed on
2026-11-14 through Tribuchet, including all 32 selected outputs. Installed
RTX 4090 and AArch64 GB10 checks passed package identity, CPU dot/CSR, C++/CUDA
extension JIT, GPU CSR and Triton AXPY. GB10 also passed FP8 rowwise numerical
checks. MAGMA passed GNU/Clang interfaces and dense (82 numerical rows) and sparse
(260 API checks) acceptance on each host.

The [wrapper design](../../../build-support/wrapper-common/README.md) records
mechanisms and limits; the [CC Wrapper contract](../../../../doc/stdenv/stdenv.chapter.md#cc-wrapper)
and [CUDA manual](../../../../doc/languages-frameworks/cuda.section.md) describe
selection and delegation. Generic observation refines link mode, not legacy
language/header interpretation. Unavailable observations, late changes reaching
unwrapped linkers, opaque compiler-policy response-file RPATHs and ambiguous
library selections retain the limits described in the design.

## nvlink notes and dependency roles

The upstream [nvlink wrapper](../packages/cuda_nvcc/README.md) replaces store
hashes in `.note.nv.tkinfo` after linking. It operates beside NVCC's backend/SDK
wrapper; CUDA 12 retains the upstream `nvvm/lib64` alias needed for device LTO.

`cudaPackages.tests.nvlink-notes` first checks BUILD NVCC's prefix is absent from
target `-L` arguments in a dry run, then checks recorded notes are scrubbed.
Sanitized notes alone cannot prove selection of the correct platform's resources.
The upstream `cudaPackages.cuda_nvcc.tests` also covers note cleanup, options
files, process behavior and direct nvlink use. Cross tests select BUILD's compiler
before embedding executable paths; local HOST overrides do not alter that BUILD
sibling. GPU execution is separate.

## Prior evidence and its limits

The [pre-rebase record at `e58dcdca81f2`](https://github.com/ConnorBaker/nixpkgs/blob/e58dcdca81f2830a83491cb3f1c9376924d07ddf/pkgs/development/cuda-modules/review/README.md)
retains exact-source build, installed execution and profiling results, plus
builder-specific skip rationale. Those artifacts preceded current compiler and
dependency-graph changes; they establish neither current production acceptance
nor current performance. Repeat matched profiling before making performance claims.

The bounded GNU header/runtime controls explain the header policy: GNU 15
headers with GNU 14's runtime failed localized C++20 chrono (`GLIBCXX_3.4.34`),
while matching GNU 14 providers passed. CUDA 12.9 rejected GNU 16's
`__builtin_ctzg`, while GNU 14 headers with GNU 16's runtime passed native/Spark
CCCL and C++20 checks. Both frontend and runtime constraints matter; release
ordering does not prove compatibility of arbitrary forks.

## Installed tests

Build `-A torch.tests.tester-cppExtension`, then run
`bin/tester-torch-cpp-extension` on HOST outside stdenv.
`TORCH_CUDA_ARCH_LIST=12.1a` selects Spark. Run Torch's
[cpu-dot.py](../../python-modules/torch/tests/cpu-dot.py) and
[csr-reductions.py](../../python-modules/torch/tests/csr-reductions.py) in the
installed Python environment. See [MAGMA's instructions](../../../by-name/ma/magma/tests/README.md)
for `runtime.py --suite dense|sparse` and [PyCUDA's instructions](../../python-modules/pycuda/README.md)
for managed-memory GPU checks.

External driver adapters should expose matching OS NVIDIA libraries, including
NVML where required, rather than an entire foreign distribution's library
directory. Use installed tools and a supported locale; numerical success does
not prove driver registration or transport behavior.
