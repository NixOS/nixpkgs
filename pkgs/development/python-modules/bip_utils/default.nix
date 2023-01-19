{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, ecdsa
, coincurve
, pynacl
, crcmod
, ed25519-blake2b
, py-sr25519-bindings
, cbor2
, pycryptodome
}:

buildPythonPackage rec {
  pname = "bip_utils";
  version = "2.7.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ebellocchia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m7/CC5/T6qR2Ot4y5WQlzOAR0czz6XHCjJskES+2nns=";
  };

  propagatedBuildInputs = [
    ecdsa
    cbor2
    pynacl
    coincurve
    crcmod
    ed25519-blake2b
    py-sr25519-bindings
    pycryptodome
  ];

  pythonImportsCheck = [
    "bip_utils"
  ];

  meta = {
    description = "Implementation of BIP39, BIP32, BIP44, BIP49 and BIP84 for wallet seeds, keys and addresses generation";
    homepage = "https://github.com/ebellocchia/bip_utils";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak stargate01 ];
  };
}
