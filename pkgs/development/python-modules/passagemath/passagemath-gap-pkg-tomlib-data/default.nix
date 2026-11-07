{
  pkgs,
  python,
  buildPythonPackage,
  fetchPypi,
  passagemath-setup,
  setuptools,
  passagemath-environment,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-gap-pkg-tomlib-data";
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
    pname = "passagemath_gap_pkg_tomlib_data";
    inherit version;
    hash = "sha256-c927q/6dCkK44DAp9v1xS5Sj0MD5fkYhtau51o/qNE0=";
  };
}
