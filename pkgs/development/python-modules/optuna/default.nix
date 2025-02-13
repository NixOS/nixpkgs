{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  alembic,
  boto3,
  cmaes,
  colorlog,
  fakeredis,
  fvcore,
  google-cloud-storage,
  grpcio,
  kaleido,
  matplotlib,
  moto,
  numpy,
  packaging,
  pandas,
  plotly,
  protobuf,
  pytest-xdist,
  pyyaml,
  redis,
  scikit-learn,
  scipy,
  setuptools,
  sqlalchemy,
  torch,
  tqdm,
}:

buildPythonPackage rec {
  pname = "optuna";
  version = "4.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "optuna";
    repo = "optuna";
    tag = "v${version}";
    hash = "sha256-NNlwrVrGg2WvkC42nmW7K/mRktE3B97GaL8GaSOKF1Y=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    alembic
    colorlog
    numpy
    packaging
    sqlalchemy
    tqdm
    pyyaml
  ];

  optional-dependencies = {
    optional = [
      boto3
      cmaes
      fvcore
      google-cloud-storage
      grpcio
      matplotlib
      pandas
      plotly
      protobuf
      redis
      scikit-learn
      scipy
    ];
  };

  preCheck = ''
    export PATH=$out/bin:$PATH

    # grpc tests are racy
    sed -i '/"grpc",/d' optuna/testing/storages.py
  '';

  nativeCheckInputs =
    [
      fakeredis
      kaleido
      moto
      pytest-xdist
      pytestCheckHook
      torch
    ]
    ++ fakeredis.optional-dependencies.lua
    ++ optional-dependencies.optional;

  disabledTests = [
    # ValueError: Transform failed with error code 525: error creating static canvas/context for image server
    "test_get_pareto_front_plot"
    # too narrow time limit
    "test_get_timeline_plot_with_killed_running_trials"
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
