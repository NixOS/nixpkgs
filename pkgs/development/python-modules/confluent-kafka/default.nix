<<<<<<< HEAD
{ lib
, avro
, buildPythonPackage
, fastavro
, fetchFromGitHub
, jsonschema
, protobuf
, pyflakes
, pyrsistent
, pytestCheckHook
, pythonOlder
, rdkafka
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "confluent-kafka";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "confluent-kafka-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-6CdalNFKkgF7JUqCGtt4nB1/H3u4SVqt9xCAg5DR3T0=";
  };

  buildInputs = [
    rdkafka
  ];

  propagatedBuildInputs = [
    requests
  ];

  passthru.optional-dependencies = {
    avro = [
      avro
      fastavro
    ];
    json = [
      jsonschema
      pyrsistent
    ];
    protobuf = [
      protobuf
    ];
  };

  nativeCheckInputs = [
    pyflakes
    pytestCheckHook
    requests-mock
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "confluent_kafka"
  ];

  disabledTestPaths = [
    "tests/integration/"
    "tests/test_Admin.py"
    "tests/test_misc.py"
  ];
=======
{ lib, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro ? null, futures ? null, enum34 ? null }:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OzQupCJu0QXKi8A1sId+TcLxFf/adOOjUPNjaDNWUVs=";
  };

  buildInputs = [ rdkafka requests ] ++ (if isPy3k then [ avro3k ] else [ enum34 avro futures ]) ;

  # No tests in PyPi Tarball
  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = "https://github.com/confluentinc/confluent-kafka-python";
<<<<<<< HEAD
    changelog = "https://github.com/confluentinc/confluent-kafka-python/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
