{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  poetry-core,
  cryptography,
  fido2,
  requests,
  tlv8,
  pyserial,
  protobuf5,
  semver,
  crcmod,
  hidapi,
}:

buildPythonPackage rec {
  pname = "nitrokey";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Ig2LI7waU/IbUwApyFI2TwtarT5bYolgeq14SgmbEo=";
  };

  disabled = pythonOlder "3.9";

  build-system = [ poetry-core ];

  dependencies = [
    fido2
    requests
    semver
    tlv8
    crcmod
    cryptography
    hidapi
    protobuf5
    pyserial
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "nitrokey" ];

  meta = with lib; {
    description = "Python SDK for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/nitrokey-sdk-py";
    changelog = "https://github.com/Nitrokey/nitrokey-sdk-py/releases/tag/v${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ panicgh ];
  };
}
