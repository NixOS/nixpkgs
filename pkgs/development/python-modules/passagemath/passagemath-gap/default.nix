{
  buildPythonPackage,
  callPackage,
  cysignals,
  cython,
  dot2tex,
  fetchPypi,
  gap,
  gmp,
  gmpy2,
  lib,
  libmpc,
  mpfr,
  passagemath-categories,
  passagemath-environment,
  passagemath-gap-pkg-factint-data,
  passagemath-gap-pkg-primgrp-data,
  passagemath-gap-pkg-smallgrp-data,
  passagemath-modules,
  passagemath-repl,
  passagemath-setup,
  pexpect,
  pkgconfig,
  setuptools,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
buildPythonPackage rec {
  pname = "passagemath-gap";
  version = "10.8.13";

  pyproject = true;

  build-system = [
    setuptools
    passagemath-setup
    passagemath-modules
    cython
    gmpy2
    pkgconfig
  ];

  buildInputs = [
    gmp
    mpfr
    gap
    libmpc
  ];

  dependencies = [
    cysignals
    dot2tex
    memory-allocator
    pexpect
    passagemath-environment
    passagemath-categories
    passagemath-gap-pkg-factint-data
    passagemath-gap-pkg-primgrp-data
    passagemath-gap-pkg-smallgrp-data
    passagemath-repl
  ];

  src = fetchPypi {
    pname = "passagemath_gap";
    inherit version;
    hash = "sha256-V65670IxOhm/If+vV+95GqUPpNxQOzkBoE2plVlC7bo=";
  };

  meta = {
    description = "passagemath: Computational Group Theory with GAP";
    longDescription = ''
      `passagemath-gap` provides Cython and Pexpect interfaces to the GAP
      system, together with Sage library modules for computational group theory
      that depend on GAP.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
