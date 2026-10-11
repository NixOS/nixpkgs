{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-sdk-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ACKszYvOD0kt+ws+upxanvv11lKOix59dg25Fzs6Q80=";
  };

  patches = [
    (fetchpatch2 {
      name = "compatibility-with-pytest.patch";
      url = "https://github.com/Nitrokey/nitrokey-sdk-py/commit/c9b2516aa10027d238665ab7718fb474d80a2753.patch?full_index=1";
      hash = "sha256-3qYlV0RFLM2aJKfnO9WoQkXZuMisdaGuutmkRp33bWc=";
    })
  ];

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
