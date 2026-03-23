{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  botorch,
  graphviz,
  ipywidgets,
  jinja2,
  markdown,
  pandas,
  plotly,
  pyre-extensions,
  scikit-learn,
  scipy,
  sympy,

  # tests
  pyfakefs,
  pytestCheckHook,
  sqlalchemy,
  tabulate,
}:

buildPythonPackage (finalAttrs: {
  pname = "ax-platform";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "ax";
    tag = finalAttrs.version;
    hash = "sha256-zIK3D7QSkfzAxySumdxsA3tiPWYbP9E6SS21837H4ZY=";
  };

  env.ALLOW_BOTORCH_LATEST = "1";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    botorch
    graphviz
    ipywidgets
    jinja2
    markdown
    pandas
    plotly
    pyre-extensions
    scikit-learn
    scipy
    sympy
  ]
  ++ botorch.optional-dependencies.pymoo;

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
    sqlalchemy
    tabulate
  ];

  disabledTestPaths = [
    "ax/benchmark"
    "ax/runners/tests/test_torchx.py"

    # broken with sqlalchemy 2
    "ax/core/tests/test_experiment.py"
    "ax/service/tests/test_ax_client.py"

    # Hangs forever
    "ax/analysis/plotly/tests/test_top_surfaces.py::TestTopSurfacesAnalysis::test_online"

    # ValueError: `db_settings` argument should be of type ax.storage.sqa_store
    "ax/storage/sqa_store/tests/test_with_db_settings_base.py"
  ];

  disabledTests = [
    # sqlalchemy.exc.ArgumentError: Strings are not accepted for attribute names in loader options; please use class-bound attributes directly.
    "SQAStoreTest"
    "SQAStoreUtilsTest"
    "test_load_experiment_with_aux_exp_and_custom_metric_in_gen_metadata"
    "test_resave_experiment_with_aux_exp_loses_custom_metrics_and_runner"

    # ValueError: Expected dim to be an integer greater than or equal to 2. Found dim=1.
    "test_get_model"

    # ValueError: `db_settings` argument should be of type ax.storage.sqa_store
    "test_from_stored_experiment"
    "test_generate_candidates_can_remove_stale_candidates"
    "test_generate_candidates_can_remove_stale_candidates_with_ttl"
    "test_generate_candidates_does_not_fail_stale_candidates_if_fails_to_gen"
    "test_generate_candidates_updates_experiment_status"
    "test_generate_candidates_works_for_sobol"
    "test_get_next_trials_with_db"
    "test_orchestrator_with_metric_with_new_data_after_completion"
    "test_sqa_storage_map_metric_experiment"
    "test_sqa_storage_with_experiment_name"
    "test_sqa_storage_without_experiment_name"
    "test_suppress_all_storage_errors"
    "test_suppress_all_storage_errors"

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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky on x86
    "test_gen_with_expanded_parameter_space"
  ];

  pythonImportsCheck = [ "ax" ];

  meta = {
    description = "Platform for understanding, managing, deploying, and automating adaptive experiments";
    homepage = "https://ax.dev/";
    changelog = "https://github.com/facebook/Ax/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
