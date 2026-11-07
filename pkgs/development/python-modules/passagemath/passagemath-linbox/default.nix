{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  cysignals,
  memory-allocator,
  passagemath-categories,
  passagemath-iml,
  passagemath-m4ri-m4rie,
  passagemath-flint,
  numpy,
  passagemath-modules,
  fflas-ffpack,
  openblas,
  gsl,
  flint,
  mpfr,
  libmpc,
  linbox,
  gmp,
  givaro,
  python,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-linbox";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
    passagemath-flint
    passagemath-modules
    cython
    numpy
    pkgconfig
  ];
  buildInputs = [
    givaro
    gmp
    linbox
    libmpc
    mpfr
    fflas-ffpack
    flint
    gsl
    openblas
  ];
  dependencies = [
    cysignals
    memory-allocator
    passagemath-environment
    passagemath-categories
    passagemath-iml
    passagemath-m4ri-m4rie
  ];

  preBuild = ''
    export CYTHON_INCLUDE_PATH="${passagemath-flint}/${python.sitePackages}"
  '';

  src = fetchPypi {
    pname = "passagemath_linbox";
    inherit version;
    hash = "sha256-Ri1r+dkUePtbLwWHqT5qLRA1MqIujAwS+ISNErU2dMo=";
  };
}
