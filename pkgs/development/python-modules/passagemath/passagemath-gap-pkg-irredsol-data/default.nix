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
  pname = "passagemath-gap-pkg-irredsol-data";
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
    pname = "passagemath_gap_pkg_irredsol_data";
    inherit version;
    hash = "sha256-hzjUxL7/WsekcXItBBfB0iRhfb2vvsbaHNuvHhUaf9s=";
  };

  meta = {
    description = "passagemath: Computational Group Theory with GAP: irredsol data";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
