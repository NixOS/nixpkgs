{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  numpy,
  passagemath-ntl,
  passagemath-categories,
  passagemath-modules,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-flint";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    cython
    pkgconfig
    passagemath-setup
    passagemath-environment
    passagemath-modules
  ];
  buildInputs = with pkgs; [
    flint
    gmp
    libz
    mpfr
    gsl
    ntl
    mpfi
  ];
  dependencies = [
    numpy
    passagemath-ntl
    passagemath-categories
  ];

  src = fetchPypi {
    pname = "passagemath_flint";
    inherit version;
    hash = "sha256-T0cjq9zrgvKQ/SC5vXMXhwj1t3IeY6e8ZT3Lzw6kEGc=";
  };
}
