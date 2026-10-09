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

Validation is tied to an exact source and dependency graph. Earlier successful
builds do not establish execution of a changed wrapper or compiler producer.
The full matrix is Linux x86-64 native and x86-64→AArch64 cross compilation.
Darwin, FreeBSD and MinGW evaluation or script controls do not establish target
compiler execution. The stage projection rejects three distinct platforms; it
is not Canadian-cross support.

## Current validation

The fresh native SM 89 and AArch64 SM 121a Torch/MAGMA builds started on
nixos-desktop on 2026-10-08 select commit `9071eb53077f`. Subsequent native-stage,
compiler-projection and GNU header-selection fixes preserve their four production
derivations and fourteen outputs. The dynamic-loader repair and native compiler
query integration change core dependencies and require separate full builds.
Acceptance of those current changes remains pending.

The native adapter review found composition defects.
Flattening caller response files can promote their quoting selectors into the
outer native lexer: identical flattened arguments can represent different
requests. The replacement carries raw argument groups to the native interpreter;
explicit caller frontend entry retains its standalone lexical context. Bounded
driver and wrapper checks pass; rebuilt producers remain pending.
Opaque link policy and late hooks can select static PIE after the
wrapper inferred a dynamic link, producing an unwanted interpreter and RUNPATH
and a program that crashes. Native linker prototypes preserve policy origin and
interpret defaults after final link-mode selection; end-to-end compiler and
linker integration remains pending. Neither is established by earlier suites.
Purity and no-native enforcement must retain caller provenance through native
scoped translation and frontend forwarding; those paths remain under review.

Package-owned regressions are the acceptance interface. Run the wrapper suites
with actual GCC, Clang/libstdc++ and Clang/libc++ producers, then the CUDA matrix,
installed JIT consumers, and numerical tests. A wrapper constructor over cached
raw dependencies or a driver linked to a cached frontend is a bounded adapter
check, not a rebuilt producer or production package.

The [CC Wrapper contract](../../../../doc/stdenv/stdenv.chapter.md#cc-wrapper)
and [CUDA scope documentation](../../../../doc/languages-frameworks/cuda.section.md)
state selection and delegation semantics. The selection homomorphism does not
prove native operation classification, header lookup, or arbitrary executable
transparency. Read the applicable native parser and each consumer's interface;
compiler-driver, libclang-driver and frontend-only consumers are distinct.

Adversarial controls that constrain the implementation include option-shaped
operands, options in generic compile channels, response-file boundaries and
mutations, explicit frontend entry, conditional-policy cycles, native config and
spec resources, output/logging effects, and a final linker reached after primary
policy omitted its main flags. Default headers must preserve native language,
suppression, search-group order, classification and `#include_next` observations.
These controls refuted earlier shell classifiers and query prototypes; successful
SAXPY alone did not establish their semantics.

GNU 15 headers with a selected GNU 14 runtime fail localized C++20 chrono
formatting because that runtime lacks `GLIBCXX_3.4.34` helpers. Matching GNU 14
headers/runtime pass native and emulated ARM checks. Conversely, CUDA 12.9's
frontend rejects GNU 16's `__builtin_ctzg`; GNU 14 headers with the GNU 16 runtime
pass the same native/Spark CCCL and C++20 tests. The bounded GNU header policy
therefore considers both frontend and runtime constraints. Release ordering and
upstream backward library compatibility do not prove compatibility for arbitrary
forks or altered version metadata.

## Earlier production acceptance

The prior graph rebased onto master `f5fce10d0ebd` completed 531 selected
derivations and 547 outputs. The later rebase onto `cecfa8f6a07e` initially retained
its complete 5,751-object derivation graph, including raw derivation bytes.
The subsequent core review fixes invalidate that identity argument. Results
below describe the earlier artifacts, not acceptance of current changed producers.

- All 130 pkg-config regression labels compiled and linked, including aggregate
  inventories. Shared/static CMake checks are separate: `pkg-config --static`
  alone does not establish static archive linkage. MPI's four pkg-config
  variants, ten host programs and four disabled-language diagnostics passed.
- Fresh installed execution passed 11 groups on RTX 4090 and 13 on GB10:
  CPU dot, 5,560 CSR reductions, cuBLAS/cuDNN/cuSOLVER, indexing, embedding,
  installed C++/CUDA JIT, CPU/CUDA Inductor, SAXPY and MAGMA dense/sparse checks.
  Spark additionally exercised FP8 and SM120 dispatch. Package-owned runners
  expose CSR CPU checks for cross and CPU-only Torch without automatically
  executing an incompatible HOST binary on BUILD.
- Ten installed NVCC fixtures passed 190 host and twenty GPU checks across
  CUDA 12.9/13.3/13.4, GNU runtimes, Clang 19/21 and cross libc++ 21. Shared
  libraries, cubins and PTX were inspected, not separately executed as numerical
  artifacts. Native x86-64 NVCC/libc++ and CUDA 12.9 with libc++ 21 remain marked
  broken; passing the separate math corpus does not establish ordinary headers.
- Native and cross MPI/NVSHMEM passed two-rank floating-point/CUDA-buffer and
  one-PE device-ring checks. UCX source controls passed 4,200 lifecycle cases
  with balanced ownership. Neither establishes multi-node GPU-aware transport.
  Default `smcuda` host registration logged an error with backing files on ZFS;
  tmpfs relocation removed it. Numerical success does not prove pinning or
  transport efficiency. The external Spark driver adapter must expose NVML as
  well as CUDA.
- LLVM 19/21 retained suites passed 59,424/66,281 tests without unexpected
  failures; Triton's native LLVM fork passed 48,626. Clang's own suite remains
  disabled. NNPACK passed 350,144 optimized and 350,144 ASan/UBSan cases. Both
  Sphinx producers passed 2,358 tests with 36 configured skips.
- Rebuilt ARM-hosted GCC 16's `std` and `std.compat` importers compiled, linked
  and executed. The Swift fork labelled Clang 17 reports frontend 19.1.5; its
  outputs built, but its upstream suite is disabled. Inherited bit-field enum
  sentinel truncation warnings remain; supported values fitting those fields
  do not prove every sentinel use safe.

For installed tests, build `-A torch.tests.tester-cppExtension` and run
`bin/tester-torch-cpp-extension` on the matching GPU host, outside stdenv.
`TORCH_CUDA_ARCH_LIST=12.1a` selects Spark explicitly. Run Torch's
[cpu-dot.py](../../python-modules/torch/tests/cpu-dot.py) and
[csr-reductions.py](../../python-modules/torch/tests/csr-reductions.py) with the
installed Python environment under review. See [MAGMA's test instructions](../../../by-name/ma/magma/tests/README.md)
for `runtime.py --suite dense|sparse`.

External driver adapters should expose the matching OS NVIDIA libraries, not
an entire foreign distribution's library directory. Use the installed tools and
a locale they support. The earlier cross fixture's `C.UTF-8` warning reproduces
in its installed Bash/glibc; built-in `C` is clean. This does not establish locale
archive installation. Git/Node suites needed a private tmpfs after filename
failures on the builders' UTF-8-only ZFS temporary directories. Node's inherited
post-suite process-leak check could not find `ps`; that auxiliary check is not
established by passing functional tests.

## Evaluation profiling

Profiles force public derivation paths; they do not measure compilation or imply
equivalent derivations across different implementations. The reproducible workload
is `{ nvcc = cuda.cuda_nvcc.drvPath; cudart = cuda.cuda_cudart.drvPath;
magma = cuda.pkgs.magma.drvPath; }`, with `NIX_SHOW_STATS=1`,
`localSystem = "x86_64-linux"`, `cudaSupport = true`, and
`allowUnfree = allowBroken = true`. Default selection is `cudaPackages`; named
selection is `cudaPackages_13_3`. Native uses capabilities `[ "8.9" ]`; cross
uses `crossSystem = "aarch64-linux"` and `[ "12.1a" ]`.

The balanced 2026-10-07 control compared master `f5fce10d0ebd` with the rebased
implementation: five fresh processes per side/context, shuffled contexts and
adjacent pairs in each order (seed `20261007`).

| Selection | Master CPU range (s) | Branch CPU range (s) | Master allocated (MB) | Branch allocated (MB) |
| --- | ---: | ---: | ---: | ---: |
| Native, default | 0.199–0.211 | 0.199–0.221 | 73.33 | 73.62 |
| Native, named | 0.267–0.300 | 0.268–0.301 | 123.40 | 124.99 |
| Cross, default | 0.308–0.323 | 0.302–0.331 | 156.11 | 136.37 |
| Cross, named | 0.487–0.510 | 0.428–0.475 | 330.69 | 231.46 |

This workload excludes Torch and full-tree traversal; small CPU differences and
source-path allocation effects were not isolated. A later matched nine-context
compiler workload against pre-review source, with three alternating repetitions,
measured original-selection projection at +1.72% allocation and +4.11% median
CPU (1.259/1.311 s), with overlapping wall-time ranges. Correct selection costs
evaluation; this is not a speedup.

Forced-import tracing found one graph for default CUDA scopes and two for a named
scope shared across three cross roles, versus master's four named graphs. That
workload allocated 249.4/531.7 MB with median CPU 0.469/1.012 s (branch/master),
with different derivations. Additional configuration/restricted-library caches
saved under 0.3% allocation without stable CPU benefit and were rejected.
These historical figures require a new matched comparison after core integration.

A 2026-10-09 matched workload forced fifteen ordinary compiler, CUDA, MPI,
Torch/MAGMA, Triton and PyCUDA derivation/output records, with three alternating
pairs per platform. Comparing `cecfa8f6a07e` with committed `4bd11bba08c9`, native
allocation increased 0.924% and cross allocation decreased 20.946%; all fifteen
derivations changed on each platform. Both sides allowed broken metadata because
master marks MAGMA broken. These whole-branch figures neither isolate scope costs
nor validate the pending core integration; noisy CPU results establish no speedup.
