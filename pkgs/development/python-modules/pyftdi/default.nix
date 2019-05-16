{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyusb
, pyserial
}:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.29.4";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jy0xbqvmhy0nq9v86759d96raa8p52yq8ik3ji5kjlx7cizq67v";
  };

  propagatedBuildInputs = [ pyusb pyserial ];

  meta = {
    description = "User-space driver for modern FTDI devices";
    homepage = "http://github.com/eblot/pyftdi";
    license = lib.licenses.lgpl2;
  };
}
