{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, ecdsa
, pysha3
}:

buildPythonPackage rec {
  pname = "bip_utils";
  version = "2.2.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ebellocchia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-p2JOZAJxQ/nPZ7vjnB24hA3kz3Io4D3HTP/8mqS/XCc=";
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
