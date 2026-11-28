{
  buildPythonPackage,
  callPackage,
  cysignals,
  cython,
  fetchPypi,
  gmp,
  gsl,
  jinja2,
  lib,
  mpfr,
  numpy,
  passagemath-categories,
  passagemath-environment,
  passagemath-modules,
  passagemath-setup,
  pkgconfig,
  setuptools,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
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
  buildInputs = [
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

  meta = {
    description = "passagemath: Numerics with the GNU Scientific Library";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
