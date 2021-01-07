{ lib, buildPythonPackage, fetchPypi, base58, ecdsa, hidapi, noiseprotocol, protobuf, semver, typing-extensions }:

buildPythonPackage rec {
  pname = "bitbox02";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hnjjjarr4q22wh03zyyqfhsizzsvg46030kks3qkzbsv29vqqh5";
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
