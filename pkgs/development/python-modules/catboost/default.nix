{
  lib,
  buildPythonPackage,
  catboost,
  python,

  # build-system
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

  buildPhase = ''
    runHook preBuild

    # these arguments must set after bdist_wheel
    ${python.pythonOnBuildForHost.interpreter} setup.py bdist_wheel --no-widget --prebuilt-extensions-build-root-dir=${lib.getDev catboost}

    runHook postBuild
  '';

  # setup a test is difficult
  doCheck = false;

  pythonImportsCheck = [ "catboost" ];

  meta = catboost.meta // {
    # https://github.com/catboost/catboost/issues/2671
    broken = lib.versionAtLeast numpy.version "2";
  };
}
