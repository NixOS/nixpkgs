# CUDA integration validation

Package-owned tests are the permanent regressions. The expressions and runtime
scripts here select those tests and exercise installed native/cross artifacts.
`rebuild.nix` selects a release and platform pair once for integration targets,
public interfaces, and compiler regressions. Its defaults are CUDA 13.4, an
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
and 13.4. Run `-A matrix.interfaces` for both platform pairs with the default
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

On 2026-10-22 the branch was rebased onto master `768f83d0d106`. Master had
moved to CUDA 13.4 by default, Torch 2.14.1 (built with scikit-build-core rather
than `setup.py`), Triton 3.8.0 and a triton-lang LLVM fork. The rebase leaves
the default x86-64 `stdenv` unchanged (`gcc-wrapper-16.2.0` keeps its
derivation), so its earlier GCC and stdenv builds still apply; everything
depending on CUDA, Torch or Triton changed.

Porting to that master:

- Torch: `cmake-args.patch`, `python-extension-suffix.patch` and
  `wheel-tensorpipe-metadata.patch` served only `setup.py`'s build and were
  dropped. scikit-build-core's hook passes `cmakeFlags`, the wheel holds what
  CMake installs, and an extension named `_C.so` still imports. Master's ATen
  include fix replaces the branch's `ATenConfig.cmake.in` substitution.
  `async-mm-eligibility`, `cpp-extension-dependency-paths`, `disable-cross-lwyu`,
  `sparse-csr-reduction-dtypes` and `symmetric-memory-socket-path` were
  regenerated for 2.14.1; upstream had fixed none of them.
- Triton 3.8.0 compiles a GSan device runtime with the `clang++` in
  `LLVM_SYSPATH`, which is HOST's LLVM in a cross build; cross builds pass
  BUILD's.
- The Triton LLVM fork still takes the shared initialization patches. They now
  reach it through `llvmPackages_23.llvm.initializationPatches`, because
  nixpkgs-vet rejects a by-name package referring to files outside its
  directory.
- `cuda_cudart`: CUDA 13.4's `cuda.pc` made the stub search path
  `lib/stubs/stubs`, and `tests.pkg-config.cuda` failed with `cannot find
  -lcuda`. The branch carries the fix proposed for master in #577528.

Rebuilding after the rebase found three branch defects, all fixed:

- The stage projection in `booter.nix` re-creates the HOST compiler from its
  original constructor and adapts that constructor's `stdenvNoCC` with
  `cross/adapt-stdenv.nix`. For an AArch64 HOST the adapter adds BUILD's
  `updateAutotoolsGnuConfigScriptsHook`, but the adapted stdenv kept the native
  final stage's `allowedRequisites`, which name the bootstrap's `gnu-config`.
  The projected compiler (`pkgsHostHost.targetPackages.stdenv.cc`) failed with
  `stdenv-linux-no-cc` "is not allowed to refer to" BUILD's `gnu-config`, and so
  did the cross packages that record it: Torch, PMIx and Open MPI. Changing
  HOST now clears the allowlist in `adapt-stdenv.nix`; the native and ordinary
  cross stdenv derivations are unchanged.
- Torch's bundled libuv takes two upstream fixes through `fetchpatch`. Their
  recorded hashes did not match the normalized patches GitHub serves. Neither
  old output was in the local or builder store, so there is no evidence they
  ever matched.
- Master's NVSHMEM 3.8.0 adds a host ABI test that demangles the built
  libraries' symbols with a `c++filt` found by an unprefixed `find_program`.
  Cross bintools install only `aarch64-unknown-linux-gnu-c++filt`, so the cross
  build stopped at configure. The package now carries the patch proposed
  upstream in NVIDIA/nvshmem#130, which first looks for `c++filt` with the
  prefix and directory of the `nm` CMake found from the compiler.

The branch's x86-64 packages cannot be substituted from cache.nixos.org, and two
upstream test suites failed on the builders behind `ssh-ng://nixos-ext`. The
branch skips the failing cases; both packages then pass there:

- elfutils 0.195's `run-sysroot.sh` failed for master's derivation as well. The
  builders are Tribuchet agents, systemd units with `DynamicUser=yes`, which
  forces `RestrictSUIDSGID=yes`. systemd cannot inspect `openat2`'s flags, so
  that filter returns `ENOSYS` for every `openat2` call, while the test chooses
  its `RESOLVE_IN_ROOT` case from `uname -r` alone. libdwfl falls back to
  `open`, which follows the sysroot's absolute symlink out of the sysroot. The
  branch keeps the test's plain `--sysroot` check.
- git's `t0050-filesystem.sh` and `t7527-builtin-fsmonitor.sh` ("Unicode
  nfc/nfd") fail in nixos-desktop's build directories, which are ZFS datasets
  with `normalization=formD`; the package already disables two tests for that.

A per-build `build-dir` on tmpfs could not avoid the second: neither the build
hook nor `--store ssh-ng://nixos-desktop` delivered client settings to the
build there (even `builders ''` was ignored), for reasons not yet found.

The CI failures on the previous head are fixed: cudnn-frontend's CMake consumer
moved to `cudaPackages.tests.cudnn-frontend.cmake`, because `passthru.tests` hid
the package's `tests` output; cc-wrapper and bintools-wrapper no longer inherit
a `meta.outputsToInstall` naming documentation outputs they lack without
`propagateDoc` (the native-tool wrapper in the cc-wrapper tests hit this under
CI's meta checks; the first failure had hidden it); formatting; nixpkgs-vet.
`nix-build ci -A eval.baseline` for x86_64-linux and aarch64-linux and
`ci/nixpkgs-vet.sh master` pass locally.

Built after these fixes (2026-10-23, CUDA 13.4, x86-64 builders behind
`ssh-ng://nixos-ext`). NVSHMEM and `torchPatches` were built on master
`86621d458260`; the branch is now on master `f8ca7dae3933`, where every
derivation below, and the native and cross `stdenv`, is identical:

- `-A regressions --argstr release 13_4` with the default capabilities: all 64
  native (SM 89) and 63 cross (SM 121a) targets.
- `-A torchPatches`, native and cross, which runs only Torch 2.14.1's
  `unpackPhase` and `patchPhase`: every patch and `postPatch` applies.
- `-A interfaces.nvshmem`, native and cross, which builds NVSHMEM, Open MPI,
  UCX and UCC.

Not rebuilt: complete Torch, MAGMA and Triton builds and their installed or GPU
checks; CUDA 12.9; the rest of `matrix.interfaces`; the wrapper suites' supported
matrix. Whether Tensorpipe's installed CMake metadata is correct under
scikit-build-core is unchecked.

The native adapter review found composition defects.
Flattening caller response files can promote their quoting selectors into the
outer native lexer: identical flattened arguments can represent different
requests. The replacement carries raw argument groups to the native interpreter;
explicit caller frontend entry retains its standalone lexical context. Bounded
driver and wrapper checks pass; rebuilt producers remain pending.
Opaque link policy and late hooks can select static PIE after the
wrapper inferred a dynamic link, producing an unwanted interpreter and RUNPATH
and a program that crashes. The ld-wrapper now classifies the output from the
final linker arguments and removes that policy. Links that reach an unwrapped
linker are an accepted limit; see the
[wrapper design](../../../build-support/wrapper-common/README.md#link-mode-policy-at-the-linker).
The fix passes bounded wrapper checks over cached toolchains; rebuilt producers
remain pending.
Earlier suites covered neither issue. The cc-wrapper suite now covers static and
static-PIE modes selected through opaque link flags.
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

## Paths nvlink records

nvlink writes its command line, including every `-L` directory, into the
`.note.nv.tkinfo` section of each cubin, and NVCC embeds those cubins in the
linked program. CUDA 13 writes the note for every architecture. Two `-rdc` files
linked with CUDA 13.4, with `libffi` as an unlinked build input (2026-10-22,
branch `46d8cab80bbd` and its master base `24ef39abb78b`):

| | master | branch, native | branch, x86-64 to AArch64 |
| --- | --- | --- | --- |
| Directories nvlink records | `cuda_nvcc`'s `lib`, `lib/stubs` and `nvvm/lib`; the first two do not exist | `cuda_cudart`'s `lib` and `lib/stubs`, `libffi`, glibc | the same, all AArch64 |
| References, uncompressed fatbin | `cuda_nvcc` | `cuda_cudart`, `libffi` | AArch64 `cuda_cudart`, `libffi` |
| References, compressed fatbin | `cuda_nvcc` (not compressed; see below) | none | none |

- The branch's `nvcc.profile` points nvlink at the target `cuda_cudart`, which
  removes master's `cuda_nvcc` reference and lets `-rdc -dlto` find
  `libcudadevrt`. On master that link fails with `nvlink fatal: expected
  libcudadevrt object` unless the build passes `-L` itself.
- The wrapper forwards every HOST dependency's library directory to nvlink, and
  nvlink records them. Compression hides them from Nix's reference scanner but
  not from the program, so reference checks read the notes with `cuobjdump`.
- `-dlto` passes `-nvvmpath` naming BUILD's `cuda_nvcc`. In this probe the final
  cubin carried only ptxas's note.
- Master has not compressed fatbins since 4153e8f02f3f (2024-06-12): its hook
  appends to `NVCC_PREPEND_FLAGS` with `appendToVar`, which does not export it,
  so NVCC sees the flag only when the caller already exported the variable
  (`.nv_fatbin` of 0x13b8 bytes, or 0x4d0 with the variable exported). The
  branch's wrapper passes the flag itself (0x1538 bytes uncompressed, 0x520
  compressed; its notes record more directories).

`cudaPackages.tests.nvlink-notes` keeps the invariant that matters for cross
builds: a relocatable device link records no path from BUILD's `cuda_nvcc`. It
saves the notes of a plain and an LTO link in its `notes` output.

Related pull requests:

- #574566 wraps nvlink to blank the store hashes in these notes. It conflicts
  with this branch in `cuda_nvcc/package.nix` (both move `cuda_nvcc.nix` into a
  directory), `nccl.nix` and `gdrcopy.nix`. Its tests take `cuda_nvcc` unspliced;
  after rebasing onto it, they need BUILD's `cuda_nvcc`.
- #574119 links NVVM's `lib64` to `lib` before CUDA 13 and conflicts with this
  branch's move of `cuda_nvcc.nix`.
- #577528 is the `cuda.pc` fix carried here.
- #577950 backports cudnn-frontend's fix for a crash at process exit
  (NVIDIA/cudnn-frontend#1565). It adds to the cudnn-frontend `patches` list
  that this branch also changes, so whichever merges second needs a rebase.
- #467976 (deferred) writes `-L` entries into `cuda_nvcc`'s own directories.

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
pairs per platform. Comparing fetched master `c1ca1da56d31` with the branch
checkpoint ending at "cc-wrapper: retain raw requests and publish native importer
bindings", native allocation increased 1.710% and cross allocation decreased
20.396%; all fifteen derivations changed on each platform. Both sides allowed
broken metadata because master marks MAGMA broken. These whole-branch figures
neither isolate scope costs nor validate the pending core integration; noisy CPU
results establish no speedup. They predate the 2026-10-13 rebase onto master
`d78be45c53e8` and require a new matched comparison.
