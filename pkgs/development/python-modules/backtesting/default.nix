{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  setuptools-git,
  numpy,
  pandas,
  bokeh,
}:

buildPythonPackage rec {
  pname = "backtesting";
  version = "0.6.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Xasb7VG39XXQ/A47lgkYk5Vo4pJPE3Vghcxt0yGeq4=";
  };

  build-system = [
    setuptools
    setuptools-scm
    setuptools-git
  ];

  dependencies = [
    numpy
    pandas
    bokeh
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Backtest trading strategies in Python";
    homepage = "https://kernc.github.io/backtesting.py/";
    changelog = "https://github.com/kernc/backtesting.py/blob/${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ appleboblin ];
  };
}
