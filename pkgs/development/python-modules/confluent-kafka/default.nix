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
}:

buildPythonPackage rec {
  pname = "confluent-kafka";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "confluent-kafka-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-sPlLlp0niR45lQPCvVd6NPtGI1cFbmPeQpIF1RnnY0I=";
  };

  buildInputs = [ rdkafka ];

  propagatedBuildInputs = [ requests ];

  passthru.optional-dependencies = {
    avro = [
      avro
      fastavro
    ];
    json = [
      jsonschema
      pyrsistent
    ];
    protobuf = [ protobuf ];
  };

  nativeCheckInputs = [
    pyflakes
    pytestCheckHook
    requests-mock
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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
