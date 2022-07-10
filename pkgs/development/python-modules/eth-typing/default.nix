{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "eth-typing";
  version = "3.1.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-typing";
    rev = "v${version}";
    sha256 = "sha256-Xk/IfW1zuNbGdYAxXTNL9kL+ZW1bWruZ21KFV9+lv/E=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "eth_typing" ];

  meta = {
    description = "Common type annotations for Ethereum Python packages";
    homepage = "https://github.com/ethereum/eth-typing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
