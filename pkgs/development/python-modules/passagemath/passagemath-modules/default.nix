{
  buildPythonPackage,
  pkg-config,
  gmp,
  libmpc,
  mpfr,
  gsl,
  fetchPypi,
  setuptools,
  cython,
  passagemath-setup,
  passagemath-environment,
  cysignals,
  memory-allocator,
  numpy,
  mpmath,
  passagemath-categories,
  gmpy2,
  jinja2,
  pkgconfig,
  passagemath-flint,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-modules";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
    jinja2
    pkgconfig
    cython
    numpy
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gmp
    libmpc
    mpfr
    gsl
  ];

  dependencies = [
    gmpy2
    cysignals
    memory-allocator
    passagemath-categories
    passagemath-environment
    mpmath
  ];

  src = fetchPypi {
    pname = "passagemath_modules";
    inherit version;
    hash = "sha256-EIsWJ3Ej1ubsYmjtAzIMrW3XPtyrJgfI2Day0X1dmQg=";
  };
}
