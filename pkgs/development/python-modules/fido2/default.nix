{ lib, buildPythonPackage, fetchPypi, six, cryptography }:

buildPythonPackage rec {
  pname = "fido2";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ddbhg4nsabi9w66l8vkr0i5r80jqihlic5yrdl3v1aqahvxph1j";
  };

  # The pypi package does not include tests
  # Check https://github.com/Yubico/python-fido2/pull/8
  doCheck = false;

  propagatedBuildInputs = [ six cryptography ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB.";
    homepage = https://github.com/Yubico/python-fido2;
    license = licenses.mpl20;
  };
}
