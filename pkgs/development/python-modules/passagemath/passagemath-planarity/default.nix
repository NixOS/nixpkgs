{
  lib,
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  passagemath-graphs,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-planarity";
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
    planarity
  ];
  dependencies = [
    passagemath-graphs
  ];

  src = fetchPypi {
    pname = "passagemath_planarity";
    inherit version;
    hash = "sha256-ijDK98QNLF5GYoE10NjX/URhxcG/98ShjrIt3W+KtII=";
  };

  meta = {
    description = "passagemath: Graph planarity with the edge addition planarity suite";
    longDescription = ''
      `passagemath-planarity` provides a Cython interface to John Boyer's
      Edge Addition Planarity Suite for use with `passagemath-graphs`.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
