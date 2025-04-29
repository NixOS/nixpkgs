{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tbb";
  version = "2021.13.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZoUzY71SweVQ8/1k09MNSXiEqab6Ae+QTbxORnar9JU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  patches = [
    # Fix musl build from https://github.com/oneapi-src/oneTBB/pull/899
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/oneapi-src/oneTBB/pull/899.patch";
      hash = "sha256-kU6RRX+sde0NrQMKlNtW3jXav6J4QiVIUmD50asmBPU=";
    })
  ];

  cmakeFlags = [
    # Skip tests to work around https://github.com/uxlfoundation/oneTBB/issues/1695
    (lib.cmakeBool "TBB_TEST" (!stdenv.hostPlatform.isWindows))
  ];

  # Fix build with modern gcc
  # In member function 'void std::__atomic_base<_IntTp>::store(__int_type, std::memory_order) [with _ITp = bool]',
  NIX_CFLAGS_COMPILE =
    lib.optionals stdenv.cc.isGNU [
      "-Wno-error=array-bounds"
      "-Wno-error=stringop-overflow"
    ]
    ++
      # error: variable 'val' set but not used
      lib.optionals stdenv.cc.isClang [ "-Wno-error=unused-but-set-variable" ]
    ++
      # Workaround for gcc-12 ICE when using -O3
      # https://gcc.gnu.org/PR108854
      lib.optionals (stdenv.cc.isGNU && stdenv.hostPlatform.isx86_32) [ "-O2" ];

  # Fix undefined reference errors with version script under LLVM.
  NIX_LDFLAGS = lib.optionalString (
    stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
  ) "--undefined-version";

  # Disable failing test on musl
  # test/conformance/conformance_resumable_tasks.cpp:37:24: error: ‘suspend’ is not a member of ‘tbb::v1::task’; did you mean ‘tbb::detail::r1::suspend’?
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace test/CMakeLists.txt \
      --replace-fail 'tbb_add_test(SUBDIR conformance NAME conformance_resumable_tasks DEPENDENCIES TBB::tbb)' ""
  '';

  enableParallelBuilding = true;

  meta = {
    changelog = "https://github.com/uxlfoundation/oneTBB/releases/tag/v${finalAttrs.version}";
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = lib.licenses.asl20;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [
      thoughtpolice
      tmarkus
    ];
  };
})
