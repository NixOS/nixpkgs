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
  passagemath-objects,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-homfly";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
    passagemath-environment
    passagemath-objects
    cython
    pkgconfig
  ];
  buildInputs = with pkgs; [
    libhomfly
    boehmgc
  ];
  dependencies = [
    cysignals
  ];

  src = fetchPypi {
    pname = "passagemath_homfly";
    inherit version;
    hash = "sha256-fvrkxYRmVbDbCNBnaxy+yMw+bQ50sPZuWq4GdNN4Gks=";
  };
}
