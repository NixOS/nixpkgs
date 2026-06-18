{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pythonAtLeast,

  # build system
  setuptools,

  # optional dependencies
  crc32c,
  lz4,
  pyperf,
  python-snappy,
  zstandard,

  # test dependencies
  pytestCheckHook,
  pytest-mock,
  pytest-timeout,
  xxhash,
}:

buildPythonPackage (finalAttrs: {
  pname = "kafka-python";
  version = "3.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dpkp";
    repo = "kafka-python";
    tag = finalAttrs.version;
    hash = "sha256-eQGQWLXCtj9A5Gb7inyKPdVD+1Pxh8yPFdNEBkkk58c=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    benchmarks = [ pyperf ];
    crc32c = [ crc32c ];
    lz4 = [ lz4 ];
    snappy = [ python-snappy ];
    zstd = [ zstandard ];
  };

  pythonImportsCheck = [
    "kafka"
    "kafka.admin"
    "kafka.benchmarks"
    "kafka.cli"
    "kafka.consumer"
    "kafka.coordinator"
    "kafka.metrics"
    "kafka.net"
    "kafka.partitioner"
    "kafka.producer"
    "kafka.protocol"
    "kafka.record"
    "kafka.serializer"
    "kafka.vendor"
  ];

  nativeCheckInputs = [
    pytest-mock
    pytest-timeout
    pytestCheckHook
    xxhash
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  meta = {
    changelog = "https://github.com/dpkp/kafka-python/blob/${finalAttrs.src.tag}/CHANGES.md";
    description = "Pure Python client for Apache Kafka";
    homepage = "https://github.com/dpkp/kafka-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
