{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, swig
, boost
, spectra
, libxml2
, tbb
, hmat-oss
, nlopt
, cminpack
, ceres-solver
, dlib
, hdf5
, primesieve
, pagmo2
, ipopt
, Accelerate
# tests take an hour to build on a 48-core machine
, runTests ? false
, enablePython ? false
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "openturns";
  version = "1.20";

  src = fetchFromGitHub {
    owner = "openturns";
    repo = "openturns";
    rev = "v${version}";
    sha256 = "sha256-QeapH937yGnK6oD+rgIERePxz6ooxGpOx6x9LyFDt2A=";
  };

  patches = [
    # Fix build with primesieve 11, https://github.com/openturns/openturns/pull/2187
    # Remove with next version update.
    (fetchpatch {
      url = "https://github.com/openturns/openturns/commit/a85061f89a5763061467beac516c1355fe81b9be.patch";
      hash = "sha256-z28ipBuX3b5UFEnKuDfp+kMI5cUcwXVz/8WZHlICnvE=";
    })
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optional enablePython python3Packages.sphinx;
  buildInputs = [
    swig
    boost
    spectra
    libxml2
    tbb
    hmat-oss
    nlopt
    cminpack
    ceres-solver
    dlib
    hdf5
    primesieve
    pagmo2
    ipopt
  ] ++ lib.optionals enablePython [
    python3Packages.python
    python3Packages.matplotlib
    python3Packages.psutil
    python3Packages.dill
  ] ++ lib.optional stdenv.isDarwin Accelerate;

  cmakeFlags = [
    "-DOPENTURNS_SYSCONFIG_PATH=$out/etc"
    "-DCMAKE_UNITY_BUILD=ON"
    "-DCMAKE_UNITY_BUILD_BATCH_SIZE=32"
    "-DSWIG_COMPILE_FLAGS='-O1'"
    "-DUSE_SPHINX=${if enablePython then "ON" else "OFF"}"
    "-DBUILD_PYTHON=${if enablePython then "ON" else "OFF"}"
  ];

  doCheck = runTests;

  checkTarget = "tests check";

  meta = with lib; {
    description = "Multivariate probabilistic modeling and uncertainty treatment library";
    license = with licenses; [ lgpl3 gpl3 ];
    homepage = "https://openturns.github.io/www/";
    maintainers = with maintainers; [ gdinh ];
    platforms = platforms.unix;
  };
}
