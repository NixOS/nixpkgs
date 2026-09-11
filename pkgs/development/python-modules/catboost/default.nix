{
  lib,
  buildPythonPackage,
  catboost,
  python,

  # build-system
  cmake,
  cython,
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
    ;
  pyproject = true;

  sourceRoot = "${src.name}/catboost/python-package";

  build-system = [
    cmake
    cython
    setuptools
  ];

  dependencies = [
    graphviz
    matplotlib
    numpy
    pandas
    plotly
    scipy
    six
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "cmake (>=3.24, <4.0)" "cmake" \
      --replace-fail "'conan (>=2.4.1, <3.0)', " "" \
      --replace-fail "cython ~= 3.0.10" "cython"
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    # these arguments must set after bdist_wheel
    ${python.pythonOnBuildForHost.interpreter} setup.py bdist_wheel --no-widget --prebuilt-extensions-build-root-dir=${lib.getDev catboost}

    runHook postBuild
  '';

  # setup a test is difficult
  doCheck = false;

  pythonImportsCheck = [ "catboost" ];

  meta = catboost.meta;
}
