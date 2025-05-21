{
  lib,
  botorch,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  ipywidgets,
  jinja2,
  jupyter,
  mercurial,
  pandas,
  plotly,
  pyfakefs,
  pyre-extensions,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools-scm,
  setuptools,
  sqlalchemy,
  stdenvNoCC,
  tabulate,
  typeguard,
  yappi,
}:

buildPythonPackage rec {
  pname = "ax-platform";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "ax";
    tag = version;
    hash = "sha256-CMKdnPvzQ9tvU9/01mRaWi/Beuyo19CtaXNJCoiwLOw=";
  };

  env.ALLOW_BOTORCH_LATEST = "1";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    botorch
    ipywidgets
    jinja2
    pandas
    plotly
    typeguard
    pyre-extensions
  ];

  optional-dependencies = {
    mysql = [ sqlalchemy ];
    notebook = [ jupyter ];
  };

  nativeCheckInputs = [
    hypothesis
    mercurial
    pyfakefs
    pytestCheckHook
    tabulate
    yappi
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTestPaths = [
    "ax/benchmark"
    "ax/runners/tests/test_torchx.py"
    # broken with sqlalchemy 2
    "ax/core/tests/test_experiment.py"
    "ax/service/tests/test_ax_client.py"
    "ax/service/tests/test_scheduler.py"
    "ax/service/tests/test_with_db_settings_base.py"
    "ax/storage"
  ];

  disabledTests =
    [
      # exact comparison of floating points
      "test_optimize_l0_homotopy"
      # AssertionError: 5 != 2
      "test_get_standard_plots_moo"
      # AssertionError: Expected 'warning' to be called once. Called 3 times
      "test_validate_kwarg_typing"
      # uses torch.equal
      "test_convert_observations"
      # broken with sqlalchemy 2
      "test_sql_storage"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      #  Both `metric_aggregation` and `criterion` must be `ReductionCriterion`
      "test_SingleDiagnosticBestModelSelector_max_mean"
      "test_SingleDiagnosticBestModelSelector_min_mean"
      "test_SingleDiagnosticBestModelSelector_min_min"
      "test_SingleDiagnosticBestModelSelector_model_cv_kwargs"
      "test_init"
      "test_gen"
      # "use MIN or MAX" does not match "Both `metric_aggregation` and `criterion` must be `ReductionCriterion`
      "test_user_input_error"
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
      # flaky on x86
      "test_gen_with_expanded_parameter_space"
    ];

  pythonImportsCheck = [ "ax" ];

  meta = {
    description = "Platform for understanding, managing, deploying, and automating adaptive experiments";
    homepage = "https://ax.dev/";
    changelog = "https://github.com/facebook/Ax/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
