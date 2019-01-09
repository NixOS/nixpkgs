{ lib, buildPythonPackage, fetchPypi, six, cryptography }:

buildPythonPackage rec {
  pname = "fido2";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pl8d2pr6jzqj4y9qiaddhjgnl92kikjxy0bgzm2jshkzzic8mp3";
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
