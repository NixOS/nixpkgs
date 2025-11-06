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
  fetchFromGitHub,
  flask-cors,
  flask,
  freezegun,
  graphql-core,
  jinja2,
  joserfc,
  jsonpath-ng,
  jsonschema,
  multipart,
  openapi-spec-validator,
  py-partiql-parser,
  pyparsing,
  pytest-order,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  requests,
  responses,
  setuptools,
  werkzeug,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "moto";
  version = "5.1.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getmoto";
    repo = "moto";
    tag = version;
    hash = "sha256-krZrPzH8/pOGvQTcofT2TzyytDXs9FTpqh9JK0QN44E=";
  };

  build-system = [
    setuptools
  ];

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
      joserfc
      jsonpath-ng
      docker
      graphql-core
      pyyaml
      cfn-lint
      jsonschema
      openapi-spec-validator
      pyparsing
      py-partiql-parser
      aws-xray-sdk
      setuptools
      multipart
    ];
    proxy = [
      antlr4-python3-runtime
      joserfc
      jsonpath-ng
      docker
      graphql-core
      pyyaml
      cfn-lint
      openapi-spec-validator
      pyparsing
      py-partiql-parser
      aws-xray-sdk
      setuptools
      multipart
    ];
    server = [
      antlr4-python3-runtime
      joserfc
      jsonpath-ng
      docker
      graphql-core
      pyyaml
      cfn-lint
      openapi-spec-validator
      pyparsing
      py-partiql-parser
      aws-xray-sdk
      setuptools
      flask
      flask-cors
    ];
    acm = [ ];
    acmpca = [ ];
    amp = [ ];
    apigateway = [
      pyyaml
      joserfc
      openapi-spec-validator
    ];
    apigatewayv2 = [
      pyyaml
      openapi-spec-validator
    ];
    applicationautoscaling = [ ];
    appsync = [
      graphql-core
    ];
    athena = [ ];
    autoscaling = [ ];
    awslambda = [
      docker
    ];
    awslambda_simple = [ ];
    backup = [ ];
    batch = [
      docker
    ];
    batch_simple = [ ];
    budgets = [ ];
    ce = [ ];
    cloudformation = [
      joserfc
      docker
      graphql-core
      pyyaml
      cfn-lint
      openapi-spec-validator
      pyparsing
      py-partiql-parser
      aws-xray-sdk
      setuptools
    ];
    cloudfront = [ ];
    cloudtrail = [ ];
    cloudwatch = [ ];
    codebuild = [ ];
    codecommit = [ ];
    codepipeline = [ ];
    cognitoidentity = [ ];
    cognitoidp = [
      joserfc
    ];
    comprehend = [ ];
    config = [ ];
    databrew = [ ];
    datapipeline = [ ];
    datasync = [ ];
    dax = [ ];
    dms = [ ];
    ds = [ ];
    dynamodb = [
      docker
      py-partiql-parser
    ];
    dynamodbstreams = [
      docker
      py-partiql-parser
    ];
    ebs = [ ];
    ec2 = [ ];
    ec2instanceconnect = [ ];
    ecr = [ ];
    ecs = [ ];
    efs = [ ];
    eks = [ ];
    elasticache = [ ];
    elasticbeanstalk = [ ];
    elastictranscoder = [ ];
    elb = [ ];
    elbv2 = [ ];
    emr = [ ];
    emrcontainers = [ ];
    emrserverless = [ ];
    es = [ ];
    events = [
      jsonpath-ng
    ];
    firehose = [ ];
    forecast = [ ];
    glacier = [ ];
    glue = [
      pyparsing
    ];
    greengrass = [ ];
    guardduty = [ ];
    iam = [ ];
    inspector2 = [ ];
    iot = [ ];
    iotdata = [ ];
    ivs = [ ];
    kinesis = [ ];
    kinesisvideo = [ ];
    kinesisvideoarchivedmedia = [ ];
    kms = [ ];
    logs = [ ];
    managedblockchain = [ ];
    mediaconnect = [ ];
    medialive = [ ];
    mediapackage = [ ];
    mediastore = [ ];
    mediastoredata = [ ];
    meteringmarketplace = [ ];
    mq = [ ];
    opsworks = [ ];
    organizations = [ ];
    panorama = [ ];
    personalize = [ ];
    pinpoint = [ ];
    polly = [ ];
    quicksight = [
      jsonschema
    ];
    ram = [ ];
    rds = [ ];
    redshift = [ ];
    redshiftdata = [ ];
    rekognition = [ ];
    resourcegroups = [ ];
    resourcegroupstaggingapi = [
      joserfc
      docker
      graphql-core
      pyyaml
      cfn-lint
      openapi-spec-validator
      pyparsing
      py-partiql-parser
    ];
    route53 = [ ];
    route53resolver = [ ];
    s3 = [
      pyyaml
      py-partiql-parser
    ];
    s3crc32c = [
      pyyaml
      py-partiql-parser
      crc32c
    ];
    s3control = [ ];
    sagemaker = [ ];
    sdb = [ ];
    scheduler = [ ];
    secretsmanager = [ ];
    servicediscovery = [ ];
    servicequotas = [ ];
    ses = [ ];
    signer = [ ];
    sns = [ ];
    sqs = [ ];
    ssm = [
      pyyaml
    ];
    ssoadmin = [ ];
    stepfunctions = [
      antlr4-python3-runtime
      jsonpath-ng
    ];
    sts = [ ];
    support = [ ];
    swf = [ ];
    textract = [ ];
    timestreamwrite = [ ];
    transcribe = [ ];
    wafv2 = [ ];
    xray = [
      aws-xray-sdk
      setuptools
    ];
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    freezegun
    pytest-order
    pytest-xdist
    pytestCheckHook
  ]
  ++ optional-dependencies.server;

  # Some tests depend on AWS credentials environment variables to be set.
  env.AWS_ACCESS_KEY_ID = "ak";
  env.AWS_SECRET_ACCESS_KEY = "sk";

  pytestFlags = [
    # Matches upstream configuration, presumably due to expensive setup/teardown.
    "--dist=loadscope"
  ];

  disabledTestMarks = [
    "network"
    "requires_docker"
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

    # KeyError because of ap-southeast-5-apse5-az
    "test_zoneId_in_availability_zones"

    # Parameter validation fails
    "test_conditional_write"

    # Assumes too much about threading.Timer() behavior (that it honors the
    # timeout precisely and that the thread handler will complete in just 0.1s
    # from the requested timeout)
    "test_start_and_fire_timer_decision"
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

    # botocore.exceptions.ParamValidationError: Parameter validation failed: Unknown parameter in input: "EnableWorkDocs", must be one of: [...]
    "tests/test_workspaces/test_workspaces.py"

    # Requires sagemaker client
    "other_langs/tests_sagemaker_client/test_model_training.py"
  ];

  meta = {
    description = "Allows your tests to easily mock out AWS Services";
    homepage = "https://github.com/getmoto/moto";
    changelog = "https://github.com/getmoto/moto/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
