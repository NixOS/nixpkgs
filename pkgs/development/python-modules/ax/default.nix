{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ax,
  botorch,
  ipywidgets,
  jinja2,
  pandas,
  plotly,
  python,
  setuptools,
  setuptools-scm,
  typeguard,
  wheel,
  hypothesis,
  mercurial,
  pyfakefs,
  pytestCheckHook,
  yappi,
  pyre-extensions,
}:

buildPythonPackage rec {
  pname = "ax";
  version = "0.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-dj6Gig8N4oLtcZLwPl4QDHG/FwA2nFBtYxSARnWiJJU=";
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
    # uses torch.equal
    "test_convert_observations"
  ];
  pythonImportsCheck = [ "ax" ];

  # Many portions of the test suite fail under Python 3.12
  doCheck = lib.versions.majorMinor python.version != "3.12";

  passthru.tests.check = ax.overridePythonAttrs { doCheck = true; };

  meta = with lib; {
    description = "Ax is an accessible, general-purpose platform for understanding, managing, deploying, and automating adaptive experiments";
    homepage = "https://ax.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
