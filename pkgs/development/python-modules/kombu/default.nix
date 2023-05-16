{ lib
, amqp
<<<<<<< HEAD
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
=======
, azure-servicebus
, buildPythonPackage
, cached-property
, case
, fetchPypi
, importlib-metadata
, pyro4
, pytestCheckHook
, pythonOlder
, pytz
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, vine
}:

buildPythonPackage rec {
  pname = "kombu";
<<<<<<< HEAD
  version = "5.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C6IT9jCiyydycorvVqxog9w6LxNDXhAEj26X1IUG270=";
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
=======
  version = "5.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N87j7nJflOqLsXPqq3wXYCA+pTu+uuImMoYA+dJ5lhA=";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace "pytz>dev" "pytz"
  '';

  propagatedBuildInputs = [
    amqp
    vine
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
    importlib-metadata
  ];

  nativeCheckInputs = [
    azure-servicebus
    case
    pyro4
    pytestCheckHook
    pytz
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "kombu"
  ];

<<<<<<< HEAD
  disabledTests = [
    # Disable pyro4 test
    "test_driver_version"
  ];

  meta = with lib; {
    description = "Messaging library for Python";
    homepage = "https://github.com/celery/kombu";
    changelog = "https://github.com/celery/kombu/releases/tag/v${version}";
=======
  meta = with lib; {
    description = "Messaging library for Python";
    homepage = "https://github.com/celery/kombu";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
