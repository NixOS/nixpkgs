{
  buildPythonPackage,
  cysignals,
  cython,
  dot2tex,
  fetchPypi,
  gap,
  gmpy2,
  memory-allocator,
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
  pkgs,
  setuptools,
  ...
}:

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
  buildInputs = with pkgs; [
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
}
