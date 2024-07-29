{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  botorch,
  ipywidgets,
  jinja2,
  pandas,
  plotly,
  setuptools,
  setuptools-scm,
  typeguard,
  hypothesis,
  mercurial,
  pyfakefs,
  pytestCheckHook,
  yappi,
  pyre-extensions,
}:

buildPythonPackage rec {
  pname = "ax-platform";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "ax";
    rev = "refs/tags/${version}";
    hash = "sha256-ygMMMKY5XsoQGp9yUMFAQqkSUlXNBJCb8xgGE10db4U=";
  };

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

  env.ALLOW_BOTORCH_LATEST = "1";

  nativeCheckInputs = [
    hypothesis
    mercurial
    pyfakefs
    pytestCheckHook
    yappi
  ];
  pytestFlagsArray = [
    "--ignore=ax/benchmark"
    "--ignore=ax/runners/tests/test_torchx.py"
    # requires pyre_extensions
    "--ignore=ax/telemetry/tests"
    "--ignore=ax/core/tests/test_utils.py"
    "--ignore=ax/early_stopping/tests/test_strategies.py"
    # broken with sqlalchemy 2
    "--ignore=ax/service/tests/test_ax_client.py"
    "--ignore=ax/service/tests/test_scheduler.py"
    "--ignore=ax/service/tests/test_with_db_settings_base.py"
    "--ignore=ax/storage"
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

  meta = with lib; {
    changelog = "https://github.com/facebook/Ax/releases/tag/${version}";
    description = "Ax is an accessible, general-purpose platform for understanding, managing, deploying, and automating adaptive experiments";
    homepage = "https://ax.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
