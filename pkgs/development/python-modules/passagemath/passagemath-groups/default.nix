{
  buildPythonPackage,
  cython,
  fetchPypi,
  flint,
  gap,
  gmp,
  lib,
  passagemath-categories,
  passagemath-environment,
  passagemath-flint,
  passagemath-gap,
  passagemath-modules,
  passagemath-setup,
  pkgconfig,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-groups";
  version = "10.8.13";

  pyproject = true;

  build-system = [
    setuptools
    passagemath-setup
    cython
    pkgconfig
    passagemath-environment
    passagemath-flint
  ];

  buildInputs = [
    flint
    gap
    gmp
  ];

  dependencies = [
    passagemath-categories
    passagemath-gap
    passagemath-modules
  ];

  src = fetchPypi {
    pname = "passagemath_groups";
    inherit version;
    hash = "sha256-69dE3LSzdRyHbTZ9uM7cRP6RMErT+D7/62xCOcjlXys=";
  };

  meta = {
    description = "passagemath: Groups and Invariant Theory";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
