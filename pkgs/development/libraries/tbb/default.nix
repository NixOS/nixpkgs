{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2021.8.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = "v${version}";
    hash = "sha256-7MjUdPB1GsPt7ZkYj7DCisq20X8psljsVCjDpCSTYT4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  patches = [
    # Fix musl build from https://github.com/oneapi-src/oneTBB/pull/899
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/oneapi-src/oneTBB/pull/899.patch";
      hash = "sha256-kU6RRX+sde0NrQMKlNtW3jXav6J4QiVIUmD50asmBPU=";
    })

    # Fix/suppress warnings on gcc12.1 from https://github.com/oneapi-src/oneTBB/pull/866
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/oneapi-src/oneTBB/pull/866.patch";
      hash = "sha256-e44Yv84Hfl5xoxWWTnLJLSGeNA1RBbah4/L43gPLS+c=";
    })
  ];

  # Fix build with modern gcc
  # In member function 'void std::__atomic_base<_IntTp>::store(__int_type, std::memory_order) [with _ITp = bool]',
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [ "-Wno-error=stringop-overflow" ] ++
    # Workaround for gcc-12 ICE when using -O3
    # https://gcc.gnu.org/PR108854
    lib.optionals (stdenv.cc.isGNU && stdenv.isx86_32) [ "-O2" ];

  # Disable failing test on musl
  # test/conformance/conformance_resumable_tasks.cpp:37:24: error: ‘suspend’ is not a member of ‘tbb::v1::task’; did you mean ‘tbb::detail::r1::suspend’?
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace test/CMakeLists.txt \
      --replace 'conformance_resumable_tasks' ""
  '';

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
