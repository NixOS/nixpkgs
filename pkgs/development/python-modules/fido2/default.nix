{ lib
, buildPythonPackage
, fetchPypi
, six
, cryptography
, mock
, pyfakefs
}:

buildPythonPackage rec {
  pname = "fido2";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hzprnd407g2xh9kyv8j8pq949hwr1snmg3fp65pqfbghzv6i424";
  };

  propagatedBuildInputs = [ six cryptography ];

  checkInputs = [ mock pyfakefs ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB.";
    homepage = "https://github.com/Yubico/python-fido2";
    license = licenses.bsd2;
    maintainers = with maintainers; [ prusnak ];
  };
}
