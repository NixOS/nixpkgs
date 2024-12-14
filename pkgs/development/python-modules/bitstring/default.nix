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
  version = "4.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scott-griffiths";
    repo = pname;
    rev = "refs/tags/bitstring-${version}";
    hash = "sha256-m2LZdUWOMxzr/biZhD1nWagab8PohHTcr+U1di0nkrU=";
  };

  build-system = [ setuptools ];

  dependencies = [ bitarray ];

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlagsArray = [
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
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
