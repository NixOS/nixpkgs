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
  version = "0.3.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "hexbytes";
    rev = "v${version}";
    hash = "sha256-EDFE5MUc+XMwe8BaXkz/DRchAZbS86X+AcShi5rx83M=";
  };

  nativeCheckInputs = [
    eth-utils
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hexbytes" ];

  meta = with lib; {
    description = "`bytes` subclass that decodes hex, with a readable console output";
    homepage = "https://github.com/ethereum/hexbytes";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
