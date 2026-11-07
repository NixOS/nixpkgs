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
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-cddlib";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    cython
    pkgconfig
    passagemath-setup
  ];
  buildInputs = with pkgs; [
    cddlib
    gmp
  ];
  dependencies = [
    passagemath-environment
    cysignals
  ];

  src = fetchPypi {
    pname = "passagemath_cddlib";
    inherit version;
    hash = "sha256-X49ApHhjEYayupnCTppzwXO2RGDWOrYUzH9+Vz5gfGU=";
  };
}
