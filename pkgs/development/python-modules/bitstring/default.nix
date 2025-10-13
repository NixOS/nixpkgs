{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  bitarray,
  setuptools,
  pytest-benchmark,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bitstring";
  version = "4.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Module for binary data manipulation";
    homepage = "https://github.com/scott-griffiths/bitstring";
    changelog = "https://github.com/scott-griffiths/bitstring/releases/tag/${src.tag}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
