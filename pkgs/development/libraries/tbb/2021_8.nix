{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, cmake
}:

stdenv.mkDerivation rec {
  inherit (import ./common.nix { inherit lib; })
    pname enableParallelBuilding meta;

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
    # Fix musl build; vendored from https://github.com/oneapi-src/oneTBB/pull/899
    ./musl.patch

    # Fix/suppress warnings on gcc12.1 from https://github.com/oneapi-src/oneTBB/pull/866
    (fetchurl {
      url = "https://patch-diff.githubusercontent.com/raw/oneapi-src/oneTBB/pull/866.patch";
      sha256 = "sha256-zT+tRPnPVGUqKvob0RWjASRm4bPYYLtaaqTzA4EdU/8=";
    })
  ];


  # Fix build with modern gcc
  # In member function 'void std::__atomic_base<_IntTp>::store(__int_type, std::memory_order) [with _ITp = bool]',
  
  # Disable failing test on musl
  # test/conformance/conformance_resumable_tasks.cpp:37:24: error: ‘suspend’ is not a member of ‘tbb::v1::task’; did you mean ‘tbb::detail::r1::suspend’?
  postPatch = ''
    substituteInPlace cmake/compilers/GNU.cmake \
        --replace '-Wfatal-errors)' '-Wfatal-errors -Wno-error=stringop-overflow)'
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace test/CMakeLists.txt \
      --replace 'conformance_resumable_tasks' ""
  '';
}
