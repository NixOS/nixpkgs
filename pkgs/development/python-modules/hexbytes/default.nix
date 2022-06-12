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
  version = "0.2.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "hexbytes";
    rev = "v${version}";
    sha256 = "sha256-SZscM6ze9yY+iRDx/5F4XbrLXIbp6QkFnzxN7zvP9CQ=";
  };

  checkInputs = [
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
