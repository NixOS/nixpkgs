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
  passagemath-objects,
  passagemath-categories,
  passagemath-modules,
  ...
}:
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
  buildInputs = with pkgs; [
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
}
