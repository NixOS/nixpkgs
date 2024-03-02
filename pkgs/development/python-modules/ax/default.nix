{ lib
, buildPythonPackage
, fetchFromGitHub
, botorch
, ipywidgets
, jinja2
, pandas
, plotly
, setuptools
, setuptools-scm
, typeguard
, wheel
, hypothesis
, mercurial
, pyfakefs
, pytestCheckHook
, yappi
, pyre-extensions
}:

buildPythonPackage rec {
  pname = "ax";
  version = "0.3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = version;
    hash = "sha256-5f2VpOFDRz6YzxvxFYWMu8hljkMVbBsyULYVreUxYRU=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    botorch
    ipywidgets
    jinja2
    pandas
    plotly
    typeguard
    pyre-extensions
  ];

  checkInputs = [
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
  ];
  pythonImportsCheck = [ "ax" ];

  meta = with lib; {
    description = "Ax is an accessible, general-purpose platform for understanding, managing, deploying, and automating adaptive experiments";
    homepage = "https://ax.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
