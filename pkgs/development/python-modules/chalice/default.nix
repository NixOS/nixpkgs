{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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

buildPythonPackage (finalAttrs: {
  pname = "chalice";
  version = "1.33.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "chalice";
    tag = finalAttrs.version;
    hash = "sha256-c5xzgrxRFRlvgMnf/L8rhG7rYJLtuMvDZHYsPaHkdRs=";
  };

  pythonRelaxDeps = [ "pip" ];

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
    "test_build_wheel"
    # Tests require dist
    "test_setup_tar_gz_hyphens_in_name"
    "test_both_tar_gz"
    "test_both_tar_bz2"
    # AssertionError
    "test_no_error_message_printed_on_empty_reqs_file"
    # botocore.exceptions.ParamValidationError:
    "test_can_create_kinesis_event_source"
    "test_can_create_kinesis_event_source_batching_window"
    "test_can_create_sqs_event_source"
    "test_can_retry_create_sqs_event_source"
    "test_can_delete_sqs_event_source"
    "test_can_retry_delete_event_source"
    "test_only_retry_settling_errors "
    "test_can_retry_update_event_source"
    "test_can_retry_update_event_source_batching_window "
    "test_verify_event_source_current[queue-name-sqs-True]"
    "test_verify_event_source_current[queue-name-not-sqs-False]"
    "test_verify_event_source_current[not-queue-name-sqs-False]"
    "test_verify_event_source_current[not-queue-name-not-sqs-False]"
    "test_verify_event_source_arn_current"
    "test_event_source_uuid_does_not_exist"
    "test_event_source_does_not_exist"
    "test_can_update_lambda_event_source"
  ];

  pythonImportsCheck = [ "chalice" ];

  meta = {
    description = "Python Serverless Microframework for AWS";
    homepage = "https://github.com/aws/chalice";
    changelog = "https://github.com/aws/chalice/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "chalice";
  };
})
