{
  autoAddDriverRunpath,
  aws-sdk-cpp,
  backendStdenv,
  boost,
  cfitsio,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cuda_nvml_dev,
  cudaNamePrefix,
  cutlass,
  dlpack,
  fetchFromGitHub,
  fetchpatch2,
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
  nvtx,
  opencv4WithoutCuda,
  pkg-config,
  protobuf,
  python3,
  rapidjson,
  # DALI only uses the S3 client.
  aws-sdk-cpp-s3 ? aws-sdk-cpp.override { apis = [ "s3" ]; },
}:
let
  inherit (lib) cmakeBool cmakeFeature getLib;
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "dali";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "DALI";
    tag = "v${finalAttrs.version}";
    # DALI builds CV-CUDA (a subset of its operators), FFTS (a fork) and the COCO API from the submodules.
    fetchSubmodules = true;
    # Fetch only those; the others are replaced by Nixpkgs packages or unused. Without a pathspec, `git submodule update
    # --init` initializes (and so clones) only the submodules whose path matches a submodule.active pattern, and sets no
    # submodule.<name>.active (which would outrank the patterns). The patterns are matched in every repository, nested
    # ones included, so CV-CUDA's own submodules (under 3rdparty) and any submodule a later version adds at another path
    # are left as empty directories. They are GIT_CONFIG_* entries, appended like nix-prefetch-git's own, because
    # fetchgit's gitConfigFile would replace the user's config.gitConfigFile.
    preFetch = ''
      for path in third_party/{cocoapi,cvcuda,ffts}; do
        i=''${GIT_CONFIG_COUNT:-0}
        export GIT_CONFIG_COUNT=$((i + 1)) "GIT_CONFIG_KEY_$i=submodule.active" "GIT_CONFIG_VALUE_$i=$path"
      done
    '';
    hash = "sha256-NTRJFhOe5CtjOuPFDZmNuAUV9zkRG8g0aE2/2QClfaU=";
  };

  patches = [
    # Update nvCOMP to 6.0: DALI 2.4.0 loads libnvcomp.so.5 and uses the nvCOMP 5 LZ4 API, while Nixpkgs has nvCOMP 6.
    # The two commits of https://github.com/NVIDIA/DALI/pull/6530, ad607fa44f20392718258fc2a6a28ecf1b79590b and
    # 9c3b5760bfe021d0d6f974ad1559bcc13c7c463c, which apply to 2.4.0 as they are. The PR is open (a draft), so they are
    # vendored with `git format-patch` (a rebase of the PR could let GitHub garbage-collect them).
    ./nvcomp-6.patch
    ./nvcomp-6-batch-staging-copies.patch
    # Find the headers of the CUDA libraries DALI generates dlopen stubs from (the driver, cuFile, cuFFT, NPP and NVML)
    # with find_path, instead of expecting them in CUDAToolkit_TARGET_DIR/include, which is cuda_nvcc's.
    # From https://github.com/NVIDIA/DALI/pull/6550, merged after 2.4.0.
    (fetchpatch2 {
      name = "find-cuda-library-headers.patch";
      url = "https://github.com/NVIDIA/DALI/commit/e6dd6294ecbb6aa242da5d7864208a466d22bac2.patch?full_index=1";
      hash = "sha256-6rdej/M7LjHkXUHexRIUvYlSKq/aeQjdZXrdk3o4Mag=";
    })
    # Warn instead of failing when the old thread pool (which the mixed image decoder uses) can't pin its threads to the
    # GPU's CPUs, as when NVML can't read the CPU topology from /sys, which the sandbox lacks
    # (https://github.com/NVIDIA/DALI/issues/6551). From https://github.com/NVIDIA/DALI/pull/6552, which is open, so it
    # is vendored, without its tests: `git format-patch -1 5e1262eed055a93fa9c4eea7b3bee8178ca3abd6 --
    # dali/pipeline/util/thread_pool.cc`.
    ./warn-on-old-thread-pool-affinity-failures.patch
    # DALI builds only some CV-CUDA operators (CV_CUDA_SRC_PATERN), not FindHomography, the only user of cuSOLVER and
    # cuBLAS; link them only when FindHomography is built, instead of requiring their static libraries
    # (https://github.com/CVCUDA/CV-CUDA/issues/302). CV-CUDA doesn't accept outside contributions, so the fix is
    # vendored: `git format-patch -1 --src-prefix=a/third_party/cvcuda/ --dst-prefix=b/third_party/cvcuda/` of
    # https://github.com/ConnorBaker/CV-CUDA/commit/7fa7b7bedd46a6e346d2bf1504388e7dd00138ed, the backport of
    # https://github.com/ConnorBaker/CV-CUDA/commit/e9ecacfcedf41b9c4518696c268e2518c3133643 to ef50300b (DALI 2.4.0's
    # third_party/cvcuda). The prefixes apply it to the submodule's checkout.
    ./cvcuda-link-solver-only-for-find-homography.patch
  ];

  # Use the header-only Boost.Preprocessor, RapidJSON, CUTLASS and DLPack of Nixpkgs instead of the submodules.
  postPatch =
    # Replaces third_party/boost/preprocessor, third_party/rapidjson and third_party/cutlass. DALI uses none of the
    # CUTLASS utilities (tools/util), which Nixpkgs' CUTLASS installs only with its tools.
    ''
      substituteInPlace cmake/Dependencies.common.cmake \
        --replace-fail \
          "\''${PROJECT_SOURCE_DIR}/third_party/boost/preprocessor/include" \
          "${lib.getDev boost}/include" \
        --replace-fail \
          "\''${PROJECT_SOURCE_DIR}/third_party/rapidjson/include" \
          "${lib.getDev rapidjson}/include" \
        --replace-fail \
          "include_directories(SYSTEM third_party/cutlass/include)" \
          "include_directories(SYSTEM ${lib.getInclude cutlass}/include)" \
        --replace-fail \
          "include_directories(SYSTEM third_party/cutlass/tools/util/include)" \
          ""
    ''
    # Replaces third_party/dlpack.
    + ''
      substituteInPlace dali/pipeline/data/dltensor.h dali/pipeline/data/dltensor_obj.h \
        --replace-fail '"third_party/dlpack/include/dlpack/dlpack.h"' "<dlpack/dlpack.h>"
    ''
    # Replaces third_party/boost/preprocessor as the source of the Boost.Preprocessor headers that the Python package
    # ships with its own (for building plugins).
    + ''
      substituteInPlace dali/CMakeLists.txt \
        --replace-fail \
          'cp -rL "''${PROJECT_SOURCE_DIR}/third_party/boost/preprocessor/include/." "''${PROJECT_BINARY_DIR}/''${DALI_INCLUDE_DIR}/"' \
          'cp -rL --no-preserve=mode --parents boost/preprocessor boost/preprocessor.hpp "''${PROJECT_BINARY_DIR}/''${DALI_INCLUDE_DIR}/" WORKING_DIRECTORY "${lib.getDev boost}/include"'
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
    # Replaces the Boost.Preprocessor submodule (third_party/boost/preprocessor)
    boost
    cfitsio
    cuda_cudart
    (lib.getOutput "static" cuda_cudart)
    cuda_nvml_dev
    # Replaces the CUTLASS submodule (third_party/cutlass)
    cutlass
    # Replaces the DLPack submodule (third_party/dlpack)
    dlpack
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
    nvtx
    # DALI only uses OpenCV's CPU core and imgproc modules.
    opencv4WithoutCuda
    protobuf
    # Replaces the RapidJSON submodule (third_party/rapidjson)
    rapidjson
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
    # Google Cloud Storage support needs google-cloud-cpp 3.0 or later, which Nixpkgs doesn't have; DALI would turn it
    # off with a warning.
    (cmakeBool "BUILD_GCS" false)

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
