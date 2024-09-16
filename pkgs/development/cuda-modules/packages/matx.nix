# NOTE: Though NCCL is called within the cudaPackages package set, we avoid passing in
# the names of dependencies from that package set directly to avoid evaluation errors
# in the case redistributable packages are not available.
{
  autoAddDriverRunpath,
  cudaAtLeast,
  cmake,
  ninja,
  flags,
  cutlass,
  cudaMajorMinorVersion,
  cudaOlder,
  backendStdenv,
  cuda_cccl,
  cuda_cudart,
  cuda_nvcc,
  cuquantum,
  cudatoolkit,
  libcutensor,
  fetchFromGitHub,
  rapids-cmake,
  lib,
  python3Packages,
  which,
  # passthru.updateScript
  gitUpdater,
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.strings) cmakeFeature cmakeBool;

  pythonDeps = with python3Packages; [
    pybind11
    numpy
    cupy
  ];
in
backendStdenv.mkDerivation (finalAttrs: {
  name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "MatX";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "MatX";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-7ygdfo27tXz0f6jz6RwDCGwSQun3HqZJ9o6w2vKGM3s=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    rapids-cmake
    which
    autoAddDriverRunpath
  ] ++ pythonDeps ++ [ cuda_nvcc ];

  postPatch =
    # Remove the vendored rapids-cmake
    ''
      rm -rf cmake/rapids-cmake
    ''
    # Copy required components and update permissions
    + rapids-cmake.passthru.utilities.copyToCmakeDir
    # Remove the GetPyBind11.cmake file
    + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          "include(cmake/GetPyBind11.cmake)" \
          ""
    '';

  buildInputs = [
    cuda_cudart
    cuda_cccl
    libcutensor
    cutlass
    cuquantum # cutensorNet
  ];

  # TODO: This should be handled by setup hooks in rapids-cmake.
  cmakeFlags = rapids-cmake.passthru.data.cmakeFlags ++ [
    (cmakeBool "MATX_BUILD_EXAMPLES" false)
    (cmakeBool "MATX_BUILD_TESTS" false)
    (cmakeBool "MATX_BUILD_BENCHMARKS" false)
    (cmakeBool "MATX_NVTX_FLAGS" true)
    (cmakeBool "MATX_BUILD_DOCS" false)
    (cmakeBool "MATX_BUILD_32_BIT" false)
    (cmakeBool "MATX_MULTI_GPU" false) # Requires Nvshmem?
    (cmakeBool "MATX_EN_VISUALIZATION" false) # TODO: Revisit
    (cmakeBool "MATX_EN_CUTLASS" false) # TODO: CUTLASS support is removed in main?
    (cmakeBool "MATX_EN_CUTENSOR" true)
    (cmakeBool "MATX_EN_FILEIO" true)
    (cmakeBool "MATX_EN_NVPL" false) # TODO: Revisit for ARM support
    (cmakeBool "MATX_DISABLE_CUB_CACHE" true)
  ];

  propagatedBuildInputs = pythonDeps;

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    inherit (finalAttrs) pname version;
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "An efficient C++17 GPU numerical computing library with Python-like syntax";
    homepage = "https://nvidia.github.io/MatX";
    broken = cudaOlder "11.4";
    license = licenses.bsd3;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ connorbaker ] ++ teams.cuda.members;
  };
})
