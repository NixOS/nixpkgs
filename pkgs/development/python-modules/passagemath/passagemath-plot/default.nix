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
  gmpy2,
  memory-allocator,
  numpy,
  scipy,
  pillow,
  matplotlib,
  jupyter-threejs-sage,
  passagemath-categories,
  passagemath-modules,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-plot";
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
    libz
    gsl
  ];
  dependencies = [
    cysignals
    gmpy2
    memory-allocator
    numpy
    scipy
    pillow
    matplotlib
    jupyter-threejs-sage
    passagemath-categories
    passagemath-modules
  ];

  src = fetchPypi {
    pname = "passagemath_plot";
    inherit version;
    hash = "sha256-MM2Xu2cLB7RMsdFeqyMac5oQ/S3cjXPbW51Y/v33QvY=";
  };
}
