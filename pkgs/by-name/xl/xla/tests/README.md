# Installed XLA regression suites

Use the selected package's `passthru.tests` and `passthru.testers`, following
[the CUDA testing convention](../../../../../doc/languages-frameworks/cuda.section.md).
`tests` execute suites in derivations; `testers` build executables containing the
same suites (`meta.mainProgram` is set). Building a tester alone is not a
successful test run. These are package-local development interfaces, not stable APIs.

## Commands (from the nixpkgs root)

Evaluate the package and test contracts, including free-only discovery:

```sh
nix-instantiate --eval --strict pkgs/by-name/xl/xla/tests/eval.nix --arg nixpkgs ./.
```

Run CPU-only checks:

```sh
nix-build --no-out-link --expr '
  let x = (import ./. {}).xla.override { cudaSupport = false; };
  in [ x.tests.cpu x.tests.hlo x.tests.install x.tests.metadata ]
'
```

Run the CUDA package's hardware-free installed-output checks, including its CPU
plugin:

```sh
nix-build --no-out-link --expr '
  let x = (import ./. { config.allowUnfree = true; }).xla.override { cudaSupport = true; };
  in [ x.tests.cpu x.tests.cuda.install x.tests.cuda.metadata ]
'
```

Run hardware-free CUDA build-configuration checks for default and custom
capabilities:

```sh
nix-build --no-out-link --expr '
  let
    check = config: ((import ./. {
      config = { allowUnfree = true; } // config;
    }).xla.override { cudaSupport = true; }).tests.cuda.configure;
  in [
    (check {})
    (check { cudaCapabilities = [ "8.0" "8.9" ]; cudaForwardCompat = false; })
    ((import ./. { config.allowUnfree = true; }).xla.override {
      cudaSupport = true;
    }).tests.cuda.configureOverride
  ]
'
```

These checks share the dependency archive but independently regenerate
`local_config_cuda`, resolve `local_config_nccl` aliases through the selected NCCL
output, and verify recorded architectures and exact SASS/PTX flags. They compile
one CUDA translation unit with packaged NVCC, pinned Clang 18.1.8, and pinned CCCL
3.2.0. `configureOverride` modifies selected NVCC and NCCL outputs and verifies
that both sentinel headers reach the generated repositories; the NVCC sentinel is
also consumed by the compiler. The checks require `big-parallel`, substantial
working storage, and may build selected NCCL, but do not require a GPU or compile XLA.

The lightweight checker uses only Python and synthetic repository fixtures:

```sh
nix-build --no-out-link --expr '
  ((import ./. { config.allowUnfree = true; }).xla.override { cudaSupport = true; }).tests.cuda.configureChecker
'
```

Run GPU-host checks only on a builder advertising `cuda` and exposing a supported
NVIDIA GPU and matching host driver:

```sh
nix-build --no-out-link --expr '
  let x = (import ./. { config.allowUnfree = true; }).xla.override { cudaSupport = true; };
  in [ x.tests.cuda.pjrt x.tests.cuda.nccl x.tests.cuda.hlo ]
'
```

For an interactive run of the same PJRT suite, select its tester:

```sh
tester=$(nix-build --no-out-link --expr '
  ((import ./. { config.allowUnfree = true; }).xla.override { cudaSupport = true; }).testers.cuda.pjrt
')
"$tester/bin/xla-pjrt-cuda" "$PWD/pjrt-logs"
```

Executable suites accept an optional log directory; test derivations retain logs
in their output. Metadata checks are evaluation assertions rather than runtime
suites. CUDA attributes are nested and empty for CPU-only packages so free-only
test discovery does not evaluate unfree packages.

## CUDA configuration and overrides

`config.cudaCapabilities` and `config.cudaForwardCompat` are resolved through the
selected `cudaPackages.flags`. For example, `[ "8.0" "8.9" ]` produces
`sm_80,compute_89` with forward compatibility and `sm_80,sm_89` without it.
`compute_*` emits SASS and PTX; only the final configured capability receives PTX.
Repeated rendered architectures are deduplicated in insertion order. This XLA pin
accepts accelerated `a` suffixes but not family-specific `f` suffixes.

The dependency fetch uses a fixed `sm_80` analysis configuration. The build removes
selected-output-backed CUDA, cuDNN, NCCL, and generated CUDA repositories from the
archive and regenerates them offline from `symlinkJoin` layouts. The archive keeps
the path-independent `local_config_nccl` aliases required by Bazel 7. The selected
CUDA and cuDNN manifests determine template versions and guard the fixed-output
archive hash; selected processed package outputs supply compiler, headers, runtime,
static cudart, NVVM, NVML stubs, cuDNN, and NCCL. XLA's downloaded CCCL 3.2.0,
Clang 18.1.8, NVSHMEM 3.2.5, and build-only real user-mode driver remain pinned.

Capabilities may change the dependency derivation identity through selected NCCL,
but the normalized fixed-output content and store path remain capability-independent.
A different CUDA/cuDNN manifest requires an explicit dependency hash override:

```nix
let
  pkgs = import ./. { config.allowUnfree = true; };
  selected = pkgs.xla.override {
    cudaSupport = true;
    cudaPackages = pkgs.cudaPackages_12_8;
  };
in
selected.overrideAttrs (previousAttrs: {
  deps = previousAttrs.deps.overrideAttrs {
    outputHash = pkgs.lib.fakeHash; # Replace with the measured dependency hash.
    outputHashAlgo = "sha256";
  };
})
```

Both hash attributes must be overridden. This escape hatch is evaluation-tested;
it is not a claim that alternate toolkit versions build or run. Package
`overrideAttrs` changes remain linked into passthru tests, including dependency
hash overrides.

## GPU prerequisites

A GPU builder needs supported NVIDIA device nodes and matching host userspace and
kernel drivers. Advertising the `cuda` system feature alone does not expose them.
On NixOS use the sandbox resource mechanism:

```nix
{
  programs.nix-required-mounts = {
    enable = true;
    presets.nvidia-gpu.enable = true;
  };
}
```

See `nixos/modules/programs/nix-required-mounts.nix`. The host driver libraries
normally live under `addDriverRunpath.driverLink` (`/run/opengl-driver/lib`). Do not
substitute toolkit stubs, disable sandboxing in portable derivations, or add an
entire distribution library directory to `LD_LIBRARY_PATH`. A missing GPU must
prevent scheduling or fail the test, never skip as success.

The installed CUDA package uses the selected `cudaPackages.cuda_nvcc` root as XLA's
default CUDA data directory, supplying `ptxas`, `nvlink`, and libdevice without
requiring clients to set `PATH`, `XLA_FLAGS`, `CUDA_HOME`, or `CUDA_PATH`. Explicit
`--xla_gpu_cuda_data_dir` overrides remain supported. The full NVCC output and its
transitive host GCC are intentional runtime dependencies; the NVIDIA driver remains
host-supplied.

## Test contracts and coverage

| Area | Check | Contract |
|---|---|---|
| Public PJRT C API | `tests.cpu`, `tests.cuda.pjrt` | Compile installed CPU/GPU headers, load `GetPjrtApi`, and compare API version and structure size with header macros. |
| CPU execution | `tests.cpu` for both package variants | Execute nonconstant `(x+y)*x`; check platform, devices, f32 `[2,3]` output, asynchronous completion, all values, and cleanup. |
| GPU execution | `tests.cuda.pjrt` | In a toolkit-clean environment, execute nonconstant arithmetic and `stablehlo.sine`, read results back, and reject fallback or skipped execution. |
| Negative controls | PJRT suites | Require the intentional numerical mismatch to exit 1 only after execution/readback; CPU also rejects requesting CUDA from the CPU plugin. |
| HLO comparison | `tests.hlo`, `tests.cuda.hlo` | Run `smoke.hlo` on Host against Interpreter and require `0/1 runs failed`; the CUDA-built CLI still needs a GPU host for its direct driver dependency. |
| ELF and RUNPATH audit | install suites | Inspect every regular ELF, resolve dynamic dependencies, permit only exact `libcuda.so.1` absence for CUDA, and verify declared driver/runtime RUNPATHs. |
| Runtime closure | install suites | Require selected runtime roots and CUDA compiler artifacts; reject source, dependency archive, Bazel, build stdenv, and explicit CUDA package-name prefixes from CPU closure. |
| Installed CUDA support files | CUDA install suite | Check `ptxas`, `nvlink`, libdevice, a compiled reference to the selected NVCC root, and pinned NVSHMEM DSOs/SONAMEs/symlinks. |
| Stale install references | install suites | Reject runfiles manifests, binary-safe `/build/output` contents, and that string in symlink targets. |
| Licensing and discovery | metadata checks, `eval.nix` | Check free/unfree licensing, free-only discovery, scheduling features, capabilities, selected package propagation, source/manifest consistency, and passthru override linkage. |
| CUDA repository generation | configure suites | Regenerate repositories, resolve selected NCCL aliases, compile with exact Clang/CCCL assertions, validate SASS/PTX policy, and exercise selected-output sentinels. |
| Checker behavior | `configureChecker` | Cover duplicate architecture handling, final PTX selection, stale/incorrect flag rejection, and missing/copied/linked driver-stub fixtures. |
| NCCL | `tests.cuda.nccl` | Check header/runtime version agreement and perform a one-rank `ncclAllReduce` through device memory. |

CPU-only builds may contain a GPU-named plugin without CUDA runtime support; the
CPU contract is the runtime closure, not the absence of that filename.

Not tested: upstream Bazel unit/integration suites, real CUDA matmul, cuDNN
convolution, an actual `nvlink` invocation, GPU HLO execution, multi-GPU or
multi-rank NCCL, NVSHMEM collectives, RDMA, NixOS sandbox integration, other GPU
models, or bit-for-bit reproducibility.
