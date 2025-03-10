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
  version = "0.6.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GIhSObfsz8Zywcj4YcrBeb7l7c0m2PQJZJRyrb0IMbU=";
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

  doCheck = false;

  meta = {
    description = "Backtest trading strategies in Python";
    homepage = "https://kernc.github.io/backtesting.py/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ appleboblin ];
  };
}
