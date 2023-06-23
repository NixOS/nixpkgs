{
  config,
  fetchFromGitHub,
  lib,
  stdenv,
  # nativeBuildInputs
  cmake,
  ninja,
  pkg-config, # to find libuv
  # buildInputs
  cudaPackages, # for cuda
  openssl,
  pkgsStatic, # for libuv
  # checkInputs
  gtest,
  # Configuration options
  buildSharedLibs ? true,
  useCuda ? config.cudaSupport or false,
  useLibUv ? true,
}: let
  inherit (lib) lists strings;
  inherit
    (cudaPackages)
    autoAddOpenGLRunpathHook
    backendStdenv
    cuda_cudart
    cuda_nvcc
    cudaFlags
    nccl
    ;
  cudaArchitectures = builtins.map cudaFlags.dropDot cudaFlags.cudaCapabilities;
  cudaArchitecturesString = strings.concatStringsSep " " cudaArchitectures;

  setBuildSharedLibrary = bool:
    if bool
    then "shared"
    else "static";
  setBool = bool:
    if bool
    then "ON"
    else "OFF";
in
  stdenv.mkDerivation (finalAttrs: {
    strictDeps = true;
    pname = "gloo";
    version = finalAttrs.src.rev;
    src = fetchFromGitHub {
      owner = "facebookincubator";
      repo = finalAttrs.pname;
      rev = "c6f3a5bcf568dafc9a8ae482e8cc900633dd6db1";
      hash = "sha256-4Ny0Dnd1NTGPHAAyHJeY5HtZIYcNkdu+T3G7ZaQ6uMY=";
    };
    nativeBuildInputs =
      [
        cmake
        ninja
        pkg-config
      ]
      ++ lists.optionals useCuda [autoAddOpenGLRunpathHook];
    buildInputs =
      [openssl]
      # Requires static libuv for some reason
      ++ lists.optionals useLibUv [pkgsStatic.libuv]
      ++ lists.optionals useCuda [
        cuda_cudart
        cuda_nvcc # crt/host_config.h
        nccl
      ];

    postPatch =
      # Gloo won't build with OpenSSL != 1.1 at the moment. See
      # https://github.com/facebookincubator/gloo/issues/358 for more.
      ''
        substituteInPlace gloo/CMakeLists.txt \
          --replace \
            'find_package(OpenSSL 1.1 REQUIRED EXACT)' \
            'find_package(OpenSSL REQUIRED)'
        substituteInPlace gloo/test/CMakeLists.txt \
          --replace \
            'find_package(OpenSSL 1.1 REQUIRED EXACT)' \
            'find_package(OpenSSL REQUIRED)'
      ''
      # Gloo doesn't allow us to manually specify exactly what architectures to build for,
      # so we do a bit of hack and change the list of known architectures to the one we want.
      + strings.optionalString useCuda ''
        substituteInPlace cmake/Cuda.cmake \
          --replace \
            'set(gloo_known_gpu_archs ' \
            'set(gloo_known_gpu_archs "${cudaArchitecturesString}") #'
      '';

    cmakeFlags =
      [
        "-DBUILD_BENCHMARK:BOOL=OFF" # Produces binaries in out
        "-DBUILD_SHARED_LIBS:STRING=${setBuildSharedLibrary buildSharedLibs}"
        "-DBUILD_TEST:BOOL=${setBool finalAttrs.doCheck}"
        "-DGLOO_USE_CUDA_TOOLKIT:BOOL=OFF" # We use redistributables, not the toolkit
        "-DUSE_CUDA:BOOL=${setBool useCuda}"
        "-DUSE_IBVERBS:BOOL=OFF"
        "-DUSE_LIBUV:BOOL=${setBool useLibUv}"
        "-DUSE_NCCL:BOOL=${setBool useCuda}"
        "-DUSE_RCCL:BOOL=OFF"
        "-DUSE_REDIS:BOOL=OFF"
        "-DUSE_TCP_OPENSSL_LINK:BOOL=OFF"
        "-DUSE_TCP_OPENSSL_LOAD:BOOL=ON" # default for PyTorch
      ]
      ++ lists.optionals useCuda [
        "-DCMAKE_C_COMPILER:FILEPATH=${backendStdenv.cc}/bin/cc"
        "-DCMAKE_CXX_COMPILER:FILEPATH=${backendStdenv.cc}/bin/c++"
      ];

    doCheck = false;
    checkInputs = [gtest];

    meta = with lib; {
      description = "Collective communications library with various primitives for multi-machine training";
      homepage = "https://github.com/facebookincubator/gloo";
      license = licenses.bsd2;
      maintainers = with maintainers; [connorbaker];
      platforms = platforms.all;
    };
  })
