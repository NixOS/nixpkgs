{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools

# dependencies
, boto3
, botocore
, cryptography
, jinja2
, python-dateutil
, requests
, responses
, werkzeug
, xmltodict

# optional-dependencies
, aws-xray-sdk
, cfn-lint
, docker
, ecdsa
, flask
, flask-cors
, graphql-core
, jsondiff
, multipart
, openapi-spec-validator
, py-partiql-parser
, pyparsing
, python-jose
, pyyaml
, sshpubkeys

# tests
, freezegun
, pytestCheckHook
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "moto";
  version = "4.2.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zgpV1+dWxZpaQ5LHCXqlylPgCqLdP3AACTNWvhXnrvk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    boto3
    botocore
    cryptography
    requests
    xmltodict
    werkzeug
    python-dateutil
    responses
    jinja2
  ];

  passthru.optional-dependencies = {
    # non-exhaustive list of extras, that was cobbled together for testing
    all = [
      aws-xray-sdk
      cfn-lint
      docker
      ecdsa
      flask
      flask-cors
      graphql-core
      jsondiff
      multipart
      openapi-spec-validator
      py-partiql-parser
      pyparsing
      python-jose
      pyyaml
      setuptools
      sshpubkeys
    ] ++ python-jose.optional-dependencies.cryptography;
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
    pytest-xdist
  ] ++ passthru.optional-dependencies.all;

  pytestFlagsArray = [
    "-m" "'not network and not requires_docker'"

    # Fails at local name resolution
    "--deselect=tests/test_s3/test_multiple_accounts_server.py::TestAccountIdResolution::test_with_custom_request_header"
    "--deselect=tests/test_s3/test_server.py::test_s3_server_post_cors_multiple_origins"

    # Fails at resolving google.com
    "--deselect=tests/test_firehose/test_firehose_put.py::test_put_record_http_destination"
    "--deselect=tests/test_firehose/test_firehose_put.py::test_put_record_batch_http_destination"

    # Download recordings returns faulty JSON
    "--deselect=tests/test_moto_api/recorder/test_recorder.py::TestRecorder::test_ec2_instance_creation_recording_on"
    "--deselect=tests/test_moto_api/recorder/test_recorder.py::TestRecorder::test_ec2_instance_creation__recording_off"

    # Connection Reset by Peer, when connecting to localhost:5678
    "--deselect=tests/test_moto_api/recorder/test_recorder.py::TestRecorder::test_replay"

    # Requires docker, but isn't marked
    # https://github.com/getmoto/moto/pull/6938
    "--deselect=tests/test_awslambda/test_lambda_layers_invoked.py::test_invoke_local_lambda_layers"

    # Racy, expects two timestamp two differ
    # https://github.com/getmoto/moto/issues/6946
    "--deselect=tests/test_databrew/test_databrew_recipes.py::test_publish_recipe"
  ];

  disabledTestPaths = [
    # Requires pytest-ordering, which is unmaintained
    # https://github.com/getmoto/moto/issues/6937
    # botocore.exceptions.NoCredentialsError: Unable to locate credentials
    "tests/test_dynamodb/test_dynamodb_statements.py"
    "tests/test_lakeformation/test_resource_tags_integration.py"
    "tests/test_redshiftdata/test_redshiftdata.py"
    "tests/test_s3/test_s3_file_handles.py"
    "tests/test_s3/test_s3.py"
    "tests/test_s3/test_s3_select.py"

    # Tries to access the network
    "tests/test_batch/test_batch_jobs.py"

    # Threading tests regularly blocks test execution
    "tests/test_utilities/test_threaded_server.py"
    "tests/test_s3/test_s3_bucket_policy.py"
  ];

  meta = with lib; {
    description = "Allows your tests to easily mock out AWS Services";
    homepage = "https://github.com/spulec/moto";
    changelog = "https://github.com/getmoto/moto/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
