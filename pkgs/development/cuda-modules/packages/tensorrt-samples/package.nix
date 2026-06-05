{
  _cuda,
  backendStdenv,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cuda_profiler_api,
  cudaNamePrefix,
  fetchFromGitHub,
  fetchzip,
  flags,
  lib,
  runCommand,
  stdenvNoCC,
  tensorrt,
  writeShellApplication,
}:
let
  inherit (_cuda.lib) majorMinorPatch;
  inherit (lib)
    cmakeBool
    cmakeFeature
    getAttr
    getInclude
    licenses
    maintainers
    optionalString
    replaceStrings
    teams
    ;
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";

  pname = "tensorrt-samples";

  version = majorMinorPatch tensorrt.version;

  src = fetchFromGitHub (
    {
      owner = "NVIDIA";
      repo = "TensorRT";
    }
    // getAttr finalAttrs.version {
      "10.0.0" = {
        tag = "v10.0.0";
        hash = "sha256-k0FqEURPCtcPgowORHme/lhQ5SN63d0lYQvTvFXS6vw=";
      };
      "10.0.1" = {
        tag = "v10.0.1";
        hash = "sha256-lSEw0GM0eW2BHNBq/wTQA8v3aNueE3FT+k9F5nH1OgA=";
      };
      "10.1.0" = {
        tag = "v10.1.0";
        hash = "sha256-A3QwrQaI0EgRspgXEKcna/z6p7abOq3M7KDQMPQftvE=";
      };
      "10.2.0" = {
        tag = "v10.2.0";
        hash = "sha256-Euo9VD4VTpx8XJV97IMETTAx/YkPGXiNdA39Wjp3UMU=";
      };
      "10.3.0" = {
        tag = "v10.3.0";
        hash = "sha256-odSrsfOa8PlbJiPrkvWFm2hHc+ud0qSpLQanx9/M/90=";
      };
      "10.4.0" = {
        tag = "v10.4.0";
        hash = "sha256-GAu/VdHrC3UQw9okPexVItLPrRb1m3ZMpCkHNcfzRkE=";
      };
      "10.5.0" = {
        tag = "v10.5.0";
        hash = "sha256-No0JKfvi6ETXrnebMX+tAVhz7fuuCwYAp/WNUN73XzY=";
      };
      "10.6.0" = {
        tag = "v10.6.0";
        hash = "sha256-nnzicyCjVqpAonIhx3u9yNnoJkZ0XXjJ8oxQH+wfrtE=";
      };
      "10.7.0" = {
        tag = "v10.7.0";
        hash = "sha256-sbp61GverIWrHKvJV+oO9TctFTO4WUmH0oInZIwqF/s=";
      };
      "10.8.0" = {
        tag = "v10.8.0";
        hash = "sha256-SDlTZf8EQBq8vDCH3YFJCROHbf47RB5WUu4esLNpYuA=";
      };
      "10.9.0" = {
        tag = "v10.9.0";
        hash = "sha256-J8K9RjeGIem5ZxXyU+Rne8uBbul54ie6P/Y1In2mQ0g=";
      };
      "10.10.0" = {
        tag = "v10.10.0";
        hash = "sha256-/vkGmH+WKXMXsUizGfjBKRHOp5IpS236eUdCQ8tr1u8=";
      };
      "10.11.0" = {
        tag = "v10.11";
        hash = "sha256-OXI6mR2X+kF/0EO5RSBnnaGjMKD6AkuQMfl0OMzayxc=";
      };
      "10.12.0" = {
        tag = "v10.12.0";
        hash = "sha256-3pFiqDzWcMAk3GfnSOzzInddEfoGX0Fwqb+vEYr9eBw=";
      };
      "10.13.0" = {
        tag = "v10.13.0";
        hash = "sha256-hjl9fKFIE8p05/lmius2vuil6evPbNEjTT9yJyC44FI=";
      };
      "10.13.2" = {
        tag = "v10.13.2";
        hash = "sha256-1t4TyQKGTVPyPPNA3dlVDoBSHXKGcTms8AUejbvtVfw=";
      };
      "10.13.3" = {
        tag = "v10.13.3";
        hash = "sha256-d14R0UmSLT63wlmpCMi9ZvHZjottr8LJfig7EcqxLEY=";
      };
      "10.14.1" = {
        tag = "v10.14";
        hash = "sha256-pWvXpXiUriLDYHqro3HWAmO/9wbGznyUrc9qxq/t0/U=";
      };
    }
  );

  nativeBuildInputs = [
    cmake
    cuda_nvcc
  ];

  postPatch = ''
    nixLog "patching $PWD/CMakeLists.txt to avoid manually setting CMAKE_CXX_COMPILER"
    substituteInPlace "$PWD"/CMakeLists.txt \
      --replace-fail \
        'find_program(CMAKE_CXX_COMPILER NAMES $ENV{CXX} g++)' \
        '# find_program(CMAKE_CXX_COMPILER NAMES $ENV{CXX} g++)'

    nixLog "patching $PWD/CMakeLists.txt to use find_package(CUDAToolkit) instead of find_package(CUDA)"
    substituteInPlace "$PWD"/CMakeLists.txt \
      --replace-fail \
        'find_package(CUDA ''${CUDA_VERSION} REQUIRED)' \
        'find_package(CUDAToolkit REQUIRED)'
  ''
  # CMakeLists.txt only started using CMAKE_CUDA_ARCHITECTURES in 10.9, and this bug was fixed by 10.12.
  +
    optionalString
      (lib.versionAtLeast finalAttrs.version "10.9" && lib.versionOlder finalAttrs.version "10.12")
      ''
        nixLog "patching $PWD/CMakeLists.txt to fix CMake logic error"
        substituteInPlace "$PWD"/CMakeLists.txt \
          --replace-fail \
            'list(APPEND CMAKE_CUDA_ARCHITECTURES SM)' \
            'list(APPEND CMAKE_CUDA_ARCHITECTURES "''${SM}")'
      '';

  cmakeFlags = [
    # Use tensorrt for these components; we only really want the samples.
    (cmakeBool "BUILD_PARSERS" false)
    (cmakeBool "BUILD_PLUGINS" false)
    (cmakeBool "BUILD_SAMPLES" true)

    # Build configuration
    (cmakeFeature "GPU_ARCHS" (replaceStrings [ ";" ] [ " " ] flags.cmakeCudaArchitecturesString))
  ];

  buildInputs = [
    (getInclude cuda_nvcc)
    cuda_cudart
    cuda_profiler_api
    tensorrt
  ];

  passthru = import ./passthru.nix {
    inherit
      backendStdenv
      fetchzip
      finalAttrs
      lib
      runCommand
      stdenvNoCC
      writeShellApplication
      ;
  };

  meta = {
    description = "Open Source Software (OSS) components of NVIDIA TensorRT";
    homepage = "https://github.com/NVIDIA/TensorRT";
    license = licenses.asl20;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    teams = [ teams.cuda ];
    maintainers = with maintainers; [ connorbaker ];
  };
})
