{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  passagemath-objects,
  passagemath-categories,
  cysignals,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-cliquer";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    pkgconfig
    passagemath-setup
    passagemath-categories
    passagemath-environment
    passagemath-objects
    cython
  ];
  buildInputs = with pkgs; [
    cliquer
  ];

  dependencies = [ cysignals ];

  src = fetchPypi {
    pname = "passagemath_cliquer";
    inherit version;
    hash = "sha256-VO/KTJVxsqA4XQqABKeYW4hV99lbYxSxfS55KgeZccw=";
  };
}
