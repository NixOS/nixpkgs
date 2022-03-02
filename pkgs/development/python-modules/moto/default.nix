{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# runtime
, aws-xray-sdk
, boto3
, botocore
, cfn-lint
, cryptography
, docker
, flask
, flask-cors
, graphql-core
, idna
, jinja2
, jsondiff
, python-dateutil
, python-jose
, pytz
, pyyaml
, requests
, responses
, sshpubkeys
, werkzeug
, xmltodict

# tests
, freezegun
, pytestCheckHook
, pytest-xdist
, sure
}:

buildPythonPackage rec {
  pname = "moto";
  version = "3.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hfLs4K0DBaoTo5E5zmSKs6/hwEyzKsHbjV5ekRfU0Q4=";
  };

  propagatedBuildInputs = [
    aws-xray-sdk
    boto3
    botocore
    cfn-lint
    cryptography
    docker
    flask
    flask-cors
    graphql-core
    idna
    jinja2
    jsondiff
    python-dateutil
    python-jose
    pytz
    pyyaml
    requests
    responses
    sshpubkeys
    werkzeug
    xmltodict
  ];

  checkInputs = [
    freezegun
    pytest-xdist
    pytestCheckHook
    sure
  ];

  pytestFlagsArray = [
    "--numprocesses $NIX_BUILD_CORES"

    # Disable tests that try to access the network
    "--deselect=tests/test_cloudformation/test_cloudformation_custom_resources.py::test_create_custom_lambda_resource__verify_cfnresponse_failed"
    "--deselect=tests/test_cloudformation/test_server.py::test_cloudformation_server_get"
    "--deselect=tests/test_core/test_decorator_calls.py::test_context_manager"
    "--deselect=tests/test_core/test_decorator_calls.py::test_decorator_start_and_stop"
    "--deselect=tests/test_core/test_request_mocking.py::test_passthrough_requests"
    "--deselect=tests/test_firehose/test_firehose_put.py::test_put_record_batch_http_destination"
    "--deselect=tests/test_firehose/test_firehose_put.py::test_put_record_http_destination"
    "--deselect=tests/test_logs/test_integration.py::test_put_subscription_filter_with_lambda"
    "--deselect=tests/test_sqs/test_integration.py::test_invoke_function_from_sqs_exception"
    "--deselect=tests/test_sqs/test_sqs_integration.py::test_invoke_function_from_sqs_exception"
    "--deselect=tests/test_stepfunctions/test_stepfunctions.py::test_state_machine_creation_fails_with_invalid_names"
    "--deselect=tests/test_stepfunctions/test_stepfunctions.py::test_state_machine_list_executions_with_pagination"

    # json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)
    "--deselect=tests/test_cloudformation/test_cloudformation_stack_integration.py::test_lambda_function"
  ];

  disabledTestPaths = [
    # xml.parsers.expat.ExpatError: out of memory: line 1, column 0
    "tests/test_sts/test_sts.py"
    # botocore.exceptions.NoCredentialsError: Unable to locate credentials
    "tests/test_redshiftdata/test_redshiftdata.py"
    # Tries to access the network
    "tests/test_appsync/test_appsync_schema.py"
    "tests/test_awslambda/test_lambda_eventsourcemapping.py"
    "tests/test_awslambda/test_lambda_invoke.py"
    "tests/test_batch/test_batch_jobs.py"
  ];

  disabledTests = [
    # only appears in aarch64 currently, but best to be safe
    "test_state_machine_list_executions_with_filter"
  ];

  meta = with lib; {
    description = "Allows your tests to easily mock out AWS Services";
    homepage = "https://github.com/spulec/moto";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
