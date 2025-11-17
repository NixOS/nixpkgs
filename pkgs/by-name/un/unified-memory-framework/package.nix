{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  lib,
  cmake,
  ninja,
  level-zero,
  hwloc,
  autoconf,
  onetbb,
  numactl,
  jemalloc,
  pkg-config,
  cudaPackages,
  useJemalloc ? true,
  config,
  cudaSupport ? config.cudaSupport,
  ctestCheckHook,
  gtest,
  gbenchmark,
  python3,
  sphinx,
  buildDocs ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unified-memory-framework";
  version = "1.0.3";

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ lib.optionals useJemalloc [
    autoconf
  ]
  ++ lib.optionals buildDocs [
    python3
    sphinx
  ];

  buildInputs = [
    onetbb
    level-zero
  ]
  ++ lib.optionals useJemalloc [
    hwloc
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ]
  ++ lib.optionals finalAttrs.doCheck [
    numactl
    gtest
    gbenchmark
  ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "unified-memory-framework";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j7qQwBetICf1sTz+ssZQLm9P0SiH68lcEvtV1YLuW5s=";
  };

  patches = [
    (fetchpatch {
      name = "gtest-use-find_package.patch";
      url = "https://github.com/oneapi-src/unified-memory-framework/commit/503d302a72f719a3f11fce0e610f07a3793549d9.patch";
      hash = "sha256-T29pJuWGcj/Kfw3VNW5lNBG5OrBsB1UAvwroQ+km4Vs=";
    })
  ];

  postPatch = ''
    # The CMake tries to find out the version via git.
    # Since we're not in a clone, git describe won't work.
    substituteInPlace cmake/helpers.cmake \
      --replace-fail "git describe --always" "echo v${finalAttrs.version}"

    # By default, it'd try to install into the CMake binary dir,
    # causing the package to link to /build
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${jemalloc_targ_BINARY_DIR}" "$out/jemalloc"
  '';

  # If included, jemalloc needs to be vendored, as they don't support using a pre-built version
  # and they compile with specific flags that the nixpkgs version doesn't (and shouldn't) set.
  # autoconf wants to write files, so we copy the source to the build directory
  # where we can make it writable
  preConfigure = lib.optionalString useJemalloc ''
    # by default this will point to /build/jemalloc
    cp -r ${jemalloc.src} ../jemalloc
    chmod -R u+w ../jemalloc
  '';

  preInstall = lib.optionalString useJemalloc ''
    mkdir -p $out/jemalloc
  '';

  cmakeFlags = [
    (lib.cmakeBool "UMF_BUILD_CUDA_PROVIDER" cudaSupport)
    (lib.cmakeBool "UMF_BUILD_LEVEL_ZERO_PROVIDER" true)

    (lib.cmakeBool "UMF_BUILD_LIBUMF_POOL_JEMALLOC" useJemalloc)

    (lib.cmakeBool "UMF_BUILD_TESTS" finalAttrs.doCheck)
    # We won't be able to run these inside the sandbox, so no use in building them
    (lib.cmakeBool "UMF_BUILD_GPU_TESTS" false)
    (lib.cmakeBool "UMF_BUILD_BENCHMARKS" false)
    (lib.cmakeBool "UMF_BUILD_EXAMPLES" false)
    (lib.cmakeBool "UMF_BUILD_GPU_EXAMPLES" false)
  ]
  ++ lib.optionals useJemalloc [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)

    # by default this will point to /build/jemalloc
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JEMALLOC_TARG" "../../jemalloc")
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  doCheck = true;
  dontUseNinjaCheck = true;

  NIX_LDFLAGS = lib.optionalString finalAttrs.doCheck "-rpath ${
    lib.makeLibraryPath [
      onetbb
    ]
  }";

  disabledTests = [
    # These tests try to access sysfs, which is unavailable in the sandbox
    "test_memspace_highest_capacity"
    "test_memtarget"
    "test_provider_tracking_fixture_tests"
    "test_scalable_coarse_file"

    # Flaky
    "test_provider_file_memory_ipc"
  ];

  meta = {
    homepage = "https://github.com/oneapi-src/unified-memory-framework";
    changelog = "https://github.com/oneapi-src/unified-memory-framework/releases/tag/v${finalAttrs.version}";
    description = "Library for constructing allocators and memory pools";
    longDescription = ''
      A library for constructing allocators and memory pools.
      It also contains broadly useful abstractions and utilities for memory management.
      UMF allows users to manage multiple memory pools characterized by different attributes,
      allowing certain allocation types to be isolated from others and allocated using different hardware resources as required.
    '';
    platforms = lib.platforms.all;
    license = [
      lib.licenses.asl20
      lib.licenses.llvm-exception
    ];
    maintainers = [ lib.maintainers.blenderfreaky ];
  };
})
