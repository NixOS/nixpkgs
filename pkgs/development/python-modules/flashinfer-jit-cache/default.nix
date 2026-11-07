{
  lib,
  buildPythonPackage,
  build,

  # build-system
  apache-tvm-ffi,
  numpy,
  nvidia-ml-py,
  packaging,
  requests,
  setuptools,
  torch,
  tqdm,

  # nativeBuildInputs
  ninja,
  cudaPackages,

  # dependencies
  flashinfer-cubin,
  flashinfer-python,

  # passthru
  writableTmpDirAsHomeHook,

  cudaSupport ? torch.cudaSupport,
  cudaCapabilities ? torch.cudaCapabilities,
}:

buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "flashinfer-jit-cache";
  # flashinfer requires the exact same version for the jit cache
  inherit (flashinfer-python) version src;
  pyproject = true;
  __structuredAttrs = true;

  # Same source as flashinfer-python: also apply its patches
  inherit (flashinfer-python) patches;

  postPatch =
    # The FP4 KV dequantization module only supports SM >= 8.0, but is added unconditionally.
    # Building the sm75 provider fails with:
    #   RuntimeError: No supported CUDA architectures found for major versions [8, 9, 10, 11, 12].
    ''
      substituteInPlace flashinfer/aot.py \
        --replace-fail \
          "jit_specs.append(gen_fp4_kv_dequantization_module())" \
          "if has_sm80 or has_sm90 or has_sm100 or has_sm103 or has_sm107 or has_sm110 or has_sm120 or has_sm121: jit_specs.append(gen_fp4_kv_dequantization_module())"
    '';

  build-system = [
    apache-tvm-ffi
    numpy
    nvidia-ml-py
    packaging
    requests
    setuptools
    torch
    tqdm
  ];

  nativeBuildInputs = [
    build
    ninja
    (lib.getBin cudaPackages.cuda_nvcc)
  ];

  buildInputs = with cudaPackages; [
    cccl
    cuda_cudart
    libcublas
    libcurand
  ];

  env = {
    # The JIT compiler expects a regular CUDA toolkit layout (`bin/nvcc`, `include`, `lib64`)
    CUDA_HOME = flashinfer-python.cudaHome;
    # Dependencies of the shim: one `flashinfer-jit-cache-smXX` provider per architecture
    FLASHINFER_JIT_CACHE_PROVIDER_ARCHS = lib.concatStringsSep " " cudaCapabilities;
    # The trtllm-gen/DeepGEMM artifacts come from `flashinfer-cubin`: fail early if one is missing
    # instead of retrying to download it in the sandbox
    FLASHINFER_NO_DOWNLOAD = "1";
  };
  # Exposed as a bash array (`__structuredAttrs`) to build one provider per architecture
  inherit cudaCapabilities;

  preBuild =
    # Otherwise, fails at build time with:
    #   PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
    ''
      export FLASHINFER_WORKSPACE_BASE=$(mktemp -d)
    ''
    # Otherwise, ninja uses all the available cores
    + ''
      export MAX_JOBS=$NIX_BUILD_CORES
    ''
    # The `flashinfer-jit-cache` distribution is only a shim discovering the per-architecture
    # providers (`flashinfer-jit-cache-smXX`) which contain the AOT-compiled kernels.
    # Build one provider wheel per architecture, all installed alongside the shim, as they share the
    # `flashinfer_jit_cache` python package.
    + ''
      for arch in "''${cudaCapabilities[@]}"; do
        nixLog "Building flashinfer-jit-cache provider for CUDA architecture $arch"

        FLASHINFER_JIT_CACHE_PROVIDER_ARCH="$arch" \
          pyproject-build --no-isolation --skip-dependency-check --wheel --outdir dist/ \
          flashinfer-jit-cache-provider

        # Do not leak build artifacts into the next provider
        rm -rf \
          flashinfer-jit-cache-provider/build \
          flashinfer-jit-cache-provider/*.egg-info \
          flashinfer-jit-cache-provider/flashinfer_jit_cache_provider/jit_cache \
          flashinfer-jit-cache-provider/flashinfer_jit_cache_provider/manifest.json
      done
    '';

  pypaBuildFlags = [ "flashinfer-jit-cache" ];

  # The AOT modules reference template instantiations that are never called (nor compiled).
  # This only works with lazy binding, which `bindnow` (`-z now`) breaks: "undefined symbol".
  hardeningDisable = [ "bindnow" ];

  dependencies = [
    # Provides the trtllm-gen/DeepGEMM artifacts (headers, checksums.txt and cubins), both when
    # building the AOT modules and at runtime
    flashinfer-cubin
    flashinfer-python
  ];

  # The shim only depends on the providers, which are built (but not yet installed) alongside it
  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [ "flashinfer_jit_cache" ];

  # Ensure that every provider is discovered by the shim
  postInstallCheck = ''
    python - <<EOF
    import flashinfer_jit_cache
    providers = flashinfer_jit_cache.get_jit_cache_providers()
    print(providers)
    assert len(providers) == ${toString (lib.length cudaCapabilities)}, providers
    EOF
  '';

  passthru.gpuCheck =
    (cudaPackages.writeGpuTestPython
      {
        name = "flashinfer-jit-cache-smoke-test";
        libraries = ps: [ ps.flashinfer-jit-cache ];
        gpuCheckArgs.nativeBuildInputs = [
          # PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
          writableTmpDirAsHomeHook
        ];
      }
      # Run a kernel on the available GPU, from its provider, without falling back to JIT compilation
      ''
        import os
        import runpy
        import sys

        os.environ["FLASHINFER_DISABLE_JIT"] = "1"

        from flashinfer.jit import env

        sys.argv = ["smoke-test", "--provider", env._cuda_architecture_for_device(0)]
        runpy.run_path(
            "${finalAttrs.src}/scripts/smoke_test_jit_cache_provider.py",
            run_name="__main__",
        )
      ''
    ).gpuCheck;

  meta = {
    broken = !cudaSupport;
    description = "Pre-compiled JIT cache for FlashInfer";
    homepage = "https://github.com/flashinfer-ai/flashinfer/tree/main/flashinfer-jit-cache";
    inherit (flashinfer-python.meta) changelog;
    license = lib.licenses.asl20;
    teams = [ lib.teams.cuda ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
