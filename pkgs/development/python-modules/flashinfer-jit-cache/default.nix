{
  lib,
  buildPythonPackage,
  callPackage,
  python,
  lndir,

  # build-system
  setuptools,
  wheel,
  torch,

  cudaPackages,

  # dependencies
  flashinfer-cubin,
  flashinfer-python,

  # passthru
  writableTmpDirAsHomeHook,

  cudaSupport ? torch.cudaSupport,
  cudaCapabilities ? torch.cudaCapabilities,
}:

let
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

  mkProviderForCap =
    cudaCapability:
    callPackage ./provider.nix {
      inherit
        cudaCapability
        patches
        postPatch
        ;
    };

  # The `flashinfer-jit-cache` distribution is only a shim discovering the per-architecture
  # providers (`flashinfer-jit-cache-smXX`) which contain the AOT-compiled kernels.
  # Each provider is built in its own derivation, so that they build in parallel.
  providers = lib.genAttrs cudaCapabilities mkProviderForCap;
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "flashinfer-jit-cache";
  # flashinfer requires the exact same version for the jit cache
  inherit (flashinfer-python) version src;
  pyproject = true;

  inherit
    patches
    postPatch
    ;

  build-system = [
    setuptools
    # wheel
  ];

  env = {
    # Dependencies of the shim: one `flashinfer-jit-cache-smXX` provider per architecture
    FLASHINFER_JIT_CACHE_PROVIDER_ARCHS = lib.concatStringsSep " " cudaCapabilities;
  };

  # Only the (pure metadata) shim is built here.
  # The providers are linked into its output, so that they remain separate store paths.
  # They are not declared as dependencies, as they install into the shim's own
  # `flashinfer_jit_cache` package, which Python only looks up in a single directory.
  nativeBuildInputs = [ lndir ];

  postInstall = lib.concatMapStrings (provider: ''
    lndir -silent ${provider}/${python.sitePackages} $out/${python.sitePackages}
  '') (lib.attrValues providers);

  pypaBuildFlags = [ "flashinfer-jit-cache" ];

  dependencies = [
    # Provides the trtllm-gen/DeepGEMM artifacts (headers, checksums.txt and cubins), both when
    # building the AOT modules and at runtime
    flashinfer-cubin
    flashinfer-python
  ];

  # The shim only depends on the providers, which are linked into its output
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

  passthru =
    let
      gpuCheckTester =
        cudaPackages.writeGpuTestPython
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
          '';
    in
    {
      inherit providers;

      inherit (gpuCheckTester) gpuCheck;
    };

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
