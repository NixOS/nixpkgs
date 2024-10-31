{
  lib,
  stdenv,
  blinker,
  pytestCheckHook,
  buildPythonPackage,
  fetchPypi,
  flask,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "flask-testing";
  version = "0.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

  # Some of the tests use localhost networking on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

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

  meta = with lib; {
    description = "Extension provides unit testing utilities for Flask";
    homepage = "https://pythonhosted.org/Flask-Testing/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 ];
  };
}
