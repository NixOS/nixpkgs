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
  version = "1.21.2";

  src = fetchFromGitHub {
    owner = "openturns";
    repo = "openturns";
    rev = "v${version}";
    sha256 = "sha256-Zq+Z3jLjdba3566H4RdwztqbRRID5K5yHvoGmgzq8QM=";
  };

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
    changelog = "https://github.com/openturns/openturns/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [ gdinh ];
    platforms = platforms.unix;
  };
}
