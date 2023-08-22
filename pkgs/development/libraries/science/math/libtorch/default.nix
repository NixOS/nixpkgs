{
  fetchFromGitHub,
  fetchpatch,
  pkgs,
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
  onnx,
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
  inherit (lib) lists strings;
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
        rm -rf onnx*
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
        onnx
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
      ++ lists.optionals useCuda (
        # TODO(@connorbaker): Is this correct that we need both cudart and nvcc as native dependencies?
        with cudaPackages; [
          autoAddOpenGLRunpathHook
          cuda_cudart # cuda_runtime.h
          cuda_nvcc # crt/host_config.h
        ]
      )
      ++ lists.optionals useGloo [gloo]
      ++ lists.optionals useMagma [magma]
      ++ lists.optionals useMkldnn [oneDNN.dev] # oneDNN is the new name for MKL-DNN
      ++ lists.optionals useMpi [mpi]
      ++ lists.optionals useNuma [numactl]
      ++ lists.optionals useXnnpack [xnnpack]
      ++ lists.optionals useZstd [zstd.dev];

    # TODO(@connorbaker): Currently CUDA build fails with:
    # CMake Error at cmake/public/cuda.cmake:65 (message):
    #   Found two conflicting CUDA installs:
    #
    #   V11.8.89 in
    #   '/nix/store/rsjxr5b5zifa0wbpziwqfzg7lncfz0f0-cuda_cudart-11.8.89/include'
    #   and
    #
    #   V11.8.89 in
    #   '/nix/store/rsjxr5b5zifa0wbpziwqfzg7lncfz0f0-cuda_cudart-11.8.89/include;/nix/store/nljxvgbp6fy0q7cbrp5l5igv57p5fa3v-cuda_nvcc-11.8.89/include;/nix/store/mfk63jcw2r77asgai82rzbzbph10dhh8-cuda_cccl-11.8.89/include;/nix/store/0xhbghrnf7x289m78c8ha2dm6n83wfbg-cuda_cupti-11.8.87/include;/nix/store/4x7gb192a6pskj2skwn9s3m0vnn73bff-cuda_nvml_dev-11.8.86/include;/nix/store/00p0i6kqw6qjbrc4fddqfnv07zcg7gi1-cuda_nvrtc-11.8.89/include;/nix/store/953p97p0inb7wdj50qcz47dy3lh58vhq-cuda_nvtx-11.8.86/include;/nix/store/qsm8bjydfnapr77wzlyzyzcsnkc0yrh2-libcublas-11.11.3.6/include;/nix/store/fszipvg6jw9dsj2lz1izwy7363mwh4fj-libcufft-10.9.0.58/include;/nix/store/8r9kj0rh0kk9iqi32kkm1bdxqb8jipbr-libcurand-10.3.0.86/include;/nix/store/f0d08h7g4apgngbyrgqvpjxmlp3azf0m-libcusolver-11.4.1.48/include;/nix/store/141gw8r2ypg27186mzg81rhndl402l80-libcusparse-11.7.5.86/include;/nix/store/z5ppzlnw5wzy5bbvhm76kfmjmirpkqhb-cuda_profiler_api-11.8.86/include'
    buildInputs = lists.optionals useCuda (with cudaPackages;
      [
        (lib.getDev nccl)
        cuda_cccl # <thrust/*>
        cuda_cupti
        cuda_nvml_dev # <nvml.h>
        cuda_nvrtc
        cuda_nvtx # -llibNVToolsExt
        libcublas
        libcufft
        libcurand
        libcusolver
        libcusparse
        nccl
      ]
      ++ lists.optionals useCudnn [cudnn]
      ++ lists.optionals (strings.versionOlder cudaVersion "11.8") [
        cuda_nvprof # <cuda_profiler_api.h>
      ]
      ++ lists.optionals (strings.versionAtLeast cudaVersion "11.8") [
        cuda_profiler_api # <cuda_profiler_api.h>
      ]);

    cmakeFlags =
      # Core configuration options
      [
        "-DATEN_NO_TEST:BOOL=ON"
        "-DBUILD_PYTHON:BOOL=OFF"
        "-DBUILD_SHARED_LIBS:BOOL=ON"
        "-DCMAKE_BUILD_TYPE:STRING=Release"
        "-DCMAKE_C_STANDARD:STRING=17"
        "-DCMAKE_CXX_STANDARD:STRING=17"
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
        "-DUSE_SYSTEM_ONNX:BOOL=ON"
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
