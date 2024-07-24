{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2021.5.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = "v${version}";
    hash = "sha256-TJ/oSSMvgtKuz7PVyIoFEbBW6EZz7t2wr/kP093HF/w=";
  };

  nativeBuildInputs = [
    cmake
  ];

  patches = [
    # port of https://github.com/oneapi-src/oneTBB/pull/1031
    ./gcc13-fixes-2021.5.0.patch

    (fetchpatch {
      #  Fix "field used uninitialized" on modern gcc versions (https://github.com/oneapi-src/oneTBB/pull/958)
      url = "https://github.com/oneapi-src/oneTBB/commit/3003ec07740703e6aed12b028af20f4b0f16adae.patch";
      hash = "sha256-l4+9IxIEdRX/q8JyDY9CPKWzSLatpIVSiNjmIM7ilj0=";
    })
  ];

  # Disable failing test on musl
  # test/conformance/conformance_resumable_tasks.cpp:37:24: error: ‘suspend’ is not a member of ‘tbb::v1::task’; did you mean ‘tbb::detail::r1::suspend’?
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace test/CMakeLists.txt \
      --replace-fail 'conformance_resumable_tasks' ""
  '';

  # Fix build with modern gcc
  # In member function 'void std::__atomic_base<_IntTp>::store(__int_type, std::memory_order) [with _ITp = bool]',
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [ "-Wno-error=array-bounds" "-Wno-error=stringop-overflow" "-Wno-address" ] ++
    # error: variable 'val' set but not used
    lib.optionals stdenv.cc.isClang [ "-Wno-error=unused-but-set-variable" ] ++
    # Workaround for gcc-12 ICE when using -O3
    # https://gcc.gnu.org/PR108854
    lib.optionals (stdenv.cc.isGNU && stdenv.isx86_32) [ "-O2" ];

  # Fix undefined reference errors with version script under LLVM.
  NIX_LDFLAGS = lib.optionalString (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17") "--undefined-version";


  meta = with lib; {
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = licenses.asl20;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice tmarkus ];
  };
}
