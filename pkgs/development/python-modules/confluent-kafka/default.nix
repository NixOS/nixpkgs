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
  version = "2.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "confluent-kafka-python";
    tag = "v${version}";
    hash = "sha256-EDEp260G/t7s17RlbT+Bcl7FZlVQFagNijDNw53DFpY=";
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
    changelog = "https://github.com/confluentinc/confluent-kafka-python/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
