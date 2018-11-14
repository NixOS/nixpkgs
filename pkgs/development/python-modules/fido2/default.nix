{ lib, buildPythonPackage, fetchPypi, six, cryptography }:

buildPythonPackage rec {
  pname = "fido2";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12245b16czsgq4a251jqlk5qs3sldlcryfcganswzk2lbgplmn7q";
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
