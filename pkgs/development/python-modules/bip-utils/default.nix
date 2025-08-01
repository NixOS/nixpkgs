{
  lib,
  buildPythonPackage,
  cbor2,
  coincurve,
  crcmod,
  ecdsa,
  ed25519-blake2b,
  fetchFromGitHub,
  py-sr25519-bindings,
  pycryptodome,
  pynacl,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bip-utils";
  version = "2.9.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ebellocchia";
    repo = "bip_utils";
    tag = "v${version}";
    hash = "sha256-3G37n/mfI+3JVIkmJWzbB1qPPTE6NJJlFZWdE0fIIWA=";
  };

  nativeBuildInputs = [ setuptools ];

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

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bip_utils" ];

  meta = with lib; {
    description = "Implementation of BIP39, BIP32, BIP44, BIP49 and BIP84 for wallet seeds, keys and addresses generation";
    homepage = "https://github.com/ebellocchia/bip_utils";
    changelog = "https://github.com/ebellocchia/bip_utils/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      prusnak
      stargate01
    ];
  };
}
