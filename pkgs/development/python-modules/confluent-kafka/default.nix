{
  lib,
  avro,
  azure-identity,
  azure-keyvault-keys,
  boto3,
  buildPythonPackage,
  cacert,
  cachetools,
  fastavro,
  fetchFromGitHub,
  google-auth,
  google-api-core,
  google-cloud-kms,
  hvac,
  jsonschema,
  protobuf,
  pyflakes,
  pyrsistent,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  rdkafka,
  requests,
  requests-mock,
  respx,
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
    rules = [
      azure-identity
      azure-keyvault-keys
      boto3
      # TODO: cel-python
      google-auth
      google-api-core
      google-cloud-kms
      # hkdf was removed
      hvac
      # TODO: jsonata-python
      pyyaml
      # TODO: tink
    ];
    schema-registry = [ requests ];
  };

  nativeCheckInputs = [
    cachetools
    pyflakes
    pytestCheckHook
    requests-mock
    respx
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "confluent_kafka" ];

  disabledTestPaths = [
    "tests/integration/"
    "tests/test_Admin.py"
    "tests/test_misc.py"
    # missing cel-python dependency
    "tests/schema_registry/test_avro_serdes.py"
    "tests/schema_registry/test_json_serdes.py"
    "tests/schema_registry/test_proto_serdes.py"
  ];

  meta = with lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = "https://github.com/confluentinc/confluent-kafka-python";
    changelog = "https://github.com/confluentinc/confluent-kafka-python/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
