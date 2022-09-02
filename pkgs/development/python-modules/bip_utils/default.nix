{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, ecdsa
, pysha3
}:

buildPythonPackage rec {
  pname = "bip_utils";
  version = "2.5.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ebellocchia";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-lH8hd+JA1FhGH60MYIIuwHjr/4wFbYeuw/hd60kr1xc=";
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
