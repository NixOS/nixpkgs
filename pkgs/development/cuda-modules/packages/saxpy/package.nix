{
  autoAddDriverRunpath,
  cmake,
  cudaMajorMinorVersion,
  cudaPackages,
  lib,
}:
let
  inherit (cudaPackages)
    backendStdenv
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cudaAtLeast
    cudaFlags
    cudaOlder
    cudatoolkit
    libcublas
    ;
in
backendStdenv.mkDerivation (finalAttrs: {
  name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "saxpy";
  version = "unstable-2023-07-11";

  src = ./.;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      autoAddDriverRunpath
    ]
    ++ lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lib.optionals (cudaAtLeast "11.4") [ cuda_nvcc ];

  buildInputs =
    lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lib.optionals (cudaAtLeast "11.4") [
      cuda_cudart
      libcublas.dev
      libcublas.lib
    ]
    ++ lib.optionals (cudaAtLeast "12.0") [ cuda_cccl.dev ];

  cmakeFlagsArray = [
    (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaFlags.cmakeCudaArchitecturesString)
  ];

  meta = rec {
    description = "Simple (Single-precision AX Plus Y) FindCUDAToolkit.cmake example for testing cross-compilation";
    license = lib.licenses.mit;
    maintainers = lib.teams.cuda.members;
    platforms = [
      "aarch64-linux"
      "ppc64le-linux"
      "x86_64-linux"
    ];
    badPlatforms = lib.optionals (cudaFlags.isJetsonBuild && cudaOlder "11.4") platforms;
  };
})
