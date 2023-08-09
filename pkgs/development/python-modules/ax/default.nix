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
}:

buildPythonPackage rec {
  pname = "ax";
  version = "0.3.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = version;
    hash = "sha256-1KLLjeUktXvIDOlTQzMmpbL/On8PTxZQ44Qi4BT3nPk=";
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
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
  pythonImportsCheck = [ "ax" ];

  meta = with lib; {
    description = "Ax is an accessible, general-purpose platform for understanding, managing, deploying, and automating adaptive experiments";
    homepage = "https://ax.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
