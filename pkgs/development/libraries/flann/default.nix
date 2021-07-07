{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, unzip
, cmake
, python ? null
, lz4
, pkg-config
, enablePython ? false
}:

assert enablePython -> python != null;

stdenv.mkDerivation {
  name = "flann-1.9.1";

  src = fetchFromGitHub {
    owner = "flann-lib";
    repo = "flann";
    rev = "1.9.1";
    sha256 = "13lg9nazj5s9a41j61vbijy04v6839i67lqd925xmxsbybf36gjc";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/flann/-/raw/debian/1.9.1+dfsg-9/debian/patches/0001-Updated-fix-cmake-hdf5.patch";
      sha256 = "yM1ONU4mu6lctttM5YcSTg8F344TNUJXwjxXLqzr5Pk=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/flann/-/raw/debian/1.9.1+dfsg-9/debian/patches/0001-src-cpp-fix-cmake-3.11-build.patch";
      sha256 = "REsBnbe6vlrZ+iCcw43kR5wy2o6q10RM73xjW5kBsr4=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/flann/-/raw/debian/1.9.1+dfsg-9/debian/patches/0003-Use-system-version-of-liblz4.patch";
      sha256 = "xi+GyFn9PEjLgbJeAIEmsbp7ut9G9KIBkVulyT3nfsg=";
    })
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES:BOOL=OFF"
    "-DBUILD_TESTS:BOOL=OFF"
    "-DBUILD_MATLAB_BINDINGS:BOOL=OFF"
    "-DBUILD_PYTHON_BINDINGS:BOOL=${if enablePython then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [
    unzip
    cmake
    pkg-config
  ];

  buildInputs = [] ++ lib.optionals enablePython [ python ];

  propagatedBuildInputs = [ lz4 ];

  meta = {
    homepage = "http://people.cs.ubc.ca/~mariusm/flann/";
    license = lib.licenses.bsd3;
    description = "Fast approximate nearest neighbor searches in high dimensional spaces";
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
