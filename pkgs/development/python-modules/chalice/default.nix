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
, watchdog
, websocket-client
, wheel
}:

buildPythonPackage rec {
  pname = "chalice";
  version = "1.27.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-izzoYxzkaQqcEM5e8BhZeZIxtAGRDNH/qvqwvrx250s=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "attrs>=19.3.0,<21.5.0" "attrs" \
      --replace "inquirer>=2.7.0,<3.0.0" "inquirer" \
      --replace "pip>=9,<22.3" "pip" \
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
