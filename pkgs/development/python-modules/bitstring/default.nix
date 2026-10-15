{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  bitarray,
  setuptools,
  pytest-benchmark,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bitstring";
  version = "4.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scott-griffiths";
    repo = "bitstring";
    tag = "bitstring-${version}";
    hash = "sha256-ZABAd42h+BqcpKTFV5PxcBN3F8FKV6Qw3rhP13eX57k=";
  };

  pythonRelaxDeps = [ "bitarray" ];

  build-system = [ setuptools ];

  dependencies = [ bitarray ];

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlags = [
    "--benchmark-disable"
  ];

  disabledTestPaths = [
    "tests/test_bits.py"
    "tests/test_fp8.py"
    "tests/test_mxfp.py"
  ];

  pythonImportsCheck = [ "bitstring" ];

  meta = {
    description = "Module for binary data manipulation";
    homepage = "https://github.com/scott-griffiths/bitstring";
    changelog = "https://github.com/scott-griffiths/bitstring/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
