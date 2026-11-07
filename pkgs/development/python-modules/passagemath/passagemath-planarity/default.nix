{
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
}
