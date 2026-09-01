{
  lib,
  base58,
  buildPythonPackage,
  ecdsa,
  fetchPypi,
  hidapi,
  noiseprotocol,
  protobuf,
  semver,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "bitbox02";
  version = "7.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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

  meta = {
    description = "Firmware code of the BitBox02 hardware wallet";
    homepage = "https://github.com/digitalbitbox/bitbox02-firmware/";
    changelog = "https://github.com/digitalbitbox/bitbox02-firmware/blob/py-bitbox02-${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
