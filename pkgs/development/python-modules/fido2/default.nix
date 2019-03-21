{ lib, buildPythonPackage, fetchPypi
, six, cryptography
, mock, pyfakefs
}:

buildPythonPackage rec {
  pname = "fido2";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pl8d2pr6jzqj4y9qiaddhjgnl92kikjxy0bgzm2jshkzzic8mp3";
  };

  propagatedBuildInputs = [ six cryptography ];

  checkInputs = [ mock pyfakefs ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB.";
    homepage = https://github.com/Yubico/python-fido2;
    license = licenses.mpl20;
  };
}
