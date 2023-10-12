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
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bip-utils";
  version = "2.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ebellocchia";
    repo = "bip_utils";
    rev = "refs/tags/v${version}";
    hash = "sha256-QrCkLiGBdZTQCnbWSTN0PeoAsQfg2CoSGdZcbhqTvOk=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "coincurve>=15.0.1,<18.0.0" "coincurve"
  '';

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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bip_utils"
  ];

  meta = with lib; {
    description = "Implementation of BIP39, BIP32, BIP44, BIP49 and BIP84 for wallet seeds, keys and addresses generation";
    homepage = "https://github.com/ebellocchia/bip_utils";
    changelog = "https://github.com/ebellocchia/bip_utils/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ prusnak stargate01 ];
  };
}
