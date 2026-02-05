{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  botocore,
  click,
  inquirer,
  jmespath,
  pip,
  pyyaml,
  six,

  # tests
  hypothesis,
  pytestCheckHook,
  requests,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "chalice";
  version = "1.32.0";
  pyproject = true;

  disabled = pythonAtLeast "3.14";

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
    # setuptools
    six
  ];

  pythonRelaxDeps = [ "pip" ];

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
    # AssertionError
    "test_no_error_message_printed_on_empty_reqs_file"
  ];

  pythonImportsCheck = [ "chalice" ];

  meta = {
    description = "Python Serverless Microframework for AWS";
    mainProgram = "chalice";
    homepage = "https://github.com/aws/chalice";
    changelog = "https://github.com/aws/chalice/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
