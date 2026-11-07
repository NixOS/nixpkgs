{
  fetchPypi,
  buildPythonPackage,
  libz,
  gmpy2,
  cysignals,
  numpy,
  sympy,
  passagemath-categories,
  passagemath-environment,
  passagemath-ntl,
  passagemath-gsl,
  passagemath-flint,
  passagemath-modules,
  pkgs,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-symbolics";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    cython
    pkgconfig
    passagemath-setup
    passagemath-environment
  ];
  buildInputs = with pkgs; [
    gsl
    flint
    ntl
    gmp
    mpfr
    singular
  ];
  dependencies = [
    gmpy2
    cysignals
    numpy
    sympy

    passagemath-categories
    passagemath-environment
    passagemath-ntl
    passagemath-gsl
    passagemath-flint
    passagemath-modules
  ];

  src = fetchPypi {
    pname = "passagemath_symbolics";
    inherit version;
    hash = "sha256-pXlNwYClyz5M6IPpKFUPaaMIU3eSWRmb//LmDoCRNdY=";
  };
}
