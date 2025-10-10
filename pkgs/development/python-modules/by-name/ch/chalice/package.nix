{
  lib,
  attrs,
  botocore,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hypothesis,
  inquirer,
  jmespath,
  mypy-extensions,
  pip,
  pytestCheckHook,
  pyyaml,
  requests,
  setuptools,
  six,
  typing-extensions,
  watchdog,
  websocket-client,
  wheel,
}:

buildPythonPackage rec {
  pname = "chalice";
  version = "1.32.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "chalice";
    tag = version;
    hash = "sha256-7qmE78aFfq9XCl2zcx1dAVKZZb96Bu47tSW1Qp2vFl4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    botocore
    click
    inquirer
    jmespath
    pip
    pyyaml
    setuptools
    six
    wheel
  ];

  nativeCheckInputs = [
    hypothesis
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
    # Tests require dist
    "test_setup_tar_gz_hyphens_in_name"
    "test_both_tar_gz"
    "test_both_tar_bz2"
  ];

  pythonImportsCheck = [ "chalice" ];

  meta = with lib; {
    description = "Python Serverless Microframework for AWS";
    mainProgram = "chalice";
    homepage = "https://github.com/aws/chalice";
    changelog = "https://github.com/aws/chalice/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
