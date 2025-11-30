{
  lib,
  attrs,
  authlib,
  avro,
  azure-identity,
  azure-keyvault-keys,
  boto3,
  buildPythonPackage,
  cachetools,
  fastavro,
  fetchFromGitHub,
  google-auth,
  google-api-core,
  google-cloud-kms,
  hvac,
  httpx,
  jsonschema,
  orjson,
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
  version = "2.11.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "confluent-kafka-python";
    tag = "v${version}";
    hash = "sha256-WpvWv6UG7T0yJ1ZKZweHbWjh+C0PbEIYbbMAS4yyhzg=";
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
    schema-registry = [
      attrs
      authlib
      cachetools
      httpx
      orjson
    ];
  };

  nativeCheckInputs = [
    cachetools
    orjson
    pyflakes
    pytestCheckHook
    requests-mock
    respx
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "confluent_kafka" ];

  disabledTestPaths = [
    "tests/integration/"
    "tests/test_Admin.py"
    "tests/test_misc.py"
    # Failed: async def functions are not natively supported.
    "tests/schema_registry/_async"
    # missing cel-python dependency
    "tests/schema_registry/_sync/test_avro_serdes.py"
    "tests/schema_registry/_sync/test_json_serdes.py"
    "tests/schema_registry/_sync/test_proto_serdes.py"
    # missing tink dependency
    "tests/schema_registry/_async/test_config.py"
    "tests/schema_registry/_sync/test_config.py"
    # crashes the test runner on shutdown
    "tests/test_kafka_error.py"
  ];

  meta = with lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = "https://github.com/confluentinc/confluent-kafka-python";
    changelog = "https://github.com/confluentinc/confluent-kafka-python/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
