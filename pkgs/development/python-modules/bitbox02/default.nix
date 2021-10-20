{ lib, buildPythonPackage, fetchPypi, base58, ecdsa, hidapi, noiseprotocol, protobuf, semver, typing-extensions }:

buildPythonPackage rec {
  pname = "bitbox02";
  version = "5.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe0e8aeb9b32fd7d76bb3e9838895973a74dfd532a8fb8ac174a1a60214aee26";
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
