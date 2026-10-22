{
  autoAddDriverRunpath,
  aws-sdk-cpp,
  backendStdenv,
  cfitsio,
  cmake,
  cuda_crt,
  cuda_cudart,
  cuda_nvcc,
  cuda_nvml_dev,
  cuda_nvtx,
  cudaAtLeast,
  cudaNamePrefix,
  fetchFromGitHub,
  ffmpeg_8-headless,
  flags,
  gitUpdater,
  lib,
  libcufft,
  libcufile,
  libcurand,
  libnpp,
  libsndfile,
  libtar,
  lmdb,
  ninja,
  nvcomp,
  nvimgcodec,
  opencv4WithoutCuda,
  pkg-config,
  protobuf,
  python3,
  symlinkJoin,
  # DALI only uses the S3 client.
  aws-sdk-cpp-s3 ? aws-sdk-cpp.override { apis = [ "s3" ]; },
}:
let
  inherit (lib) cmakeBool cmakeFeature getLib;

  # DALI expects the headers of the CUDA libraries in a single directory, CUDAToolkit_TARGET_DIR/include, where it
  # generates the stubs of the libraries it loads with dlopen from.
  cudaHeaders = symlinkJoin {
    name = "${cudaNamePrefix}-dali-cuda-headers";
    paths = map (lib.getOutput "include") (
      [
        cuda_cudart
        cuda_nvcc
        cuda_nvml_dev
        libcufft
        libcufile
        libnpp
      ]
      # The CRT headers moved out of cuda_nvcc in CUDA 13.
      ++ lib.optionals (cudaAtLeast "13.0") [ cuda_crt ]
    );
  };
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "dali";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "DALI";
    tag = "v${finalAttrs.version}";
    # DALI builds CV-CUDA (a subset of its operators), FFTS (a fork) and the COCO API from the submodules, and uses the
    # header-only CUTLASS, Boost.Preprocessor, RapidJSON and DLPack from them.
    fetchSubmodules = true;
    hash = "sha256-T+ysSFVVDZn4rT99GavDDyjBerRWjZqI0uigSrbTIu4=";
  };

  patches = [
    # Update nvCOMP to 6.0 (https://github.com/NVIDIA/DALI/pull/6530): DALI 2.3.0 loads libnvcomp.so.5 and uses the
    # nvCOMP 5 LZ4 API, while Nixpkgs has nvCOMP 6.
    ./nvcomp-6.patch
    ./nvcomp-6-batch-staging-copies.patch
  ];

  postPatch = ''
    substituteInPlace \
      dali/core/CMakeLists.txt \
      dali/kernels/signal/fft/CMakeLists.txt \
      dali/npp/CMakeLists.txt \
      dali/nvimgcodec/CMakeLists.txt \
      dali/operators/video/dynlink_nvcuvid/CMakeLists.txt \
      dali/util/CMakeLists.txt \
      --replace-fail "\''${CUDAToolkit_TARGET_DIR}/include" "${cudaHeaders}/include"
  ''
  # DALI builds only some CV-CUDA operators (CV_CUDA_SRC_PATERN), not FindHomography, the only user of cuSOLVER and
  # cuBLAS, which would otherwise be linked statically.
  + ''
    substituteInPlace third_party/cvcuda/src/cvcuda/priv/CMakeLists.txt \
      --replace-fail "CUDA::cusolver_static" "" \
      --replace-fail "CUDA::cublas_static" "" \
      --replace-fail "CUDA::cublasLt_static" ""
  '';

  nativeBuildInputs = [
    autoAddDriverRunpath
    cmake
    cuda_nvcc
    ninja
    pkg-config
    protobuf
    # Generates the stubs for the libraries loaded with dlopen (CUDA driver, nvCOMP, cuFile) from their headers with
    # libclang.
    (python3.pythonOnBuildForHost.withPackages (ps: [ ps.clang ]))
  ];

  buildInputs = [
    aws-sdk-cpp-s3
    cfitsio
    cuda_cudart
    (lib.getOutput "static" cuda_cudart)
    cuda_nvml_dev
    cuda_nvtx
    ffmpeg_8-headless
    libcufft
    libcufile
    libcurand
    libnpp
    libsndfile
    libtar
    lmdb
    nvcomp
    nvimgcodec
    # DALI only uses OpenCV's CPU core and imgproc modules.
    opencv4WithoutCuda
    protobuf
  ];

  cmakeFlags = [
    # Selects the CUDA_known_archs set and the dependency file (aarch64-linux is the Jetson cross-compilation setup).
    (cmakeFeature "ARCH" backendStdenv.hostPlatform.parsed.cpu.name)
    # DALI appends PTX for the last architecture.
    (cmakeFeature "CUDA_TARGET_ARCHS" flags.cmakeCudaArchitecturesString)

    (cmakeBool "BUILD_PYTHON" false)
    (cmakeBool "BUILD_TEST" false)
    (cmakeBool "BUILD_BENCHMARK" false)
    (cmakeBool "FORMAT_PYTHON_STUB_FILES" false)

    # Load the CUDA libraries (cuFFT, NPP) and nvCOMP with dlopen, like the wheels and conda-forge, instead of linking
    # them statically. The CUDA driver is loaded with dlopen as well (LINK_DRIVER defaults to OFF).
    (cmakeBool "WITH_DYNAMIC_CUDA_TOOLKIT" true)
    # Off by default
    (cmakeBool "BUILD_NVCOMP" true)
    (cmakeBool "BUILD_CUFILE" true)
    # nvImageCodec is loaded with dlopen by default; it can only be linked statically when DALI builds it itself (as an
    # ExternalProject cloned from GitHub).
    (cmakeFeature "NVIMGCODEC_DEFAULT_INSTALL_PATH" "${getLib nvimgcodec}")
    # The other optional features (NVDEC, optical flow, NVML, CV-CUDA, the AWS SDK, cfitsio, libsndfile, libtar and
    # LMDB) are on by default.

    # Links CV-CUDA against stubs of glibc 2.17's libdl, librt and libpthread, which are Git LFS objects (missing from
    # the source), to run on distributions with an older glibc.
    (cmakeBool "ENABLE_COMPAT_OLD_GLIBC" false)
    # Defaults to the static library
    (cmakeBool "Protobuf_USE_STATIC_LIBS" false)
  ];

  # CV-CUDA installs an /etc/ld.so.conf.d drop-in for its libraries, which DALI's libraries find through their runpath.
  postInstall = ''
    rm -r "$out/etc"
  '';

  # The libraries DALI loads with dlopen aren't in DT_NEEDED, so they must be added to the runpath after it is shrunk.
  # The CUDA driver and its NVDEC, NVML and optical flow libraries come from autoAddDriverRunpath.
  postFixup = ''
    for lib in "$out"/lib/libdali*.so; do
      patchelf --add-rpath "${
        lib.makeLibraryPath [
          libcufft
          libcufile
          libnpp
          nvcomp
          nvimgcodec
        ]
      }" "$lib"
    done
  '';

  passthru.updateScript = gitUpdater {
    inherit (finalAttrs) pname version;
    rev-prefix = "v";
    # Skip the tags of the development branches (e.g. v2.4.0-dev)
    ignoredVersions = "-dev$";
  };

  meta = {
    description = "GPU-accelerated library for data loading and pre-processing for deep learning";
    homepage = "https://github.com/NVIDIA/DALI";
    changelog = "https://github.com/NVIDIA/DALI/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      # Bundled third-party code (see Acknowledgements.txt)
      bsd2
      bsd3
      mit
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
  };
})
