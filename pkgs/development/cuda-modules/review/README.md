# CUDA integration validation

Package-owned tests are the permanent regressions. The expressions and runtime
scripts here select those tests and exercise installed native/cross artifacts.
`rebuild.nix` selects a release and platform pair once for integration targets,
public interfaces, and compiler regressions. Its defaults are CUDA 13.3, an
x86-64 builder, an AArch64 host, and SM 121a; native builds default to SM 89.

```sh
# Select a package/interface or regression to keep the iteration short.
nix-build pkgs/development/cuda-modules/review/rebuild.nix \
  -A interfaces.cudnn-frontend \
  --builders 'ssh-ng://nixos-desktop x86_64-linux' --max-jobs 0
nix-build pkgs/development/cuda-modules/review/rebuild.nix \
  -A regressions.nvcc-cmake --arg cudaCapabilities '[ "8.9" ]' \
  --builders 'ssh-ng://nixos-desktop x86_64-linux' --max-jobs 0
# Full integration; use --arg cross false for native desktop artifacts.
nix-build pkgs/development/cuda-modules/review/rebuild.nix \
  -A torch --builders 'ssh-ng://nixos-desktop x86_64-linux' --max-jobs 0
```

For the full compile/link matrix, select `-A matrix.regressions` once for each
of `--arg cross true|false`, keeping `--arg cudaCapabilities '[ "8.9" ]'`
(supported by both toolkits). This shares one Nixpkgs import across CUDA 12.9
and 13.3. Run `-A matrix.interfaces` for both platform pairs with the default
machine-specific capabilities. This includes NVPL's package-owned CMake tests
on supported hosts, including renamed include/library outputs. For individual
selections, `--argstr release 12_9` changes the release. Test groups retain their
named child tests.

Cross builds check compilation and linking; installed programs must also run on
their target host. GPU execution requires a suitable machine outside the build
sandbox. Script regressions do not establish Darwin compiler correctness.

Adversarial review after rebasing onto master `cecfa8f6a07e` (2026-10-08):

- Master's deleted source TensorFlow recipe stays deleted. Combining the CUDA
  license migration with the cuBLASMp header test introduced a duplicate `lib`
  argument; fresh evaluation caught it and the argument was deduplicated.
- Fresh evaluation of the same 531 derivations and 547 outputs produces the
  same complete 5,751-object derivation graph, including raw derivation bytes.
  Previous execution evidence applies to those unchanged identities; this is
  not a new build or runtime run, nor coverage of arbitrary overrides.
- Unresolved: selecting cross GCC 14 with its explicit `gccForLibs` provider
  preserves that provider in the BUILD CUDA backend, but the installed HOST
  CUDA 13.3 backend selects GCC 15 with GCC 16's runtime. GNU `postStage` in
  `pkgs/stdenv/booter.nix` resets the compiler to the global default, and
  `backend.nix` now consumes that synthetic selection. The generated runtime
  library paths therefore disagree. Selection divergence is reproduced; an
  actual link/runtime failure has not been demonstrated. The compiler-runtime
  fixture currently exercises Clang provider preservation, not this GNU case.
- Unresolved: Torch registers its installed CSR regression runner only when
  BUILD can execute HOST, although constructing that runner requires no HOST
  execution. This omits the package-owned cross tester; manually running its
  source on HOST remains valid evidence.
- The wrapper interpretation limits are documented in the stdenv manual's
  CC Wrapper section. Selection laws do not prove operation classification or
  equivalence for opaque wrappers. Fresh shell controls verify Flang flag
  routing and role/policy transport, not real Flang or Darwin compilation.
- At least 44 files and 4,741 added lines concern independent numerical,
  ownership, initialization, and ancillary repairs rather than the cross
  selection abstraction. Their validation does not establish that this entire
  changeset is a minimal implementation of that abstraction.

See the [MAGMA test instructions](../../../by-name/ma/magma/tests/README.md) for
the single-file `runtime.py --suite dense|sparse` runner.
Build `-A torch.tests.tester-cppExtension` and run its
`bin/tester-torch-cpp-extension` on the matching GPU host to exercise installed
default CUDA dependency discovery outside stdenv. It defaults to the visible GPU;
`TORCH_CUDA_ARCH_LIST=12.1a` selects Spark's architecture explicitly.
Run Torch's [cpu-dot.py](../../python-modules/torch/tests/cpu-dot.py) and
[csr-reductions.py](../../python-modules/torch/tests/csr-reductions.py) directly
with the installed Python environment under review.

Evaluation profiling (2026-10-07) compared master `f5fce10d0ebd` with the
rebased implementation, including the cross-built GCC module repair and
Sphinx test-phase bytecode policy, native Clang header ordering, configured-target
lookup, and MPI language metadata.
It strictly evaluated NVCC, CUDART, and
`cuda.pkgs.magma` derivation paths with `NIX_SHOW_STATS=1`, `localSystem = "x86_64-linux"`, `cudaSupport = true`,
and `allowUnfree = allowBroken = true`. Allowing broken packages measures
evaluation only. Named selection was `cudaPackages_13_3`; default selection was
`cudaPackages`. Native used `crossSystem = null` and capabilities `[ "8.9" ]`;
cross used `"aarch64-linux"` and `[ "12.1a" ]` on both sides.

The final balanced control used five fresh processes per side and context,
shuffled contexts and ten adjacent pairs in each order (seed `20261007`). The
table reports CPU ranges and allocations, which were identical across each
context's repetitions.

| Selection | Master CPU range (s) | Branch CPU range (s) | Master allocated (MB) | Branch allocated (MB) |
| --- | ---: | ---: | ---: | ---: |
| Native, default | 0.199–0.211 | 0.199–0.221 | 73.33 | 73.62 |
| Native, named | 0.267–0.300 | 0.268–0.301 | 123.40 | 124.99 |
| Cross, default | 0.308–0.323 | 0.302–0.331 | 156.11 | 136.37 |
| Cross, named | 0.487–0.510 | 0.428–0.475 | 330.69 | 231.46 |

Cross allocation falls by 12.64% for default selection and 30.01% for named
selection; native allocation rises by 0.38% and 1.29%. CPU ranges overlap for
both native selections and default cross selection. CPU medians and paired differences
varied between the preceding controls, including their sign. Background work
and the narrow workload limit timing conclusions. Source-path allocation effects
were not isolated, so small shifts between controls cannot be attributed solely
to code changes. The workload forces a
transitive consumer but excludes Torch and full-tree traversal. Reproduce by
strictly evaluating `{ nvcc = cuda.cuda_nvcc.drvPath;
cudart = cuda.cuda_cudart.drvPath; magma = cuda.pkgs.magma.drvPath; }`
for each import and selection above.

A subsequent four-context probe after the MPI wrapper output repair retained
all selected derivations and evaluator operation counts. Allocated bytes changed
by only a few kilobytes between source paths. This single-process probe checks
the workload's continued applicability; it is not another balanced timing study.

Rebase validation started on 2026-10-07 against master `f5fce10d0ebd`,
selecting 531 distinct derivations and 547 outputs on `nixos-desktop`.
The selected domain is Linux x86-64 native and x86-64→AArch64 cross compilation;
Darwin script controls do not establish Darwin compiler or SDK correctness.

All 130 selected pkg-config regression labels have passed compilation/linking,
including their aggregate outputs. The aggregates' symlink inventories match
individually accepted children. Shared/static CMake interface checks are separate;
`pkg-config --static` coverage does not alone establish static archive linkage.
MPI's wrapper help catalogue moves with its sole consumer and wrapper data into
the development output. The four native/cross pkg-config variants pass, along
with ten matching-host programs and four disabled-language alias diagnostics.

Both fresh UCX completion controls use the repaired OpenMPI source and pass
4,200 lifecycle cases with 2,600 balanced constructions/destructions each.
These source controls do not establish installed MPI transport correctness.

Native installed MPI/NVSHMEM passed its two-rank floating-point, CUDA-buffer,
and one-PE device-ring checks. Default `smcuda` host registration reported an
error with its test backing files on ZFS; source explicitly logs and continues.
Numerical success does not establish successful pinning or transport efficiency.
The separate backing-file relocation control used tmpfs and passed without that
diagnostic. Cross installed MPI/NVSHMEM passed the same checks on Spark. Its
external driver adapter must expose the OS NVML library as well as CUDA: an
initial adapter omitted NVML, causing P2P discovery to fail. Adding that OS
driver library fixed the fixture without changing the package.

The ten installed NVCC runtime fixtures passed 190 host checks and 20 GPU checks
on RTX 4090 and GB10. These cover CUDA 12.9/13.3/13.4 with GNU C++ runtimes,
Clang 19/21 backends, and cross CUDA 13.3/13.4 with libc++ 21. Eight Clang rows
were rebuilt and rerun after the header-order repair; two unchanged GNU rows
retain their actual earlier execution records through complete dependency-graph
and raw-derivation identity checks. C++17/20 checks include ordinary
`string`/`iostream`, math results, and caller-library precedence. Installed shared
libraries, cubins, and PTX are inspected but are not executed as independent
numerical artifacts. The native x86-64 NVCC/libc++ restriction remains, and CUDA
12.9 with libc++ 21 remains broken for ordinary headers despite passing the
separate math corpus. Neither combination is counted as accepted general support.

Rebuilt ARM-hosted GCC 16 installs complete `std` and `std.compat` module sources.
Both actual importers compile, link, and pass their numerical and selected
libc/libstdc++ checks without extra module objects. Exported initializer existence
does not require an importer reference: GCC records whether a module has active
initialization. Source inspection and a positive dynamic-initialization control
confirmed this distinction after correcting an invalid test assertion.

LLVM 19 and 21's retained full regression suites passed 59,424 and 66,281 tests,
respectively, with no unexpected failures. Their complete producer dependencies
remain identical after the rebase followups. Triton's native LLVM 23 fork passed 48,626 tests, with 29,442 unsupported,
394 skipped, 71 expected failures, and no unexpected failures. Its cross
package disables the upstream suite. Clang keeps its normal disabled regression
suite; packaged compiler checks do not establish that suite's result.
Clang NNPACK passed 350,144 optimized cases and the same number with ASan/UBSan.
Both rebuilt Sphinx producers passed 2,358 tests with 36 configured skips each.

The Swift fork packaged as Clang 17 actually reports frontend 19.1.5. Its four
outputs build, but its upstream suite is disabled. Owner review retains inherited
bit-field warnings that truncate enum sentinels; supported driver values fit, but
this does not establish that every sentinel use is safe.

Git and Node's exact dependency derivations passed their suites on a private
task tmpfs after filesystem-specific filename failures on the builders' UTF-8-only
ZFS temporary directories. Those mounts were removed before ordinary builds
resumed. Node's inherited post-suite process-leak check could not find `ps`;
its functional suites passed, but that auxiliary check is not established.

Four fresh compiler-wrapper suites pass selected-provider and PowerPC ABI
preprocessing controls; these do not establish PowerPC linking or execution.

All 531 selected derivations and 547 outputs completed build/owner review.
Fresh installed production execution passed 11 groups on RTX 4090 and 13 on
GB10 after the MPI wrapper output repair. Each includes 24 CPU dot cases,
5,560 CSR reductions, cuBLAS/cuDNN/cuSOLVER checks, 946 indexing cases,
32 embedding cases, package-owned JIT compilation, CPU/CUDA Inductor,
SAXPY, and MAGMA's 82 dense numerical rows and 260 sparse checks. Spark adds
six FP8 cases and an SM120 kernel-dispatch observation. Both hosts also pass
204 mode cases each (192 numerical and 12 expected empty-reduction failures).
The native/cross socket helper passes seven checks per host; it does not
exercise socket or GPU operations. These bounded checks do not replace Torch's
disabled upstream suite or establish multi-node/GPU-aware UCX transport.

The external cross fixture requested `C.UTF-8`, unavailable to its installed
Bash/glibc, and emitted locale warnings. An installed-Bash control reproduces
them under `C.UTF-8` and runs cleanly under built-in `C`. Numerical/JIT execution
passed; these checks do not establish locale-archive installation. Owned runtime
work and driver adapters were removed after log/artifact review.
