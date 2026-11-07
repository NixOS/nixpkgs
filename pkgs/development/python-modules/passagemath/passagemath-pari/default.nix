{
  buildPythonPackage,
  conway-polynomials,
  cysignals,
  cython,
  fetchPypi,
  flint,
  gd,
  givaro,
  gmp,
  gsl,
  libmpc,
  memory-allocator,
  mpfr,
  mpmath,
  ntl,
  pari,
  passagemath-categories,
  passagemath-environment,
  passagemath-flint,
  passagemath-modules,
  passagemath-setup,
  pkgconfig,
  readline,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-pari";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
    passagemath-modules
    passagemath-flint
    mpmath
    cython
    pkgconfig
  ];

  nativeBuildInputs = [
    pari
  ];

  buildInputs = [
    flint
    gd
    givaro
    gmp
    gsl
    libmpc
    mpfr
    ntl
    pari
    readline
  ];

  dependencies = [
    cysignals
    memory-allocator
    passagemath-environment
    passagemath-categories
    conway-polynomials
  ];

  src = fetchPypi {
    pname = "passagemath_pari";
    inherit version;
    hash = "sha256-kXS5ClhkZW4qJADSRMmDteBhbPMKon8Tu1rZkyr6+uM=";
  };
}
