{ lib, buildPythonPackage, fetchPypi
, six, cryptography
, mock, pyfakefs
}:

buildPythonPackage rec {
  pname = "fido2";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11wdcjymw8y6wxgp29gbhdxff3lpc5yp5fcqnr5vnj88g192ic27";
  };

  propagatedBuildInputs = [ six cryptography ];

  checkInputs = [ mock pyfakefs ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB.";
    homepage = https://github.com/Yubico/python-fido2;
    license = licenses.mpl20;
  };
}
