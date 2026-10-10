{
  flashinfer-python,
  lib,
  symlinkJoin,
  cudaPackages,
  writableTmpDirAsHomeHook,

  # CUDA compute capabilities (e.g. [ "12.0" ]) to build the AOT cache for.
  # `FLASHINFER_CUDA_ARCH_LIST` expects a space-separated list of
  # `<major>.<minor>` values.
  cudaArchitectures ? cudaPackages.flags.cudaCapabilities,
}:

flashinfer-python.overrideAttrs (old: {
  pname = "flashinfer-jit-cache";

  sourceRoot = "${old.src.name}/flashinfer-jit-cache";
  postUnpack = ''
    # Since we have set `sourceRoot` to a subdir of the actual upstream
    # source, stdenv performs `u+w` recursively only on `sourceRoot`.
    # But, we need parts of `src` to be writeable so lets' just do it
    # indiscriminately.
    chmod -R u+w ${old.src.name}
  '';

  postPatch = "";

  nativeBuildInputs = old.nativeBuildInputs ++ [ writableTmpDirAsHomeHook ];

  # FlashInfer intentionally skips some unreachable `CTA_TILE_Q` template
  # instantiations (e.g. `batch_prefill` with `head_dim_vo < 512` omits
  # `CTA_TILE_Q=32`), so the AOT modules carry undefined symbols that are never
  # called. Nixpkgs' default `bindnow` hardening (`-z now`) resolves every
  # symbol at `dlopen` time and fails on them; lazy binding (what the upstream
  # wheel uses) does not.
  hardeningDisable = [ "bindnow" ];

  env = old.env // {
    # Though setting `CUDA_HOME` to `${cudaPackages.cuda_nvcc}.out`
    # might work elsewhere, it fails here because flashinfer does some
    # hardcoding. Easier to just create a custom environment than
    # fixing flashinfer's behaviour.
    CUDA_HOME = symlinkJoin {
      name = "cuda-home";
      # The AOT build compiles the full csrc tree with `nvcc`, which needs the
      # complete toolkit headers (cudart/crt/nvrtc/cublas/cusparse/cusolver/
      # curand/...), not just flashinfer-python's `buildInputs`. The
      # `cudatoolkit` aggregate carries every CUDA output.
      paths = [ cudaPackages.cudatoolkit ];
      postBuild = "ln -s lib $out/lib64";
    };

    FLASHINFER_CUDA_ARCH_LIST = lib.concatStringsSep " " cudaArchitectures;
  };

  pythonImportsCheck = [ "flashinfer_jit_cache" ];

  # The inherited `gpuCheck` checks `flashinfer-python`, not this package.
  passthru = builtins.removeAttrs old.passthru [ "gpuCheck" ];

  meta = old.meta // {
    description = "Pre-compiled JIT cache (shared libraries) for FlashInfer";
  };
})
