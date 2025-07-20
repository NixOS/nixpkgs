{
  lib,
  stdenv,
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
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "optuna";
    repo = "optuna-dashboard";
    tag = "v${version}";
    hash = "sha256-UTl3X0laEHyc9YjL2RPBeCle0WRKjOU7Bt58BMRXIlU=";
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

  # Temporarily disable tests as they hang due to a torch bug on darwin
  # Will revert in https://github.com/NixOS/nixpkgs/pull/424873
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Real-time Web Dashboard for Optuna";
    homepage = "https://github.com/optuna/optuna-dashboard";
    changelog = "https://github.com/optuna/optuna-dashboard/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "optuna-dashboard";
  };
}
