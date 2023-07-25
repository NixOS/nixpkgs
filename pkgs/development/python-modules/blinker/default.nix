{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "blinker";
  version = "1.6.2";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "blinker";
    rev = "refs/tags/${version}";
    hash = "sha256-s74zYyExttRxHFPanw5Zqeby36Dq6aJj3IeQQGw3aes=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "blinker"
  ];

  meta = with lib; {
    homepage = "https://pythonhosted.org/blinker/";
    description = "Fast, simple object-to-object and broadcast signaling";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
