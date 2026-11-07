{
  boehmgc,
  buildPythonPackage,
  cysignals,
  cython,
  fetchPypi,
  lib,
  libhomfly,
  passagemath-environment,
  passagemath-objects,
  passagemath-setup,
  pkgconfig,
  setuptools,
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

  buildInputs = [
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

  meta = {
    description = "passagemath: Homfly polynomials of knots/links with libhomfly";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
