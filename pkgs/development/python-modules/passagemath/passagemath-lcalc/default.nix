{
  buildPythonPackage,
  callPackage,
  cysignals,
  cython,
  fetchPypi,
  gmp,
  lcalc,
  lib,
  mpfr,
  ntl,
  pari,
  passagemath-categories,
  passagemath-environment,
  passagemath-modules,
  passagemath-objects,
  passagemath-setup,
  pkgconfig,
  setuptools,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
buildPythonPackage rec {
  pname = "passagemath-lcalc";
  version = "10.8.13";

  pyproject = true;

  build-system = [
    setuptools
    cython
    pkgconfig
    passagemath-setup
    passagemath-environment
  ];

  buildInputs = [
    lcalc
    pari
    gmp
    mpfr
    ntl
  ];

  dependencies = [
    cysignals
    memory-allocator
    passagemath-environment
    passagemath-objects
    passagemath-categories
    passagemath-modules
  ];

  src = fetchPypi {
    pname = "passagemath_lcalc";
    inherit version;
    hash = "sha256-yWaHUq/935HOM8WM+fNmXne1TdEFb/7OxR9ZPtnanhc=";
  };

  meta = {
    description = "passagemath: L-function calculations with lcalc";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
