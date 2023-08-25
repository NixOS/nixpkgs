{ lib
, buildPythonPackage
, fetchFromGitHub
, eth-utils
, hypothesis
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hexbytes";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "hexbytes";
    rev = "refs/tags/v${version}";
    hash = "sha256-19oY/VPP6qkxHCkIgpC28fOOYKEYcNbVVGoHJmMmOl8=";
  };

  nativeCheckInputs = [
    eth-utils
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hexbytes"
  ];

  meta = with lib; {
    description = "`bytes` subclass that decodes hex, with a readable console output";
    homepage = "https://github.com/ethereum/hexbytes";
    changelog = "https://github.com/ethereum/hexbytes/blob/v${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
