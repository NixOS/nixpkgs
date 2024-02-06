{ lib
, amqp
, azure-identity
, azure-servicebus
, azure-storage-queue
, backports-zoneinfo
, boto3
, buildPythonPackage
, case
, confluent-kafka
, fetchPypi
, hypothesis
, kazoo
, msgpack
, pycurl
, pymongo
  #, pyro4
, pytestCheckHook
, pythonOlder
, pyyaml
, redis
, sqlalchemy
, typing-extensions
, urllib3
, vine
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "5.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MORw8aa0nHDcb20Tw+TMTheKpsRpzra81VZFOF/IS5M=";
  };

  propagatedBuildInputs = [
    amqp
    vine
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  passthru.optional-dependencies = {
    msgpack = [
      msgpack
    ];
    yaml = [
      pyyaml
    ];
    redis = [
      redis
    ];
    mongodb = [
      pymongo
    ];
    sqs = [
      boto3
      urllib3
      pycurl
    ];
    zookeeper = [
      kazoo
    ];
    sqlalchemy = [
      sqlalchemy
    ];
    azurestoragequeues = [
      azure-identity
      azure-storage-queue
    ];
    azureservicebus = [
      azure-servicebus
    ];
    confluentkafka = [
      confluent-kafka
    ];
    # pyro4 doesn't suppport Python 3.11
    #pyro = [
    #  pyro4
    #];
  };

  nativeCheckInputs = [
    case
    hypothesis
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "kombu"
  ];

  disabledTests = [
    # Disable pyro4 test
    "test_driver_version"
  ];

  meta = with lib; {
    description = "Messaging library for Python";
    homepage = "https://github.com/celery/kombu";
    changelog = "https://github.com/celery/kombu/blob/v${version}/Changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
