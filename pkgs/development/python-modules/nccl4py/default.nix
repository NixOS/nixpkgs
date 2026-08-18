{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cudaPackages,
  addDriverRunpath,

  # build-system
  cython,
  setuptools,

  # dependencies
  cuda-core,
  numpy,
  nvidia-cutlass-dsl,
  packaging,
  pythonOlder,
  typing-extensions,

  # passthru
  runCommand,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "nccl4py";
  # `nccl4py` is versioned independently of `nccl` and should be the same as the contents of
  # `${cudaPackages.nccl.src}/bindings/nccl4py/nccl/_version.py`
  version = "0.4.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    tag = "nccl4py-v${finalAttrs.version}";
    hash = "sha256-p9z4NlccBdI0auMRzTJtK8VbAOSunLdwKKU0Wn5c6c0=";
  };
  sourceRoot = "${finalAttrs.src.name}/bindings/nccl4py";

  postPatch =
    let
      # taken from `cuda-bindings`'s `postPatch`
      libCudaPath =
        # Use cuda_compat to provide libcuda.so on pre-Thor Jetsons
        if (cudaPackages.cuda_compat.meta.available or false) then
          cudaPackages.cuda_compat

        # Else, use the host CUDA driver library
        else
          addDriverRunpath.driverLink;
    in
    ''
      substituteInPlace nccl/bindings/_internal/nccl_linux.pyx \
        --replace-fail \
          "handle = dlopen('libcuda.so.1'" \
          "handle = dlopen('${libCudaPath}/lib/libcuda.so.1'"

      substituteInPlace nccl/bindings/_internal/nccl_linux.pyx \
        --replace-fail \
          'cdef uintptr_t handle = load_nvidia_dynamic_lib("nccl")._handle_uint' \
          'cdef uintptr_t handle = <uintptr_t>dlopen("${lib.getLib cudaPackages.nccl}/lib/libnccl.so.2", RTLD_NOW | RTLD_GLOBAL)'

      substituteInPlace nccl/bindings/_internal/nccl_ep_linux.pyx \
        --replace-fail \
          "handle = dlopen('libcuda.so.1'" \
          "handle = dlopen('${libCudaPath}/lib/libcuda.so.1'"

      substituteInPlace nccl/bindings/_internal/nccl_ep_linux.pyx \
        --replace-fail \
          'load_nvidia_dynamic_lib("nccl")' \
          'dlopen("${lib.getLib cudaPackages.nccl}/lib/libnccl.so.2", RTLD_NOW | RTLD_GLOBAL)'

      substituteInPlace nccl/bindings/_internal/nccl_ep_linux.pyx \
        --replace-fail \
          'cdef bytes path_bytes = _resolve_library_path().encode()' \
          'cdef bytes path_bytes = b"${lib.getLib cudaPackages.nccl-ep}/lib/libnccl_ep.so"'
    '';

  build-system = [
    cython
    setuptools
  ];

  env = {
    # `${sourceRoot}/setup.py` insists on reading only from $CUDA_HOME/include
    CUDA_HOME = (lib.getInclude cudaPackages.cuda_cudart).outPath;
    # Since `cudaPackages.nccl-ep` is used as a byte string, it gets
    # compressed and no dependency is created. Disable string
    # compression for Nix to correctly detect the dependency.
    NIX_CFLAGS_COMPILE = "-DCYTHON_COMPRESS_STRINGS=0";
  };

  buildInputs =
    lib.optionals (cudaPackages.cudaOlder "13.0") [
      cudaPackages.cuda_nvcc
    ]
    ++ lib.optionals (cudaPackages.cudaAtLeast "13.0") [
      cudaPackages.cuda_crt
    ];

  dependencies = [
    cuda-core
    numpy
    nvidia-cutlass-dsl
    packaging
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ];

  pythonImportsCheck = [
    "nccl"
    "nccl.bindings"
  ];

  passthru.tests = {
    import-clean-env =
      runCommand "import-clean-env-nccl4py-ep"
        {
          nativeBuildInputs = [ (python.withPackages (_: [ finalAttrs.finalPackage ])) ];
        }
        ''
          LD_LIBRARY_PATH="${lib.getLib cudaPackages.cuda_cudart}/lib/stubs" \
              python -c 'import nccl.ep'
          touch $out
        '';
  };

  # Upstream doesn't ship any tests.
  doCheck = false;

  meta = {
    description = "Python bindings for NCCL";
    homepage = "https://github.com/NVIDIA/nccl/blob/master/bindings/nccl4py/README.md";
    changelog = "https://github.com/NVIDIA/nccl/releases/tag/${finalAttrs.src.tag}";
    # `cudaPackages.nccl` is BSD3 but the bindings are licensed under
    # Apache License 2.0
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      GaetanLepage
      thefossguy
    ];
    inherit (cudaPackages.nccl.meta) platforms badPlatforms;
  };
})
