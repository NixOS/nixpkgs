{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, ecdsa
, pysha3
}:

buildPythonPackage rec {
  pname = "bip_utils";
  version = "1.9.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ebellocchia";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i1jdpdsrc8cal5x0b1am9mgbca69ymxlaqpkw0y4d0m3m6vs33k";
  };

  propagatedBuildInputs = [ ecdsa pysha3 ];

  pythonImportsCheck = [
    "bip_utils"
  ];

  meta = {
    description = "Implementation of BIP39, BIP32, BIP44, BIP49 and BIP84 for wallet seeds, keys and addresses generation";
    homepage = "https://github.com/ebellocchia/bip_utils";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
