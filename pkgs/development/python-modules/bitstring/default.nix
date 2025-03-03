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
  version = "4.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scott-griffiths";
    repo = pname;
    tag = "bitstring-${version}";
    hash = "sha256-0AaOVjroVb/maFBaB55ahwWyRHHnofja4pgSgjQMsT8=";
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
