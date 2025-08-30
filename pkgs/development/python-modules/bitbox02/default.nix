{
  lib,
  base58,
  buildPythonPackage,
  ecdsa,
  fetchPypi,
  hidapi,
  noiseprotocol,
  protobuf,
  pythonOlder,
  semver,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "bitbox02";
  version = "7.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J9UQXrFaVTcZ+p0+aJIchksAyGGzpkQETZrGhCbxhEc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    base58
    ecdsa
    hidapi
    noiseprotocol
    protobuf
    semver
    typing-extensions
  ];

  # does not contain tests
  doCheck = false;

  pythonImportsCheck = [ "bitbox02" ];

  meta = with lib; {
    description = "Firmware code of the BitBox02 hardware wallet";
    homepage = "https://github.com/digitalbitbox/bitbox02-firmware/";
    changelog = "https://github.com/digitalbitbox/bitbox02-firmware/blob/py-bitbox02-${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
