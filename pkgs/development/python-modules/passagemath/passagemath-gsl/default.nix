{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  jinja2,
  cysignals,
  memory-allocator,
  numpy,
  passagemath-categories,
  passagemath-modules,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-gsl";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    cython
    pkgconfig
    passagemath-setup
    passagemath-environment
    jinja2
  ];
  buildInputs = with pkgs; [
    gsl
    gmp
    mpfr
  ];
  dependencies = [
    cysignals
    memory-allocator
    numpy
    passagemath-categories
    passagemath-environment
    passagemath-modules
  ];

  src = fetchPypi {
    pname = "passagemath_gsl";
    inherit version;
    hash = "sha256-zA19Y3wJUGdU6gOWX3w1iXYG9WyWZq8LjvkCuuKGBEs=";
  };
}
