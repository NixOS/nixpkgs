{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "eth-typing";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-typing";
    rev = "refs/tags/v${version}";
    hash = "sha256-Xk/IfW1zuNbGdYAxXTNL9kL+ZW1bWruZ21KFV9+lv/E=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "eth_typing"
  ];

  meta = with lib; {
    description = "Common type annotations for Ethereum Python packages";
    homepage = "https://github.com/ethereum/eth-typing";
    changelog = "https://github.com/ethereum/eth-typing/blob/v${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
