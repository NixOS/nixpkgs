{
  lib,
  avro,
  buildPythonPackage,
  fastavro,
  fetchFromGitHub,
  jsonschema,
  protobuf,
  pyflakes,
  pyrsistent,
  pytestCheckHook,
  pythonOlder,
  rdkafka,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "confluent-kafka";
  version = "2.5.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "confluent-kafka-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-b9RTz4wUtDzGkoeB0cp5vbZEBk8jSw2JiXEx6tUuPVw=";
  };

  buildInputs = [ rdkafka ];

  build-system = [ setuptools ];

  optional-dependencies = {
    avro = [
      avro
      fastavro
      requests
    ];
    json = [
      jsonschema
      pyrsistent
      requests
    ];
    protobuf = [
      protobuf
      requests
    ];
    schema-registry = [ requests ];
  };

  nativeCheckInputs = [
    pyflakes
    pytestCheckHook
    requests-mock
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "confluent_kafka" ];

  disabledTestPaths = [
    "tests/integration/"
    "tests/test_Admin.py"
    "tests/test_misc.py"
  ];

  meta = with lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = "https://github.com/confluentinc/confluent-kafka-python";
    changelog = "https://github.com/confluentinc/confluent-kafka-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
