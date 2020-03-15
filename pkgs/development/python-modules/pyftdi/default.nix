{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyusb
, pyserial
}:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.44.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18k9wnpjxg71v4jm0pwr2bmksq7sckr6ylh1slf0xgpg89b27bxq";
  };

  propagatedBuildInputs = [ pyusb pyserial ];

  meta = {
    description = "User-space driver for modern FTDI devices";
    homepage = "https://github.com/eblot/pyftdi";
    license = lib.licenses.lgpl2;
  };
}
