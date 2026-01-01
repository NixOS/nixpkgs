{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-ZyB5gNZc5HxohZypc/198PPBxqG9URscQfXYAWzs7n8=";
  };

  pythonRelaxDeps = [
    "protobuf"
    "hidapi"
  ];
=======
    hash = "sha256-m351pDLMuZaddbUqJz5r/ljz/vVq+RBDGk4xskc3HCk=";
  };

  pythonRelaxDeps = [ "protobuf" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Python SDK for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/nitrokey-sdk-py";
    changelog = "https://github.com/Nitrokey/nitrokey-sdk-py/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ panicgh ];
=======
  meta = with lib; {
    description = "Python SDK for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/nitrokey-sdk-py";
    changelog = "https://github.com/Nitrokey/nitrokey-sdk-py/releases/tag/v${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ panicgh ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
