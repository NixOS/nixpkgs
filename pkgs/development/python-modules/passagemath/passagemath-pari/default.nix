{
  lib,
  buildPythonPackage,
  callPackage,
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
  mpfr,
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
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
  mpmath = callPackage ../downgrades/mpmath { };
in
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

  meta = {
    description = "passagemath: Computational Number Theory with PARI/GP";
    longDescription = ''
      `passagemath-pari` provides Sage library modules that depend on
      PARI/GP, the computer algebra system for fast computations in number
      theory, including factorizations, algebraic number theory, elliptic
      curves, modular forms, and L-functions.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
