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

  # grpc tests are racy
  preCheck = ''
    sed -i '/"grpc",/d' optuna/testing/storages.py
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
  versionCheckProgramArg = "--version";

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

    # Fatal Python error: Aborted
    # matplotlib/backend_bases.py", line 2654 in create_with_canvas
    "test_edf_plot_no_trials"
    "test_get_timeline_plot"
    "test_plot_contour"
    "test_plot_contour_customized_target_name"
    "test_plot_edf_with_multiple_studies"
    "test_plot_edf_with_target"
    "test_plot_parallel_coordinate"
    "test_plot_parallel_coordinate_customized_target_name"
    "test_plot_param_importances"
    "test_plot_param_importances_customized_target_name"
    "test_plot_param_importances_multiobjective_all_objectives_displayed"
    "test_plot_slice"
    "test_plot_slice_customized_target_name"
    "test_target_is_none_and_study_is_multi_obj"
    "test_visualizations_with_single_objectives"
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
