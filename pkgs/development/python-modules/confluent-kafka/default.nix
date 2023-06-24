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
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "confluent-kafka-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-xnbovQRvbhaYYXnssV0Jy+U9L6BUddIagbup2jdTugY=";
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
  ];

  meta = with lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = "https://github.com/confluentinc/confluent-kafka-python";
    changelog = "https://github.com/confluentinc/confluent-kafka-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
