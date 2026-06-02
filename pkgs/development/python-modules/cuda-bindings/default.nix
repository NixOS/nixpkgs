{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cudaPackages,
  replaceVars,
  addDriverRunpath,

  # build-system
  cython,
  pyclibrary,
  setuptools,
  setuptools-scm,

  # env
  symlinkJoin,

  # dependencies
  numpy,

  # tests
  cuda-pathfinder,
  pytest-benchmark,
  pytestCheckHook,
  util-linux,

  # passthru
  cuda-bindings,
}:

let
  cudaVersion = cudaPackages.cudaMajorMinorVersion;

  versionSpecificAttrs =
    let
      args = {
        inherit replaceVars;
        cudaLibPaths = {
          libcudart = lib.getLib cudaPackages.cuda_cudart;
          libcufile = lib.getLib cudaPackages.libcufile;
          libnvfatbin = lib.getLib cudaPackages.libnvfatbin;
          libnvjitlink = lib.getLib cudaPackages.libnvjitlink;
          libnvml = addDriverRunpath.driverLink;
          libnvrtc = lib.getLib cudaPackages.cuda_nvrtc;
          libnvvm =
            if cudaOlder "13.0" then "${cudaPackages.cuda_nvcc}/nvvm" else lib.getLib cudaPackages.libnvvm;
        };
      };
    in
    {
      # cuda-bindings patch versions DO NOT correspond to cuda toolkits' own path versions.
      # Only major.minor is supposed to match
      "12.9" = import ./12_9.nix args;
      "13.0" = import ./13_0.nix args;
      "13.1" = import ./13_1.nix args;
      "13.2" = import ./13_2.nix args;
    }
    .${cudaVersion} or (throw "Unsupported cuda-bindings version: ${cudaVersion}");

  inherit (cudaPackages) cudaOlder cudaAtLeast;
in
buildPythonPackage (finalAttrs: {
  pname = "cuda-bindings";
  inherit (versionSpecificAttrs) version;
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cuda-python";
    tag = "v${finalAttrs.version}";
    hash = versionSpecificAttrs.sourceHash;
  };

  # Apply patch relative to cuda_bindings
  patchFlags = [ "-p2" ];

  patches = [
    versionSpecificAttrs.nvidiaLibsPatch
  ];

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
          "handle = dlopen('libcuda.so.1'" \
          "handle = dlopen('${libCudaPath}/lib/libcuda.so.1'"

      substituteInPlace cuda/bindings/_bindings/cydriver.pyx.in \
        --replace-fail \
          "path = 'libcuda.so.1'" \
          "path = '${libCudaPath}/lib/libcuda.so.1'"
    ''
    + (versionSpecificAttrs.postPatch or "");

  preBuild = ''
    export CUDA_PYTHON_PARALLEL_LEVEL=$NIX_BUILD_CORES
  '';

  build-system = [
    cython
    pyclibrary
    setuptools
    setuptools-scm
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
    cudaPackages.libcufile # cufile.h
  ]
  # Until 13.0, crt headers are shipped in nvcc
  ++ lib.optionals (cudaOlder "13.0") [
    cudaPackages.cuda_nvcc # crt/host_defines.h
  ]
  ++ lib.optionals (cudaAtLeast "13.0") [
    cudaPackages.cuda_crt # crt/host_defines.h
  ];

  pythonRemoveDeps = [
    # We circumvent cuda_pathfinder to localize nvidia libs with patches
    "cuda-pathfinder"
  ];
  dependencies = [
    # Not explicitly listed as a dependency, but is required at import time
    numpy
  ];

  pythonImportsCheck = [
    "cuda"
    "cuda.bindings.cufile"
    "cuda.bindings.driver"
    "cuda.bindings.nvjitlink"
    "cuda.bindings.nvrtc"
    "cuda.bindings.nvvm"
    "cuda.bindings.runtime"
  ]
  ++ (versionSpecificAttrs.pythonImportsCheck or [ ]);

  preCheck = ''
    rm -rf cuda
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.optionals (cudaPackages.cudaAtLeast "13.0") [
    # Although we don't want cuda.pathfinder as a dependency (to handle dlopens), it is imported by
    # some tests
    cuda-pathfinder

    pytest-benchmark
    util-linux # findmnt
  ];

  enabledTestPaths = [
    "tests/"
  ];

  disabledTestPaths = lib.optionals (cudaOlder "13.0") [
    # The current driver shipped in NixOS (590.48.01) advertises CUDA 13.1, causing the following
    # error:
    # cuda.bindings._internal.utils.NotSupportedError: only CUDA 12 driver is supported
    "tests/test_nvjitlink.py"
  ];

  disabledTests = versionSpecificAttrs.disabledTests or [ ];

  # Tests need access to a GPU
  doCheck = false;
  passthru.gpuCheck = cuda-bindings.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "Standard set of low-level interfaces, providing access to the CUDA host APIs from Python";
    homepage = "https://github.com/NVIDIA/cuda-python/tree/main/cuda_bindings";
    changelog = "https://nvidia.github.io/cuda-python/${finalAttrs.version}/release/${finalAttrs.version}-notes.html";
    license = lib.licenses.unfreeRedistributable; # NVIDIA Proprietary Software
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
