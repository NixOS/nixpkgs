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
, sqlalchemy_1_4
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
  version = "0.3.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = version;
    hash = "sha256-Yc6alEKXbtQ0hitIdPhkJWhZQg150b0NJJRLZ+f1hdY=";
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
    sqlalchemy_1_4 # not compatible with 2.x https://github.com/facebook/Ax/issues/1697
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
    "--ignore=ax/service/tests/test_scheduler.py"
    # bogus typing failures
    "--ignore=ax/service/tests/test_report_utils.py"
    "--ignore=ax/utils/common/tests/test_kwargutils.py"
  ];
  disabledTests = [
    # exact comparison of floating points
    "test_optimize_l0_homotopy"
  ];
  pythonImportsCheck = [ "ax" ];

  meta = with lib; {
    description = "Ax is an accessible, general-purpose platform for understanding, managing, deploying, and automating adaptive experiments";
    homepage = "https://ax.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
