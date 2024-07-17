{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools-scm,
  crc32c,
  lz4,
  python-snappy,
  zstandard,
  botocore,
  pytest-mock,
  pytestCheckHook,
  xxhash,
}:

buildPythonPackage rec {
  version = "2.2.2";
  pname = "kafka-python-ng";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wbarnha";
    repo = "kafka-python-ng";
    rev = "refs/tags/v${version}";
    hash = "sha256-ELJvcj91MQ2RTjT1dwgnTGSSG5lP6B6/45dFgtNY2Cc=";
  };

  build-system = [ setuptools-scm ];

  passthru.optional-dependencies = {
    crc32c = [ crc32c ];
    lz4 = [ lz4 ];
    snappy = [ python-snappy ];
    zstd = [ zstandard ];
    boto = [ botocore ];
  };

  pythonImportsCheck = [ "kafka" ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    xxhash
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  meta = {
    changelog = "https://github.com/wbarnha/kafka-python-ng/releases/tag/v${version}";
    description = "Pure Python client for Apache Kafka";
    homepage = "https://github.com/wbarnha/kafka-python-ng";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
