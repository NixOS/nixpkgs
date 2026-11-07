{
  buildPythonPackage,
  fetchPypi,
  lib,
  passagemath-environment,
  passagemath-setup,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-gap-pkg-ctbllib-data";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
  ];

  dependencies = [
    passagemath-environment
  ];

  src = fetchPypi {
    pname = "passagemath_gap_pkg_ctbllib_data";
    inherit version;
    hash = "sha256-cX03/dmpwhsu7kDQQKi4ONOabtwIZz3TePhR+5tYngs=";
  };

  meta = {
    description = "passagemath: Computational Group Theory with GAP: ctbllib data";
    homepage = "https://passagemath.org";
    sourceProvenance = "https://github.com/passagemath/passagemath";
    license = lib.licenses.gpl2Plus;
  };
}
