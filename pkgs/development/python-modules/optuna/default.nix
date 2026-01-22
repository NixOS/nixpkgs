{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  alembic,
  colorlog,
  numpy,
  packaging,
  sqlalchemy,
  tqdm,
  pyyaml,

  # optional-dependencies
  boto3,
  cmaes,
  fvcore,
  google-cloud-storage,
  grpcio,
  matplotlib,
  pandas,
  plotly,
  protobuf,
  redis,
  scikit-learn,
  scipy,

  # tests
  addBinToPathHook,
  fakeredis,
  kaleido,
  moto,
  pytest-xdist,
  pytestCheckHook,
  torch,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "optuna";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "optuna";
    repo = "optuna";
    tag = "v${version}";
    hash = "sha256-qaCOpqKRepm/a1Nh98PV6RcRkadLK5E429pn1zaWQDA=";
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

  preCheck =
    # grpc tests are racy
    ''
      sed -i '/"grpc",/d' optuna/testing/storages.py
    ''
    # Prevents 'Fatal Python error: Aborted' on darwin during checkPhase
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      export MPLBACKEND="Agg"
    '';

  nativeCheckInputs = [
    addBinToPathHook
    fakeredis
    kaleido
    moto
    pytest-xdist
    pytestCheckHook
    torch
    versionCheckHook
  ]
  ++ fakeredis.optional-dependencies.lua
  ++ optional-dependencies.optional;

  disabledTests = [
    # ValueError: Transform failed with error code 525: error creating static canvas/context for image server
    "test_get_pareto_front_plot"
    # too narrow time limit
    "test_get_timeline_plot_with_killed_running_trials"
    # times out under load
    "test_optimize_with_progbar_timeout"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # ValueError: Failed to start Kaleido subprocess. Error stream
    # kaleido/executable/kaleido: line 5:  5956 Illegal instruction: 4  ./bin/kaleido $@
    "test_get_optimization_history_plot"
    "test_plot_intermediate_values"
    "test_plot_rank"
    "test_plot_terminator_improvement"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 13] Permission denied: '/tmp/optuna_find_free_port.lock'
    "tests/storages_tests/journal_tests/test_combination_with_grpc.py"
    "tests/storages_tests/test_grpc.py"
    "tests/storages_tests/test_storages.py"
    "tests/study_tests/test_dataframe.py"
    "tests/study_tests/test_optimize.py"
    "tests/study_tests/test_study.py"
    "tests/trial_tests/test_frozen.py"
    "tests/trial_tests/test_trial.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "optuna" ];

  meta = {
    description = "Hyperparameter optimization framework";
    homepage = "https://optuna.org/";
    changelog = "https://github.com/optuna/optuna/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "optuna";
  };
}
