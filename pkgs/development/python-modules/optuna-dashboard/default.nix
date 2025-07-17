{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  alembic,
  boto3,
  botorch,
  bottle,
  cmaes,
  colorlog,
  moto,
  numpy,
  optuna,
  packaging,
  plotly,
  pytestCheckHook,
  setuptools,
  scikit-learn,
  scipy,
  streamlit,
  tqdm,
}:

buildPythonPackage rec {
  pname = "optuna-dashboard";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "optuna";
    repo = "optuna-dashboard";
    tag = "v${version}";
    hash = "sha256-0L1QTw9srZsHWDVP4J0WMIvndn5pn51Hs/Xz/tusv0I=";
  };

  dependencies = [
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

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    boto3
    botorch
    moto
    plotly
    streamlit
  ];

  # Disable tests that use playwright (needs network)
  disabledTestPaths = [
    "e2e_tests/test_dashboard/test_usecases/test_preferential_optimization.py"
    "e2e_tests/test_dashboard/test_usecases/test_study_history.py"
    "e2e_tests/test_dashboard/visual_regression_test.py"
    "e2e_tests/test_standalone/test_study_list.py"
  ];

  pythonImportsCheck = [ "optuna_dashboard" ];

  meta = {
    description = "Real-time Web Dashboard for Optuna";
    homepage = "https://github.com/optuna/optuna-dashboard";
    changelog = "https://github.com/optuna/optuna-dashboard/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "optuna-dashboard";
  };
}
