{ lib, buildPythonPackage, fetchPypi, base58, ecdsa, hidapi, noiseprotocol, protobuf, semver, typing-extensions }:

buildPythonPackage rec {
  pname = "bitbox02";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52b0b617660601939b30c8b588c28910946448b1b6d69ca231d5e3e47a322b71";
  };

  propagatedBuildInputs = [ base58 ecdsa hidapi noiseprotocol protobuf semver typing-extensions ];

  # does not contain tests
  doCheck = false;
  pythonImportsCheck = [ "bitbox02" ];

  meta = with lib; {
    description = "Firmware code of the BitBox02 hardware wallet";
    homepage = "https://github.com/digitalbitbox/bitbox02-firmware/";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
