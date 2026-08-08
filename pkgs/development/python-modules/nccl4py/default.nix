{
  lib,
  buildPythonPackage,
  cudaPackages,
  addDriverRunpath,

  # build-system
  cython,
  setuptools,

  # dependencies
  cuda-core,
  numpy,
  packaging,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "nccl4py";
  # `nccl4py` is versioned independently of `nccl` and should be the
  # same as the contents of
  # `${cudaPackages.nccl.src}/bindings/nccl4py/nccl/_version.py`
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  inherit (cudaPackages.nccl) src;
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
    '';

  build-system = [
    cython
    setuptools
  ];

  env = {
    # `${sourceRoot}/setup.py` insists on reading only from $CUDA_HOME/include
    CUDA_HOME = (lib.getInclude cudaPackages.cuda_cudart).outPath;
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
    packaging
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ];

  pythonImportsCheck = [
    "nccl"
    "nccl.bindings"
  ];

  # Upstream doesn't ship any tests.
  doCheck = false;

  meta = {
    description = "Python bindings for NCCL";
    homepage = "https://github.com/NVIDIA/nccl/blob/master/bindings/nccl4py/README.md";
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
