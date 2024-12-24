{
  lib,
  antlr4-python3-runtime,
  aws-xray-sdk,
  boto3,
  botocore,
  buildPythonPackage,
  cfn-lint,
  crc32c,
  cryptography,
  docker,
  fetchPypi,
  flask-cors,
  flask,
  freezegun,
  graphql-core,
  jinja2,
  joserfc,
  jsondiff,
  jsonpath-ng,
  multipart,
  openapi-spec-validator,
  py-partiql-parser,
  pyparsing,
  pytest-order,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pyyaml,
  requests,
  responses,
  setuptools,
  werkzeug,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "moto";
  version = "5.0.20";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JLExnMZvgfQIF6V6yAYCpfGGJmm91iHw2Wq5iaZXglU=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  optional-dependencies = {
    all = [
      antlr4-python3-runtime
      aws-xray-sdk
      cfn-lint
      docker
      flask
      flask-cors
      graphql-core
      joserfc
      jsondiff
      jsonpath-ng
      multipart
      openapi-spec-validator
      py-partiql-parser
      pyparsing
      pyyaml
      setuptools
    ];
    proxy = [
      antlr4-python3-runtime
      aws-xray-sdk
      cfn-lint
      docker
      graphql-core
      joserfc
      jsondiff
      jsonpath-ng
      multipart
      openapi-spec-validator
      py-partiql-parser
      pyparsing
      pyyaml
      setuptools
    ];
    server = [
      antlr4-python3-runtime
      aws-xray-sdk
      cfn-lint
      docker
      flask
      flask-cors
      graphql-core
      joserfc
      jsondiff
      jsonpath-ng
      openapi-spec-validator
      py-partiql-parser
      pyparsing
      pyyaml
      setuptools
    ];
    cognitoidp = [ joserfc ];
    apigateway = [
      pyyaml
      joserfc
      openapi-spec-validator
    ];
    apigatewayv2 = [
      pyyaml
      openapi-spec-validator
    ];
    cloudformation = [
      aws-xray-sdk
      cfn-lint
      docker
      graphql-core
      joserfc
      jsondiff
      openapi-spec-validator
      py-partiql-parser
      pyparsing
      pyyaml
      setuptools
    ];
    dynamodb = [
      docker
      py-partiql-parser
    ];
    dynamodbstreams = [
      docker
      py-partiql-parser
    ];
    events = [ jsonpath-ng ];
    glue = [ pyparsing ];
    iotdata = [ jsondiff ];
    resourcegroupstaggingapi = [
      cfn-lint
      docker
      graphql-core
      joserfc
      jsondiff
      openapi-spec-validator
      py-partiql-parser
      pyparsing
      pyyaml
    ];
    s3 = [
      pyyaml
      py-partiql-parser
    ];
    sns = [ ];
    stepfunctions = [
      antlr4-python3-runtime
      jsonpath-ng
    ];
    s3crc32c = [
      pyyaml
      py-partiql-parser
      crc32c
    ];
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    freezegun
    pytest-order
    pytest-xdist
    pytestCheckHook
  ] ++ optional-dependencies.all;

  # Some tests depend on AWS credentials environment variables to be set.
  env.AWS_ACCESS_KEY_ID = "ak";
  env.AWS_SECRET_ACCESS_KEY = "sk";

  pytestFlagsArray = [
    "-m"
    "'not network and not requires_docker'"

    # Matches upstream configuration, presumably due to expensive setup/teardown.
    "--dist"
    "loadscope"
  ];

  disabledTests = [
    # Fails at local name resolution
    "test_with_custom_request_header"
    "test_s3_server_post_cors_multiple_origins"
    "test_create_multipart"
    "test_aws_and_http_requests"
    "test_http_requests"

    # Fails at resolving google.com
    "test_put_record_http_destination"
    "test_put_record_batch_http_destination"

    # Fails at resolving s3.amazonaws.com
    "test_passthrough_calls_for_wildcard_urls"
    "test_passthrough_calls_for_specific_url"
    "test_passthrough_calls_for_entire_service"

    # Download recordings returns faulty JSON
    "test_ec2_instance_creation_recording_on"
    "test_ec2_instance_creation__recording_off"

    # Connection Reset by Peer, when connecting to localhost:5678
    "test_replay"

    # Flaky under parallel execution
    "test_cloudformation_server_get"
    "test_should_find_bucket"

    # AssertionError: assert ResourceWarning not in [<class 'ResourceWarning'>, <class 'ResourceWarning'>]
    "test_delete_object_with_version"

    # KeyError beucase of ap-southeast-5-apse5-az
    "test_zoneId_in_availability_zones"

    # Parameter validation fails
    "test_conditional_write"
  ];

  disabledTestPaths = [
    # Flaky under parallel execution, Connection Reset errors to localhost.
    "tests/test_moto_api/recorder/test_recorder.py"

    # Flaky under parallel execution
    "tests/test_resourcegroupstaggingapi/*.py"

    # Tries to access the network
    "tests/test_batch/test_batch_jobs.py"

    # Threading tests regularly blocks test execution
    "tests/test_utilities/test_threaded_server.py"
    "tests/test_s3/test_s3_bucket_policy.py"

    # https://github.com/getmoto/moto/issues/7786
    "tests/test_dynamodb/test_dynamodb_import_table.py"

    # Infinite recursion with pycognito
    "tests/test_cognitoidp/test_cognitoidp.py"
  ];

  meta = {
    description = "Allows your tests to easily mock out AWS Services";
    homepage = "https://github.com/getmoto/moto";
    changelog = "https://github.com/getmoto/moto/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
