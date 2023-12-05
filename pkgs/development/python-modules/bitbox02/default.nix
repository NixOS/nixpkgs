{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, base58
, ecdsa
, hidapi
, noiseprotocol
, protobuf
, semver
, typing-extensions
}:

buildPythonPackage rec {
  pname = "bitbox02";
  version = "6.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zt4G45nJjtU2/tbYpCEgjaoA+Xtpe9g2OpQaxfMzCb8=";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "bitbox02"
  ];

  meta = with lib; {
    description = "Firmware code of the BitBox02 hardware wallet";
    homepage = "https://github.com/digitalbitbox/bitbox02-firmware/";
    changelog = "https://github.com/digitalbitbox/bitbox02-firmware/blob/py-bitbox02-${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
