{
  buildPythonPackage,
  cysignals,
  cython,
  fetchPypi,
  lib,
  passagemath-environment,
  passagemath-setup,
  pkgconfig,
  pkgs,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-libbraiding";
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
    libbraiding
  ];
  dependencies = [
    cysignals
  ];

  src = fetchPypi {
    pname = "passagemath_libbraiding";
    inherit version;
    hash = "sha256-3av3c7KSk6K9CuvFJb4fJYXNSSFl4CFPKNDpKq7hlXA=";
  };

  meta = {
    description = "passagemath: Braid computations with libbraiding";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
