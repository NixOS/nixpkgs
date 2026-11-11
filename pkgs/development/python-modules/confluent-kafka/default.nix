{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # buildInputs
  rdkafka,

  # build-system
  setuptools,

  # optional-dependencies
  # avro:
  avro,
  fastavro,
  requests,
  # json-fast:
  orjson,
  # json:
  jsonschema,
  pyrsistent,
  # oauthbearer-aws:
  boto3,
  # protobuf:
  protobuf,
  # rules:
  azure-identity,
  azure-keyvault-keys,
  cel-python,
  google-auth,
  google-api-core,
  google-cloud-kms,
  google-re2,
  hvac,
  pyyaml,
  # schema-registry:
  attrs,
  authlib,
  cachetools,
  certifi,
  httpx,

  # tests
  pyflakes,
  pytest-asyncio,
  pytestCheckHook,
  requests-mock,
  respx,

  # passthru
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "confluent-kafka";
  version = "2.15.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "confluent-kafka-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZKeIHfFSI4o2hXttveS8rclEH3wMkl8wJiy7HFjScww=";
  };

  buildInputs = [ rdkafka ];

  build-system = [ setuptools ];

  optional-dependencies = {
    avro = [
      avro
      fastavro
      requests
    ];
    json-fast = [
      orjson
    ];
    json = [
      jsonschema
      pyrsistent
      requests
    ];
    oauthbearer-aws = [
      boto3
    ];
    protobuf = [
      protobuf
      requests
    ];
    rules = [
      azure-identity
      azure-keyvault-keys
      boto3
      cel-python
      google-auth
      google-api-core
      google-cloud-kms
      google-re2
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
      certifi
      httpx
    ];
  };

  # test suite starts a real localhost server; hangs without this on darwin
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    cachetools
    orjson
    pyflakes
    pytest-asyncio
    pytestCheckHook
    requests-mock
    respx
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "confluent_kafka" ];

  disabledTestPaths = [
    "tests/integration/"
    "tests/test_Admin.py"
    "tests/test_misc.py"
    # missing tink dependency
    "tests/schema_registry/_async/test_config.py"
    "tests/schema_registry/_sync/test_config.py"
    "tests/schema_registry/_async/test_avro_serdes.py"
    "tests/schema_registry/_sync/test_avro_serdes.py"
    "tests/schema_registry/_async/test_json_serdes.py"
    "tests/schema_registry/_sync/test_json_serdes.py"
    "tests/schema_registry/_async/test_proto_serdes.py"
    "tests/schema_registry/_sync/test_proto_serdes.py"
    "tests/schema_registry/test_hcvault_driver.py"
    # crashes the test runner on shutdown
    "tests/test_kafka_error.py"
    # stats_cb can raise during consumer.close() causing race-condition
    "tests/test_Consumer.py::test_callback_exception_no_system_error"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
    };
  };

  meta = {
    description = "Confluent's Apache Kafka client for Python";
    homepage = "https://github.com/confluentinc/confluent-kafka-python";
    changelog = "https://github.com/confluentinc/confluent-kafka-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mlieberman85 ];
  };
})
