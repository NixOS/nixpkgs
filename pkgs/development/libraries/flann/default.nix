{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config

, lz4
, unzip
, openmp

, enablePython ? false
, python3
}:

stdenv.mkDerivation rec {
  pname = "flann";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "flann-lib";
    repo = "flann";
    rev = version;
    hash = "sha256-5GCz28CbnPDQhEz6axFiQZMmOasd2Rph4a/bMQ53T2Q=";
  };

  patches = [
    # Add "Requires:" to generated pkg-config file, see https://github.com/flann-lib/flann/pull/481
    ./pkg-config-requires.patch

    # Patch HDF5_INCLUDE_DIR -> HDF5_INCLUDE_DIRS.
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/flann/-/raw/debian/1.9.1+dfsg-9/debian/patches/0001-Updated-fix-cmake-hdf5.patch";
      sha256 = "yM1ONU4mu6lctttM5YcSTg8F344TNUJXwjxXLqzr5Pk=";
    })

    # Fix LZ4 string separator issue, see: https://github.com/flann-lib/flann/pull/480
    ./pkg-config-lz4-expand-list.patch
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES:BOOL=OFF"
    "-DBUILD_TESTS:BOOL=OFF"
    "-DBUILD_MATLAB_BINDINGS:BOOL=OFF"
    "-DBUILD_PYTHON_BINDINGS:BOOL=${if enablePython then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    unzip
  ];

  propagatedBuildInputs = [ lz4 ];

  buildInputs = lib.optional stdenv.cc.isClang openmp ++ lib.optional enablePython python3;

  meta = with lib; {
    homepage = "https://github.com/flann-lib/flann";
    license = licenses.bsd3;
    description = "Fast approximate nearest neighbor searches in high dimensional spaces";
    maintainers = with maintainers; [ viric tmarkus ];
    platforms = with platforms; linux ++ darwin;
  };
}
