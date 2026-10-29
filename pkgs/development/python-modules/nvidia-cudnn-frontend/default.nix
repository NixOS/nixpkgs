{
  lib,
  buildPythonPackage,
  nvidia-cudnn-frontend,

  # build-system
  cmake,
  nanobind_3,
  ninja,
  setuptools,

  # nativeBuildInputs
  cudaPackages,

  # buildInputs
  dlpack,

  # propagatedBuildInputs
  nlohmann_json,

  # dependencies
  apache-tvm-ffi,
  nvidia-cutlass-dsl,

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
        --replace-fail '"ninja==1.11.1.1;' '"ninja;'

      sed -i '/cmake_args =/a\\f"-DCUDNN_FRONTEND_USE_SYSTEM_DLPACK=ON",' setup.py
    ''
    # The bindings include standard headers before Python.h, so pyconfig.h redefines the
    # _POSIX_C_SOURCE and _XOPEN_SOURCE that glibc already defined, with different values.
    # That warning is an error under upstream's -Werror.
    + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail '-Wpedantic -Werror ' '-Wpedantic '
    ''
    + ''
      substituteInPlace python/cudnn/__init__.py \
        --replace-fail \
          'os.path.join(sysconfig.get_path("purelib"), "nvidia/cudnn/lib/libcudnn.so.*[0-9]")' \
          '"${lib.getLib cudaPackages.cudnn}/lib/libcudnn.so"'
    '';

  build-system = [
    cmake
    nanobind_3
    ninja
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

  dependencies = [
    apache-tvm-ffi
    nvidia-cutlass-dsl
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

  # The version and source are cudaPackages.cudnn-frontend's, so updating it updates this package too.
  passthru.updateScript = cudaPackages.cudnn-frontend.updateScript // {
    attrPath = "cudaPackages.cudnn-frontend";
  };
})
