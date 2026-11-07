{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  cysignals,
  memory-allocator,
  passagemath-linbox,
  passagemath-modules,
  passagemath-ntl,
  ...
}:
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
  buildInputs = with pkgs; [
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
}
