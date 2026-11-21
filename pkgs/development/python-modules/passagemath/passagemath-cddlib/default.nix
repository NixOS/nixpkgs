{
  buildPythonPackage,
  cddlib,
  cysignals,
  cython,
  fetchPypi,
  gmp,
  lib,
  passagemath-environment,
  passagemath-setup,
  pkgconfig,
  setuptools,
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
  buildInputs = [
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

  meta = {
    description = "passagemath: Polyhedral computation with cddlib";
    longDescription = ''
      `passagemath-cddlib` provides an interface to [cddlib](https://github.com/cddlib/cddlib), the library for polyhedral representation conversion using the double description method.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
