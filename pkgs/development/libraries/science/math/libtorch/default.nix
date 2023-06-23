{
  fetchFromGitHub,
  fetchpatch,
  pkgs,
  symlinkJoin,
  # nativeBuildInputs
  asmjit,
  blas,
  cmake,
  config,
  cpuinfo,
  cudaPackages ? {},
  fbgemm,
  flatbuffers,
  fmt,
  fp16,
  fxdiv,
  gflags,
  glog,
  gloo,
  lib,
  magma,
  mpi,
  ninja,
  numactl,
  protobuf,
  psimd,
  pthreadpool,
  python3,
  python3Packages,
  stdenv,
  zlib,
  zstd,
  # configuration flags
  useCuda ? config.cudaSupport or false,
  useCudnn ? useCuda,
  useGloo ? true,
  useMagma ? (useCuda || useRocm),
  useMkldnn ? true,
  useMpi ? false,
  useNuma ? true,
  useRocm ? false,
  useXnnpack ? true,
  useZstd ? true,
}: let
  inherit (lib) lists;
  setBool = bool:
    if bool
    then "ON"
    else "OFF";

  # TODO(@connorbaker): Patches are incompatible with current version
  sleef = pkgs.sleef.overrideAttrs (oldAttrs: {
    patches = [];
    src = oldAttrs.src.override {
      rev = "e0a003ee838b75d11763aa9c3ef17bf71a725bff";
      hash = "sha256-0atbkbLqyMVdZDZiSvGNp7vgZ6/dAQz9BL4Wu2kURlY=";
    };
  });

  # TODO(@connorbaker): Our copy of oneDNN is too new -- PyTorch requires 2.7.x currently.
  # You can see what they're using by checking the third_party/ideep submodule.
  oneDNN = pkgs.oneDNN.overrideAttrs (oldAttrs: let
    version = "2.7.4";
  in {
    inherit version;
    src = oldAttrs.src.override {
      rev = "v${version}";
      # NOTE: The original derivation uses sha256, so we must override that instead of specifying
      # hash. If we specify hash, it will be ignored.
      sha256 = "sha256-wpkZjHy4gDQXbVFAkJLt14D6Y/eEy8mhvjgswX62ABI=";
    };
  });

  # TODO(@connorbaker): API-breaking changes introduced recently in things like
  # - https://github.com/google/XNNPACK/pull/4903
  # - https://github.com/google/XNNPACK/pull/4646
  xnnpack = pkgs.xnnpack.overrideAttrs (oldAttrs: {
    src = oldAttrs.src.override {
      rev = "db68602a37353f3050c1835d5609a1ce1a3f3d2a";
      hash = "sha256-h/dRbFY2BIx/99mZ3MbQY0VdeystLNSDSd9tEfXTV9s=";
    };
  });

  cuda-redist = symlinkJoin {
    name = "cuda-redist";
    paths = with cudaPackages;
      [
        autoAddOpenGLRunpathHook
        cuda_cccl # <thrust> and CUB
        cuda_cudart
        cuda_cupti # Needed by Kineto for GPU profiling
        cuda_nvcc
        cuda_nvml_dev
        cuda_nvrtc
        cuda_nvtx
        libcublas
        libcufft
        libcurand
        libcusolver
        libcusparse
        nccl.dev
      ]
      ++ lists.optionals useCudnn [cudnn];
  };

  mkDerivation =
    if useCuda
    then cudaPackages.backendStdenv.mkDerivation
    else stdenv.mkDerivation;
in
  mkDerivation (finalAttrs: {
    pname = "libtorch";
    version = "2.0.2";
    src = fetchFromGitHub {
      owner = "pytorch";
      repo = "pytorch";
      rev = "0c8323e4a403500ca2ff18910fee8b27c27926e7";
      fetchSubmodules = true;
      hash = "sha256-Da3Nv4+GRnZoDWO7/KNUaxfD71o/Rw86xyxYY9yAxXg=";
    };
    patches = [
      # USE_SYSTEM_*
      (fetchpatch {
        url = "https://github.com/pytorch/pytorch/pull/104576.patch";
        hash = "sha256-7ySVkJlsNrP1GI887XetMBB+Xf5RYFcHiMArsoEvCxI=";
      })
      # Allow newer CUDA capabilities via cpp_extension
      (fetchpatch {
        url = "https://github.com/pytorch/pytorch/pull/104615.patch";
        hash = "sha256-V3SPFKVs4ggrKMysovof3ZXiHCUbgm/u2RyDs3VtZC0=";
      })
    ];

    preConfigure =
      # Enter third_party directory
      ''
        pushd third_party
      ''
      # Remove libraries which are unmaintained or haven't been updated in a long time.
      # - gemmlowp: Dependency of QNNPACK
      # - NNPACK: Superceded by XNNPACK
      # - neon2sse: Dependency of QNNPACK
      # - python-enum: Unused
      # - python-peachpy: NNPACK dependency
      # - python-six: Unused
      # - QNNPACK: Unmaintained, functionality reproduced by PyTorch QNNPACK
      # - tbb: TBB support is deprecated
      # - tensorpipe: Unmaintained
      + ''
        rm -rf gemmlowp*
        rm -rf neon2sse*
        rm -rf NNPACK*
        rm -rf python-enum*
        rm -rf python-peachpy*
        rm -rf python-six*
        rm -rf QNNPACK*
        rm -rf tbb*
        rm -rf tensorpipe*
      ''
      # Remove libraries we've migrated to Nixpkgs
      # NOTE: Cannot remove third_party/ideep* because it is used in the build.
      # However, we can remove third_party/ideep/mkl-dnn.
      + ''
        rm -rf cpuinfo*
        rm -rf cub*
        rm -rf fbgemm*
        rm -rf flatbuffers*
        rm -rf fmt*
        rm -rf FP16*
        rm -rf FXdiv*
        rm -rf gloo*
        rm -rf ideep/mkl-dnn*
        rm -rf protobuf*
        rm -rf psimd*
        rm -rf pthreadpool*
        rm -rf pybind11*
        rm -rf sleef*
        rm -rf xnnpack* XNNPACK*
        rm -rf zstd*
      ''
      # Patch kineto to use our copy of fmt to avoid conflicts caused by it trying to create a
      # library of the same name.
      + ''
        pushd kineto/libkineto
        rm -rf third_party/fmt
        substituteInPlace CMakeLists.txt \
          --replace \
            'if(NOT TARGET fmt)' \
            "$(printf 'find_package(fmt REQUIRED)\nif(FALSE)')" \
          --replace \
            '$<BUILD_INTERFACE:''${FMT_INCLUDE_DIR}>' \
            ""
        popd
      ''
      # Return to root directory
      + ''
        popd
      ''
      # Fix CUDA detection (while keeping FindCUDNN) by forcing use of upstream CMake.
      # TODO(@connorbaker): Install fails because it expects cmake/Modules/FindCUDAToolkit to exist.
      # + ''
      #   rm cmake/Modules/FindCUDAToolkit.cmake
      #   rm -rf cmake/Modules_CUDA_fix/{upstream,FindCUDA.cmake}
      # ''
      # TODO(@connorbaker): The NCCL version check never seems to work (blank version).
      + ''
        substituteInPlace cmake/Modules/FindNCCL.cmake \
          --replace \
            'if (NCCL_VERSION_DEFINED)' \
            'if (FALSE)'
      '';

    # TODO(@connorbaker): Use DISABLE_NNPACK_AND_FAMILY for CUDA builds. Allows us to drop
    # dependencies on pytorch_qnnpack, xnnpack, and pthreadpool.

    # TODO(@connorbaker): Looks like PyTorch disables use of CMAKE_CUDA_ARCHITECTURES?
    # https://github.com/pytorch/pytorch/blob/ea4d5c45385233af6be36aa50a6945ee9c704b74/cmake/public/cuda.cmake#L328-L329

    nativeBuildInputs =
      # Build system
      [
        cmake
        ninja
      ]
      # Core dependencies
      ++ [
        asmjit
        blas.provider
        cpuinfo
        fbgemm
        flatbuffers
        fmt
        fp16
        fxdiv
        gflags
        glog
        protobuf
        psimd
        pthreadpool
        python3
        python3Packages.numpy
        python3Packages.pybind11
        python3Packages.pyyaml
        python3Packages.setuptools
        python3Packages.typing-extensions
        sleef
        zlib
      ]
      # Optional dependencies
      ++ lists.optionals useCuda [cuda-redist]
      ++ lists.optionals useGloo [gloo]
      ++ lists.optionals useMagma [magma]
      ++ lists.optionals useMkldnn [oneDNN.dev] # oneDNN is the new name for MKL-DNN
      ++ lists.optionals useMpi [mpi]
      ++ lists.optionals useNuma [numactl]
      ++ lists.optionals useXnnpack [xnnpack]
      ++ lists.optionals useZstd [zstd.dev];

    cmakeFlags =
      # Core configuration options
      [
        "-DATEN_NO_TEST:BOOL=ON"
        "-DBUILD_PYTHON:BOOL=OFF"
        "-DBUILD_SHARED_LIBS:BOOL=ON"
        "-DCMAKE_BUILD_TYPE:STRING=Release"
        "-DUSE_PRECOMPILED_HEADERS:BOOL=ON"
      ]
      # Core dependencies
      ++ [
        "-DUSE_GLOG:BOOL=ON"
        "-DUSE_GFLAGS:BOOL=ON"
        "-DUSE_SYSTEM_PROTOBUF:BOOL=ON"
        "-DUSE_FBGEMM:BOOL=ON" # TODO(@connorbaker): This is only for x86 builds?
        "-DUSE_PYTORCH_QNNPACK:BOOL=ON" # In-tree and maintained, unlike QNNPACK
        "-DUSE_SYSTEM_CPUINFO:BOOL=ON"
        "-DUSE_SYSTEM_FBGEMM:BOOL=ON"
        "-DUSE_SYSTEM_FLATBUFFERS:BOOL=ON"
        "-DUSE_SYSTEM_FMT:BOOL=ON"
        "-DUSE_SYSTEM_FP16:BOOL=ON"
        "-DUSE_SYSTEM_FXDIV:BOOL=ON"
        "-DUSE_SYSTEM_PSIMD:BOOL=ON"
        "-DUSE_SYSTEM_PTHREADPOOL:BOOL=ON"
        "-DUSE_SYSTEM_PYBIND11:BOOL=ON"
        "-DUSE_SYSTEM_SLEEF:BOOL=ON"
      ]
      # Libraries which should no longer be used because they are not maintained.
      # - NNPACK: https://github.com/Maratyszcza/NNPACK/issues/168#issuecomment-553529745
      # - QNNPACK: https://github.com/pytorch/QNNPACK
      # - TensorPipe: https://github.com/pytorch/tensorpipe
      ++ [
        "-DUSE_NNPACK:BOOL=OFF"
        "-DUSE_QNNPACK:BOOL=OFF"
        "-DUSE_TENSORPIPE:BOOL=OFF"
      ]
      # Optional features
      ++ [
        "-DUSE_CUDA:BOOL=${setBool useCuda}"
        "-DUSE_CUDNN:BOOL=${setBool useCudnn}"
        "-DUSE_GLOO:BOOL=${setBool useGloo}"
        "-DUSE_MAGMA:BOOL=${setBool useMagma}"
        "-DUSE_MKLDNN:BOOL=${setBool useMkldnn}"
        "-DUSE_MPI:BOOL=${setBool useMpi}"
        "-DUSE_NCCL:BOOL=${setBool useCuda}"
        "-DUSE_NUMA:BOOL=${setBool useNuma}"
        "-DUSE_STATIC_NCCL:BOOL=${setBool useCuda}"
        "-DUSE_SYSTEM_GLOO:BOOL=${setBool useGloo}"
        "-DUSE_SYSTEM_NCCL:BOOL=${setBool useCuda}"
        "-DUSE_SYSTEM_MKLDNN:BOOL=${setBool useMkldnn}"
        "-DUSE_SYSTEM_XNNPACK:BOOL=${setBool useXnnpack}"
        "-DUSE_SYSTEM_ZSTD:BOOL=${setBool useZstd}"
        "-DUSE_XNNPACK:BOOL=${setBool useXnnpack}"
        "-DUSE_ZSTD:BOOL=${setBool useZstd}"
      ]
      # Special handling for CUDA
      # TODO(@connorbaker): Generalize to support requested capabilities.
      ++ lists.optionals useCuda [
        "-DTORCH_CUDA_ARCH_LIST:STRING=8.9"
      ];
  })
