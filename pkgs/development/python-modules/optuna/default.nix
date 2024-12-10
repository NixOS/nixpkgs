{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  alembic,
  boto3,
  botorch,
  catboost,
  cma,
  cmaes,
  colorlog,
  distributed,
  fakeredis,
  google-cloud-storage,
  lightgbm,
  matplotlib,
  mlflow,
  moto,
  numpy,
  packaging,
  pandas,
  plotly,
  pytest-xdist,
  pytorch-lightning,
  pyyaml,
  redis,
  scikit-learn,
  scipy,
  setuptools,
  shap,
  sqlalchemy,
  tensorflow,
  torch,
  torchaudio,
  torchvision,
  tqdm,
  wandb,
  wheel,
  xgboost,
}:

buildPythonPackage rec {
  pname = "optuna";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "optuna";
    repo = "optuna";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZCK6otX90s8SB91TLkKwJ4net2dGmAKdIESeHXy87K0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    alembic
    colorlog
    numpy
    packaging
    sqlalchemy
    tqdm
    pyyaml
  ];

  optional-dependencies = {
    integration = [
      botorch
      catboost
      cma
      distributed
      lightgbm
      mlflow
      pandas
      # pytorch-ignite
      pytorch-lightning
      scikit-learn
      shap
      tensorflow
      torch
      torchaudio
      torchvision
      wandb
      xgboost
    ];
    optional = [
      boto3
      botorch
      cmaes
      google-cloud-storage
      matplotlib
      pandas
      plotly
      redis
      scikit-learn
    ];
  };

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs =
    [
      fakeredis
      moto
      pytest-xdist
      pytestCheckHook
      scipy
    ]
    ++ fakeredis.optional-dependencies.lua
    ++ optional-dependencies.optional;

  pytestFlagsArray = [ "-m 'not integration'" ];

  disabledTestPaths = [
    # require unpackaged kaleido and building it is a bit difficult
    "tests/visualization_tests"
    # ImportError: cannot import name 'mock_s3' from 'moto'
    "tests/artifacts_tests/test_boto3.py"
  ];

  pythonImportsCheck = [ "optuna" ];

  meta = with lib; {
    description = "Hyperparameter optimization framework";
    homepage = "https://optuna.org/";
    changelog = "https://github.com/optuna/optuna/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "optuna";
  };
}
