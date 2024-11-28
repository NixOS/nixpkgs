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
  pythonOlder,
  setuptools-scm,
  setuptools,
  sqlalchemy,
  typeguard,
  yappi,
}:

buildPythonPackage rec {
  pname = "ax-platform";
  version = "0.4.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "ax";
    rev = "refs/tags/${version}";
    hash = "sha256-jmBjrtxqg4Iu3Qr0HRqjVfwURXzbJaGm+DBFNHYk/vA=";
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
    yappi
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTestPaths = [
    "ax/benchmark"
    "ax/runners/tests/test_torchx.py"
    # requires pyre_extensions
    "ax/telemetry/tests"
    "ax/core/tests/test_utils.py"
    "ax/early_stopping/tests/test_strategies.py"
    # broken with sqlalchemy 2
    "ax/core/tests/test_experiment.py"
    "ax/service/tests/test_ax_client.py"
    "ax/service/tests/test_scheduler.py"
    "ax/service/tests/test_with_db_settings_base.py"
    "ax/storage"
  ];

  disabledTests = [
    # exact comparison of floating points
    "test_optimize_l0_homotopy"
    # AssertionError: 5 != 2
    "test_get_standard_plots_moo"
    # AssertionError: Expected 'warning' to be called once. Called 3 times
    "test_validate_kwarg_typing"
    # uses torch.equal
    "test_convert_observations"
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
