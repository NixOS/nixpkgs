{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tbb";
  version = "2022.2.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ASQPAGm5e4q7imvTVWlmj5ON4fGEao1L5m2C5wF7EhI=";
  };

  patches = [
    # <https://github.com/uxlfoundation/oneTBB/pull/899>
    ./fix-musl-build.patch

    # <https://github.com/uxlfoundation/oneTBB/pull/987>
    ./fix-32-bit-powerpc-build.patch

    # Fix an assumption that `libtbbmalloc` can pass a relative path to
    # `dlopen(3)` to find itself. This caused mysterious crashes on
    # macOS, where we do not use run paths by default.
    #
    # <https://github.com/uxlfoundation/oneTBB/pull/1849>
    ./fix-libtbbmalloc-dlopen.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    ctestCheckHook
  ];

  doCheck = true;

  dontUseNinjaCheck = true;

  # The memory leak test fails on static Linux, despite passing on
  # dynamic Musl.
  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic) [
    "test_arena_constraints"
  ];

  # Disable failing test on musl
  # test/conformance/conformance_resumable_tasks.cpp:37:24: error: ‘suspend’ is not a member of ‘tbb::v1::task’; did you mean ‘tbb::detail::r1::suspend’?
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace test/CMakeLists.txt \
      --replace-fail 'tbb_add_test(SUBDIR conformance NAME conformance_resumable_tasks DEPENDENCIES TBB::tbb)' ""
  '';

  env = {
    # Fix build with modern gcc
    # In member function 'void std::__atomic_base<_IntTp>::store(__int_type, std::memory_order) [with _ITp = bool]',
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=stringop-overflow";

    # Fix undefined reference errors with version script under LLVM.
    NIX_LDFLAGS = lib.optionalString (
      stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
    ) "--undefined-version";
  };

  meta = {
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
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      silvanshade
      thoughtpolice
      tmarkus
    ];
  };
})
