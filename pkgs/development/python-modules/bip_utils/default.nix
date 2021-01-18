{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, ecdsa
, pysha3
}:

buildPythonPackage rec {
  pname = "bip_utils";
  version = "1.6.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ebellocchia";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zbjrgl4dd65r3liyp8syxr106z1wn7ngfcm5dlfcxqwj8zkf56m";
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
