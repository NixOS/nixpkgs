{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  typing-extensions,

  # nativeBuildInputs
  cmake,
  cudaPackages,

  # buildInputs
  dlpack,

  # tests
  pytestCheckHook,
  torch,

  # passthru
  cuda-tile,
}:
let
  # https://github.com/NVIDIA/cutile-python/blob/v1.4.0/cmake/FetchXLAHeaders.cmake#L5-L6
  xla = fetchFromGitHub {
    owner = "openxla";
    repo = "xla";
    rev = "b6f37ab7767f428fd6f993de5e211643d47d4deb";
    hash = "sha256-U4e3k4nm9gB1x5hahXwycWSryBQuxIPmOzVf6kuahY0=";
  };
in
buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "cuda-tile";
  version = "1.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutile-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R5V69nJLQ3/1995ezH1/WuueA6cm1vhKZdOECqbwPbU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==80.10.2" "setuptools"
  ''
  # Otherwise fails to find libc
  # xla_ffi.cpp:(.text+0x308): undefined reference to `__stack_chk_fail'
  + ''
    substituteInPlace cext/CMakeLists.txt \
      --replace-fail \
        "target_link_libraries(_cext_shared _cext_static \''${Python_LIBRARIES} \''${asan_library})" \
        "target_link_libraries(_cext_shared _cext_static \''${Python_LIBRARIES} \''${asan_library} c)"
  ''
  # Get rid of the vendored broken logic for finding the CUDA toolkit
  + ''
    rm cmake/FindCUDAToolkit.cmake
  ''
  # Manually inject the library version
  + ''
    echo "${finalAttrs.version}" >src/cuda/tile/VERSION
  '';

  build-system = [
    setuptools
  ];

  env = {
    CUDA_TILE_CMAKE_DLPACK_PATH = dlpack;
    CUDA_TILE_CMAKE_XLA_PATH = xla;
  };

  nativeBuildInputs = [
    cmake
    cudaPackages.cuda_nvcc
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    cudaPackages.cuda_cudart # cuda.h
  ];

  dependencies = [
    typing-extensions
  ];

  optional-dependencies = {
    tileiras = [
      # unpackaged as it doesn't make sense to have it in nixpkgs
      # cuda-toolkit
    ];
  };

  pythonImportsCheck = [ "cuda.tile" ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  # Tests require access to a physical GPU
  doCheck = false;

  passthru.gpuCheck = cuda-tile.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "Programming model for writing parallel kernels for NVIDIA GPUs";
    homepage = "https://docs.nvidia.com/cuda/cutile-python/";
    downloadPage = "https://github.com/NVIDIA/cutile-python";
    changelog = "https://docs.nvidia.com/cuda/cutile-python/generated/release_notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      prince213
    ];
    broken = !config.cudaSupport;
  };
})
