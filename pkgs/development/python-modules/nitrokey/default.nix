{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  cryptography,
  fido2,
  requests,
  tlv8,
  pyserial,
  protobuf,
  semver,
  crcmod,
  hidapi,
  pyscard,
}:

buildPythonPackage (finalAttrs: {
  pname = "nitrokey";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-sdk-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HvTirrcOHyG9e++5xvAprGEbLNENuL/hZHduswB7Vv8=";
  };

  pythonRelaxDeps = [
    "protobuf"
    "hidapi"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    fido2
    requests
    semver
    tlv8
    crcmod
    cryptography
    hidapi
    protobuf
    pyserial
  ];

  optional-dependencies = {
    ccid = [
      pyscard
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nitrokey" ];

  meta = {
    description = "Python SDK for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/nitrokey-sdk-py";
    changelog = "https://github.com/Nitrokey/nitrokey-sdk-py/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ panicgh ];
  };
})
