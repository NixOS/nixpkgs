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
    cudaOlder
    cudatoolkit
    flags
    libcublas
    ;
  inherit (lib.lists) optionals;
  inherit (lib.strings) cmakeBool cmakeFeature;
  fs = lib.fileset;
in
backendStdenv.mkDerivation (finalAttrs: {
  name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "saxpy";
  version = "unstable-2023-07-11";

  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      ./CMakeLists.txt
      ./saxpy.cu
    ];
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    autoAddDriverRunpath
  ] ++ optionals (cudaOlder "11.4") [ cudatoolkit ] ++ optionals (cudaAtLeast "11.4") [ cuda_nvcc ];

  buildInputs =
    optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ optionals (cudaAtLeast "11.4") [
      cuda_cudart
      libcublas
    ]
    ++ optionals (cudaAtLeast "12.0") [ cuda_cccl ];

  cmakeFlags = [
    (cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
  ];

  passthru.gpuCheck = finalAttrs.finalPackage.overrideAttrs (prevAttrs: {
    requiredSystemFeatures = [ "cuda" ];
    doInstallCheck = true;
    postInstallCheck = ''
      $out/bin/${prevAttrs.meta.mainProgram}
    '';
  });

  meta = {
    description = "Simple (Single-precision AX Plus Y) FindCUDAToolkit.cmake example for testing cross-compilation";
    license = lib.licenses.mit;
    maintainers = lib.teams.cuda.members;
    mainProgram = "saxpy";
    platforms = [
      "aarch64-linux"
      "ppc64le-linux"
      "x86_64-linux"
    ];
    badPlatforms = optionals (flags.isJetsonBuild && cudaOlder "11.4") finalAttrs.meta.platforms;
  };
})
