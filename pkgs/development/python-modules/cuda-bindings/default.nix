{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cudaPackages,
  addDriverRunpath,

  # build-system
  cython,
  setuptools,
  pyclibrary,

  # env
  symlinkJoin,

  # tests
  numpy,
  pytestCheckHook,

  # passthru
  cuda-bindings,
}:

buildPythonPackage (finalAttrs: {
  pname = "cuda-bindings";
  version = "12.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cuda-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7e9w70KkC6Pcvyu6Cwt5Asrc3W9TgsjiGvArRTer6Oc=";
  };

  sourceRoot = "${finalAttrs.src.name}/cuda_bindings";

  postPatch =
    let
      libCudaPath =
        # Use cuda_compat to provide libcuda.so on pre-Thor Jetsons
        if (cudaPackages.cuda_compat.meta.available or false) then
          cudaPackages.cuda_compat

        # Else, use the host CUDA driver library
        else
          addDriverRunpath.driverLink;
    in
    ''
      substituteInPlace cuda/bindings/_internal/nvjitlink_linux.pyx \
        --replace-fail \
          'so_name = "libnvJitLink.so"' \
          'so_name = "${lib.getLib cudaPackages.libnvjitlink}/lib/libnvJitLink.so"' \
        --replace-fail \
          "handle = dlopen('libcuda.so.1'" \
          "handle = dlopen('${libCudaPath}/lib/libcuda.so.1'"

      substituteInPlace cuda/bindings/_bindings/cydriver.pyx.in \
        --replace-fail \
          "path = 'libcuda.so.1'" \
          "path = '${libCudaPath}/lib/libcuda.so.1'"

      substituteInPlace cuda/bindings/_bindings/cynvrtc.pyx.in \
        --replace-fail \
          "dlfcn.dlopen('libnvrtc.so.12'" \
          "dlfcn.dlopen('${lib.getLib cudaPackages.cuda_nvrtc}/lib/libnvrtc.so.12'"

      substituteInPlace cuda/bindings/_lib/cyruntime/cyruntime.pyx.in \
        --replace-fail \
          "dlfcn.dlopen('libcudart.so.12'" \
          "dlfcn.dlopen('${lib.getLib cudaPackages.cuda_cudart}/lib/libcudart.so.12'"
    '';

  preBuild = ''
    export CUDA_PYTHON_PARALLEL_LEVEL=$NIX_BUILD_CORES
  '';

  build-system = [
    cython
    pyclibrary
    setuptools
  ];

  env = {
    CUDA_HOME = symlinkJoin {
      name = "cuda-redist";
      paths = with cudaPackages; [
        (lib.getInclude cuda_cudart) # cuda_runtime.h
        (lib.getInclude cuda_nvrtc) # nvrtc.h
        (lib.getInclude cuda_profiler_api) # cudaProfiler.h, cuda_profiler_api.h
      ];
    };
  };

  buildInputs = [
    cudaPackages.cuda_nvcc # crt/host_defines.h
  ];

  pythonImportsCheck = [
    "cuda"
    "cuda.cuda"
    "cuda.cudart"
    "cuda.nvrtc"
  ];

  preCheck = ''
    rm -rf cuda
  '';

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/"
  ];

  disabledTestPaths = [
    # The current driver shipped in NixOS (590.48.01) advertises CUDA 13.1, causing the following
    # error:
    # cuda.bindings._internal.utils.NotSupportedError: only CUDA 12 driver is supported
    #
    # Ideally, we should transition to cuda 13 across the whole nixpkgs tree.
    "tests/test_nvjitlink.py"
  ];

  # Tests need access to a GPU
  doCheck = false;
  passthru.gpuCheck = cuda-bindings.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "CUDA Python: Performance meets Productivity";
    homepage = "https://github.com/NVIDIA/cuda-python/tree/main/cuda_bindings";
    changelog = "https://nvidia.github.io/cuda-python/${finalAttrs.version}/release/${finalAttrs.version}-notes.html";
    license = lib.licenses.unfreeRedistributable; # NVIDIA Proprietary Software
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
