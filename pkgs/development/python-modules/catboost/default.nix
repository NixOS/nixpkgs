{
  lib,
  buildPythonPackage,
  catboost,
  python,

  # build-system
  cmake,
  conan,
  cython,
  jupyterlab,
  setuptools,

  # dependencies
  graphviz,
  matplotlib,
  numpy,
  pandas,
  plotly,
  scipy,
  six,
}:

buildPythonPackage rec {
  inherit (catboost)
    pname
    version
    src
    meta
    ;
  pyproject = true;

  sourceRoot = "${src.name}/catboost/python-package";

  postPatch = ''
    substituteInPlace pyproject.toml setup.py \
      --replace-fail "conan ~= 2.4.1" conan \
      --replace-fail "cython ~= 3.0.10" cython \
      --replace-fail "jupyterlab (>=3.0.6, <3.6.0)" jupyterlab
  '';

  build-system = [
    cmake
    conan
    cython
    jupyterlab
    numpy
    setuptools
  ];

  dontUseCmakeConfigure = true;

  dependencies = [
    graphviz
    matplotlib
    numpy
    pandas
    plotly
    scipy
    six
  ];

  pypaBuildFlags = [
    "-C--no-widget"
    "-C--prebuilt-extensions-build-root-dir=${lib.getDev catboost}"
  ];

  # setup a test is difficult
  doCheck = false;

  pythonImportsCheck = [ "catboost" ];
}
