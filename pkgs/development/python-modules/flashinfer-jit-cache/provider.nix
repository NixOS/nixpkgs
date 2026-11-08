# One `flashinfer-jit-cache-smXX` provider: the AOT-compiled kernels for a single CUDA architecture,
# installed in its own store path. `flashinfer-jit-cache` links it into its output.
# Building each provider in its own derivation lets them build in parallel.
{
  lib,
  python,
  cudaPackages,
  torch,

  # nativeBuildInputs
  ninja,

  # build-system
  apache-tvm-ffi,
  build,
  installer,
  numpy,
  nvidia-ml-py,
  packaging,
  requests,
  setuptools,
  tqdm,

  flashinfer-cubin,
  flashinfer-python,

  cudaCapability,
  patches,
  postPatch,
}:
let
  providerTag = "sm" + lib.replaceStrings [ "." ] [ "" ] cudaCapability;

  buildPython = python.withPackages (_: [
    apache-tvm-ffi
    build
    installer
    numpy
    nvidia-ml-py
    packaging
    requests
    setuptools
    torch
    tqdm

    # The AOT build imports `flashinfer` from the source tree, which needs its dependencies
    flashinfer-python
    # Provides the trtllm-gen/DeepGEMM artifacts (headers, checksums.txt)
    flashinfer-cubin
  ]);
in
torch.stdenv.mkDerivation {
  pname = "${python.libPrefix}-flashinfer-jit-cache-${providerTag}";
  inherit (flashinfer-python)
    version
    src
    ;
  inherit
    patches
    postPatch
    ;

  nativeBuildInputs = [
    buildPython
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
    FLASHINFER_JIT_CACHE_PROVIDER_ARCH = cudaCapability;

    # The trtllm-gen/DeepGEMM artifacts come from `flashinfer-cubin`: fail early if one is missing
    # instead of retrying to download it in the sandbox
    FLASHINFER_NO_DOWNLOAD = "1";
  };

  # The AOT modules reference template instantiations that are never called (nor compiled).
  # This only works with lazy binding, which `bindnow` (`-z now`) breaks: "undefined symbol".
  hardeningDisable = [ "bindnow" ];

  buildPhase = ''
    runHook preBuild
  ''
  # Otherwise, fails at build time with:
  #   PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
  + ''
    export FLASHINFER_WORKSPACE_BASE=$(mktemp -d)
  ''
  # Otherwise, ninja uses all the available cores
  + ''
    export MAX_JOBS=$NIX_BUILD_CORES
  ''
  + ''
    pyproject-build \
      --no-isolation \
      --skip-dependency-check \
      --wheel \
      --outdir dist/ \
      flashinfer-jit-cache-provider
  ''
  + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    python -m installer --prefix $out dist/*.whl
    runHook postInstall
  '';

  passthru = {
    inherit
      cudaCapability
      providerTag
      ;
  };

  meta = {
    broken = !torch.cudaSupport;
    description = "Pre-compiled FlashInfer JIT cache for ${providerTag}";
    homepage = "https://github.com/flashinfer-ai/flashinfer/tree/main/flashinfer-jit-cache-provider";
    license = lib.licenses.asl20;
    teams = [ lib.teams.cuda ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
