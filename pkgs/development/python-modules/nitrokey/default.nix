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
  protobuf,
  semver,
  crcmod,
  hidapi,
}:

buildPythonPackage rec {
  pname = "nitrokey";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lf20du+DDwMrHrC+wCXxFNG8ThBnbonx4wq7DatH4X4=";
  };

  disabled = pythonOlder "3.9";

  pythonRelaxDeps = [ "protobuf" ];

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
