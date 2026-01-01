{
  lib,
  amqp,
  azure-identity,
  azure-servicebus,
  azure-storage-queue,
  boto3,
  buildPythonPackage,
  confluent-kafka,
<<<<<<< HEAD
  fetchFromGitHub,
  google-cloud-pubsub,
  google-cloud-monitoring,
  grpcio,
=======
  fetchPypi,
  google-cloud-pubsub,
  google-cloud-monitoring,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  hypothesis,
  kazoo,
  msgpack,
  packaging,
<<<<<<< HEAD
  protobuf,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pycurl,
  pymongo,
  #, pyro4
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyyaml,
  redis,
  setuptools,
  sqlalchemy,
<<<<<<< HEAD
=======
  typing-extensions,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  tzdata,
  urllib3,
  vine,
}:

buildPythonPackage rec {
  pname = "kombu";
<<<<<<< HEAD
  version = "5.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celery";
    repo = "kombu";
    tag = "v${version}";
    hash = "sha256-kywPcWhc+iMh4OOH8gobA6NFismRvihgNMcxxw+2p/4=";
=======
  version = "5.5.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iGYAFoJ16+rak7iI6DE1L+V4FoNC8NHVgz2Iug2Ec2M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

<<<<<<< HEAD
  dependencies = [
=======
  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    amqp
    packaging
    tzdata
    vine
<<<<<<< HEAD
  ];
=======
  ]
  ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
      grpcio
      protobuf
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "kombu" ];

  disabledTests = [
    # Disable pyro4 test
    "test_driver_version"
    # AssertionError: assert [call('WATCH'..., 'test-tag')] ==...
    "test_global_keyprefix_transaction"
  ];

<<<<<<< HEAD
  meta = {
    description = "Messaging library for Python";
    homepage = "https://github.com/celery/kombu";
    changelog = "https://github.com/celery/kombu/blob/v${version}/Changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Messaging library for Python";
    homepage = "https://github.com/celery/kombu";
    changelog = "https://github.com/celery/kombu/blob/v${version}/Changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
