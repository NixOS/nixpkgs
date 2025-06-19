{
  alembic,
  bottle,
  buildPythonPackage,
  cmaes,
  colorlog,
  fetchPypi,
  lib,
  numpy,
  optuna,
  packaging,
  setuptools,
  scikit-learn,
  scipy,
  tqdm,
}:

buildPythonPackage rec {
  pname = "optuna-dashboard";
  version = "0.18.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "optuna_dashboard";
    inherit version;
    hash = "sha256-vnc5Qnnv4vtF7mPl/lYiAH7w8G1HEX6bnDbmdxZ3ff0=";
  };

  nativeCheckInputs = [
    scikit-learn
  ];

  buildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    alembic
    bottle
    cmaes
    colorlog
    numpy
    optuna
    packaging
    scikit-learn
    scipy
    tqdm
  ];

  pythonImportsCheck = [ "optuna_dashboard" ];

  meta = {
    description = "Real-time Web Dashboard for Optuna.";
    homepage = "https://pypi.org/project/optuna-dashboard/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "optuna-dashboard";
  };
}
