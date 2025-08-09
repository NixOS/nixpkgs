{
  lib,
  amqp,
  azure-identity,
  azure-servicebus,
  azure-storage-queue,
  boto3,
  buildPythonPackage,
  confluent-kafka,
  fetchPypi,
  google-cloud-pubsub,
  google-cloud-monitoring,
  hypothesis,
  kazoo,
  msgpack,
  packaging,
  pycurl,
  pymongo,
  #, pyro4
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  redis,
  setuptools,
  sqlalchemy,
  typing-extensions,
  tzdata,
  urllib3,
  vine,
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "5.5.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iGYAFoJ16+rak7iI6DE1L+V4FoNC8NHVgz2Iug2Ec2M=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    amqp
    packaging
    tzdata
    vine
  ]
  ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  optional-dependencies = {
    msgpack = [ msgpack ];
    yaml = [ pyyaml ];
    redis = [ redis ];
    mongodb = [ pymongo ];
    sqs = [
      boto3
      urllib3
      pycurl
    ];
    zookeeper = [ kazoo ];
    sqlalchemy = [ sqlalchemy ];
    azurestoragequeues = [
      azure-identity
      azure-storage-queue
    ];
    azureservicebus = [ azure-servicebus ];
    confluentkafka = [ confluent-kafka ];
    gcpubsub = [
      google-cloud-pubsub
      google-cloud-monitoring
    ];
    # pyro4 doesn't support Python 3.11
    #pyro = [
    #  pyro4
    #];
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "kombu" ];

  disabledTests = [
    # Disable pyro4 test
    "test_driver_version"
    # AssertionError: assert [call('WATCH'..., 'test-tag')] ==...
    "test_global_keyprefix_transaction"
  ];

  meta = with lib; {
    description = "Messaging library for Python";
    homepage = "https://github.com/celery/kombu";
    changelog = "https://github.com/celery/kombu/blob/v${version}/Changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
