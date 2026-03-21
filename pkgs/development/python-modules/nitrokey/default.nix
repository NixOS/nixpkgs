{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  cryptography,
  fido2,
  requests,
  tlv8,
  pyserial,
  protobuf,
  semver,
  crcmod,
  hidapi,
}:

buildPythonPackage rec {
  pname = "nitrokey";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZyB5gNZc5HxohZypc/198PPBxqG9URscQfXYAWzs7n8=";
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

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "nitrokey" ];

  meta = {
    description = "Python SDK for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/nitrokey-sdk-py";
    changelog = "https://github.com/Nitrokey/nitrokey-sdk-py/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ panicgh ];
  };
}
