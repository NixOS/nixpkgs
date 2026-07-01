{
  lib,
  buildPythonPackage,
  nvidia-cudnn-frontend,

  # build-system
  cmake,
  ninja,
  pybind11,
  setuptools,

  # nativeBuildInputs
  cudaPackages,

  # buildInputs
  dlpack,

  # propagatedBuildInputs
  nlohmann_json,

  # tests
  looseversion,
  pytestCheckHook,
  torch,
}:
buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  inherit (cudaPackages.cudnn-frontend)
    version
    src
    meta
    ;

  pname = "nvidia-cudnn-frontend";
  pyproject = true;
  __structuredAttrs = true;

  postPatch =
    cudaPackages.cudnn-frontend.postPatch
    + ''
      substituteInPlace pyproject.toml \
        --replace-fail '"ninja==1.11.1.1"' '"ninja"' \
        --replace-fail '"pybind11[global]>=2.13,<3"' '"pybind11"'

      sed -i '/cmake_args =/a\\f"-DCUDNN_FRONTEND_USE_SYSTEM_DLPACK=ON",' setup.py
    ''
    + ''
      substituteInPlace python/cudnn/__init__.py \
        --replace-fail \
          'os.path.join(sysconfig.get_path("purelib"), "nvidia/cudnn/lib/libcudnn.so.*[0-9]")' \
          '"${lib.getLib cudaPackages.cudnn}/lib/libcudnn.so"'
    '';

  build-system = [
    cmake
    ninja
    pybind11
    setuptools
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvrtc # nvrtc.h
    cudaPackages.cudnn
    dlpack
  ];

  propagatedBuildInputs = [
    nlohmann_json
  ];

  pythonImportsCheck = [ "cudnn" ];

  # requires GPU
  doCheck = false;
  nativeCheckInputs = [
    looseversion
    pytestCheckHook
    torch
  ];

  enabledTestPaths = [
    "test/"
  ];

  passthru.gpuCheck = nvidia-cudnn-frontend.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };
})
