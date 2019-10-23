{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyusb
, pyserial
}:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.30.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0avmxz38bkl6hp3fn1jm31qahsdp76j454mfnpxwx5wlk35iss09";
  };

  propagatedBuildInputs = [ pyusb pyserial ];

  meta = {
    description = "User-space driver for modern FTDI devices";
    homepage = "http://github.com/eblot/pyftdi";
    license = lib.licenses.lgpl2;
  };
}
