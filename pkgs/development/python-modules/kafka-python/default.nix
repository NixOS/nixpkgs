{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

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
}:

buildPythonPackage rec {
  pname = "kafka-python";
  version = "2.2.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dpkp";
    repo = "kafka-python";
    tag = version;
    hash = "sha256-huzUIyjRAgo0YTA5wn8oEoi3Ao5SX5wc0RxlXtMYXg0=";
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
    "kafka.consumer"
    "kafka.coordinator"
    "kafka.metrics"
    "kafka.partitioner"
    "kafka.producer"
    "kafka.protocol"
    "kafka.record"
    "kafka.sasl"
    "kafka.serializer"
    "kafka.vendor"
  ];

  nativeCheckInputs = [
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ];
  checkInputs = [ ] ++ optional-dependencies.crc32c;

  meta = {
    changelog = "https://github.com/dpkp/kafka-python/blob/${src.tag}/CHANGES.md";
    description = "Pure Python client for Apache Kafka";
    homepage = "https://github.com/dpkp/kafka-python";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ deshaw ];
  };
}
