{ lib
, attrs
, botocore
, buildPythonPackage
, click
, fetchFromGitHub
, hypothesis
, inquirer
, jmespath
, mock
, mypy-extensions
, pip
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, setuptools
, six
, typing
, watchdog
, websocket-client
, wheel
}:

buildPythonPackage rec {
  pname = "chalice";
  version = "1.27.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = version;
    sha256 = "sha256-Qz8kYXu2NmcgtW8GbmLPfB4BOearEycE6EMmQRXmWeI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "attrs>=19.3.0,<21.5.0" "attrs" \
      --replace "pip>=9,<22.2" "pip" \
      --replace "typing==3.6.4" "typing"
  '';

  propagatedBuildInputs = [
    attrs
    botocore
    click
    inquirer
    jmespath
    mypy-extensions
    pip
    pyyaml
    setuptools
    six
    wheel
    watchdog
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing
  ];

  checkInputs = [
    hypothesis
    mock
    pytestCheckHook
    requests
    websocket-client
  ];

  disabledTestPaths = [
    # Don't check the templates and the sample app
    "chalice/templates"
    "docs/source/samples/todo-app/code/tests/test_db.py"
    # Requires credentials
    "tests/aws/test_features.py"
    # Requires network access
    "tests/aws/test_websockets.py"
    "tests/integration/test_package.py"
  ];

  disabledTests = [
    # Requires network access
    "test_update_domain_name_failed"
    "test_can_reload_server"
    # Content for the tests is missing
    "test_can_import_env_vars"
    "test_stack_trace_printed_on_error"
    # Don't build
    "test_can_generate_pipeline_for_all"
    "test_build_wheel"
    # https://github.com/aws/chalice/issues/1850
    "test_resolve_endpoint"
    "test_endpoint_from_arn"
  ];

  pythonImportsCheck = [ "chalice" ];

  meta = with lib; {
    description = "Python Serverless Microframework for AWS";
    homepage = "https://github.com/aws/chalice";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
