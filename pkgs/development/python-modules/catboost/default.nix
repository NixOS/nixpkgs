{ lib
, buildPythonPackage
, catboost
, python
, graphviz
, matplotlib
, numpy
, pandas
, plotly
, scipy
, setuptools
, six
, wheel
}:

buildPythonPackage {
  inherit (catboost) pname version src meta;
  format = "pyproject";

  sourceRoot = "source/catboost/python-package";

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
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
}
