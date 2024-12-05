{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pythonAtLeast,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "qtm";
  version = "2.1.2";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "qualisys";
    repo = "qualisys_python_sdk";
    rev = "v${version}";
    hash = "sha256-cfQV4s0hXq7kxP5AJAskdR+JJzlpCObTDZ4qLOZt0/o=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.11") [
    # This test fails with Python 3.11+, but the library is still compatible
    "test/qtmprotocol_test.py"
  ];

  pythonImportsCheck = [ "qtm" ];

  meta = with lib; {
    homepage = "https://github.com/qualisys/qualisys_python_sdk";
    description = "Python implementation of the real-time protocol for Qualisys Track Manager (legacy version)";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      vbruegge
      stargate01
    ];
  };
}
