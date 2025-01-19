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
  hypothesis,
  kazoo,
  msgpack,
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
  version = "5.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7vVy3S/Z/GFLN1gOPK6v3Vr0bB7/Mef7qJE4zbQG8s8=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    amqp
    tzdata
    vine
  ] ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];

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
    # pyro4 doesn't suppport Python 3.11
    #pyro = [
    #  pyro4
    #];
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
