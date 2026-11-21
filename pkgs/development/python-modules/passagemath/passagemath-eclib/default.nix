{
  buildPythonPackage,
  callPackage,
  cysignals,
  cython,
  eclib,
  fetchPypi,
  flint,
  gmp,
  lib,
  linbox,
  mpfr,
  ntl,
  pari,
  passagemath-environment,
  passagemath-linbox,
  passagemath-modules,
  passagemath-ntl,
  passagemath-setup,
  pkgconfig,
  setuptools,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
buildPythonPackage rec {
  pname = "passagemath-eclib";
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
    pari
    eclib
    gmp
    mpfr
    ntl
    flint
    linbox
  ];

  dependencies = [
    cysignals
    memory-allocator
    passagemath-linbox
    passagemath-modules
    passagemath-ntl
  ];

  src = fetchPypi {
    pname = "passagemath_eclib";
    inherit version;
    hash = "sha256-rG3QEgPH92hHiB0TKJ7bG+qg9dJyxn9qfWAl799Am60=";
  };

  meta = {
    description = "passagemath: Elliptic curves over the rationals with eclib/mwrank";
    longDescription = ''
      `passagemath-eclib` provides the Cython interface to John Cremona's programs for enumerating and computing with elliptic curves defined over the rational numbers.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
