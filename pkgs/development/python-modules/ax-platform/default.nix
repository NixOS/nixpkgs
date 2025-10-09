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

buildPythonPackage rec {
  pname = "ax-platform";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "ax";
    tag = version;
    hash = "sha256-DHB/BcD913gano5N7dlAbB+Tfg1dMTRP3AR1HwJjkLg=";
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
    "ax/service/tests/test_orchestrator.py"
    "ax/service/tests/test_with_db_settings_base.py"

    # Hangs forever
    "ax/analysis/plotly/tests/test_top_surfaces.py::TestTopSurfacesAnalysis::test_online"
  ];

  disabledTests = [
    # sqlalchemy.exc.ArgumentError: Strings are not accepted for attribute names in loader options; please use class-bound attributes directly.
    "SQAStoreUtilsTest"
    "SQAStoreTest"

    # ValueError: `db_settings` argument should be of type ax.storage.sqa_store
    "test_get_next_trials_with_db"

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
    changelog = "https://github.com/facebook/Ax/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
