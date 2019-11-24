{ lib, buildPythonPackage, fetchPypi
, six, cryptography
, mock, pyfakefs
}:

buildPythonPackage rec {
  pname = "fido2";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b592ec0e51348f29636706fe3266423a0e41c35c9df63a259a91488450c1285";
  };

  propagatedBuildInputs = [ six cryptography ];

  checkInputs = [ mock pyfakefs ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB.";
    homepage = https://github.com/Yubico/python-fido2;
    license = licenses.mpl20;
  };
}
