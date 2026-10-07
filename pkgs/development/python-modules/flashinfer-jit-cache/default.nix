{
  cudaArchitectures ? cudaPackages.flags.cudaCapabilities,
  cudaPackages,
  flashinfer-python,
  lib,
  symlinkJoin,
  writableTmpDirAsHomeHook,
}:

flashinfer-python.overrideAttrs (old: {
  pname = "flashinfer-jit-cache";

  sourceRoot = "${old.src.name}/flashinfer-jit-cache";

  # Need to make the whole src writable, not just sourceRoot subtree
  postUnpack = ''
    chmod -R u+w ${old.src.name}
  '';

  postPatch = "";

  nativeBuildInputs = old.nativeBuildInputs ++ [ writableTmpDirAsHomeHook ];

  hardeningDisable = [ "bindnow" ];

  env = old.env // {
    CUDA_HOME = symlinkJoin {
      name = "cuda-home";
      paths = [ cudaPackages.cudatoolkit ];
      postBuild = "ln -s lib $out/lib64";
    };

    FLASHINFER_CUDA_ARCH_LIST = lib.concatStringsSep " " cudaArchitectures;
  };

  pythonImportsCheck = [ "flashinfer_jit_cache" ];

  passthru = builtins.removeAttrs old.passthru [ "gpuCheck" ];

  meta = old.meta // {
    description = "Pre-compiled JIT cache (shared libraries) for FlashInfer";
  };
})
