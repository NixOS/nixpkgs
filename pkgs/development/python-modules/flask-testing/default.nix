{
  lib,
  stdenv,
  blinker,
  pytestCheckHook,
  buildPythonPackage,
  fetchPypi,
  flask,
}:

buildPythonPackage rec {
  pname = "flask-testing";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "Flask-Testing";
    inherit version;
    hash = "sha256-CnNNe2jmOpQQtBPNex+WRW+ahYvQmmIi1GVlDMeC6wE=";
  };

  propagatedBuildInputs = [ flask ];

  nativeCheckInputs = [
    blinker
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # RuntimeError and NotImplementedError
    "test_assert_redirects"
    "test_server_listening"
    "test_server_process_is_spawned"
    # change in repr(template) in recent flask
    "test_assert_template_rendered_signal_sent"
  ];

  disabledTestPaths = [
    # twill is only used by Python 2 according setup.py
    "tests/test_twill.py"
  ];

  pythonImportsCheck = [ "flask_testing" ];

  meta = {
    description = "Extension provides unit testing utilities for Flask";
    homepage = "https://pythonhosted.org/Flask-Testing/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
