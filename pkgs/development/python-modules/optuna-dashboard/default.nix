{
  lib,
  alembic,
  boto3,
  botorch,
  bottle,
  buildPythonPackage,
  cmaes,
  colorlog,
  httpx,
  moto,
  numpy,
  openai,
  optuna,
  packaging,
  plotly,
  pytestCheckHook,
  respx,
  scikit-learn,
  scipy,
  setuptools,
  streamlit,
  tqdm,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "optuna-dashboard";
  version = "0.20.0";
  pyproject = true;

  # bundle.js cannot be built with nix in 0.20.0. This should be fixed in the next release.
  src = fetchPypi {
    pname = "optuna_dashboard";
    inherit version;
    sha256 = "52a6da480a2500b6993c8fa61c81063b0dbe730edbd9f651c81b318393cca71d";
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
    httpx
    moto
    openai
    plotly
    respx
    streamlit
  ];

  pythonImportsCheck = [ "optuna_dashboard" ];

  # the source distribution ships without tests
  doCheck = false;

  meta = {
    description = "Real-time Web Dashboard for Optuna";
    homepage = "https://github.com/optuna/optuna-dashboard";
    changelog = "https://github.com/optuna/optuna-dashboard/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "optuna-dashboard";
  };
}
