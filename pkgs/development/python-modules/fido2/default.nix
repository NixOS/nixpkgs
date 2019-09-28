{ lib, buildPythonPackage, fetchPypi
, six, cryptography
, mock, pyfakefs
}:

buildPythonPackage rec {
  pname = "fido2";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10i61g8srx1dk0wfjj11s7ka5pv0661ivwg2r0y3y2nsnf5b90s4";
  };

  propagatedBuildInputs = [ six cryptography ];

  checkInputs = [ mock pyfakefs ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB.";
    homepage = https://github.com/Yubico/python-fido2;
    license = licenses.mpl20;
  };
}
