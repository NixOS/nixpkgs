{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  ];

  # Disable failing test on musl
  # test/conformance/conformance_resumable_tasks.cpp:37:24: error: ‘suspend’ is not a member of ‘tbb::v1::task’; did you mean ‘tbb::detail::r1::suspend’?
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    sed -i "/conformance_resumable_tasks/d" test/CMakeLists.txt
  '';

}
