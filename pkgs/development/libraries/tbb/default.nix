{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2021.8.0";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = "refs/tags/v${version}";
    hash = "sha256-7MjUdPB1GsPt7ZkYj7DCisq20X8psljsVCjDpCSTYT4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  patches = [
    # Fix musl build; vendored from https://github.com/oneapi-src/oneTBB/pull/899
    ./musl.patch
  ];

  # Disable failing test on musl
  # test/conformance/conformance_resumable_tasks.cpp:37:24: error: ‘suspend’ is not a member of ‘tbb::v1::task’; did you mean ‘tbb::detail::r1::suspend’?
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    sed -i "/conformance_resumable_tasks/d" test/CMakeLists.txt
  '';

  enableParallelBuilding = true;

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
    maintainers = with maintainers; [ thoughtpolice dizfer ];
  };
}
