{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyusb
, pyserial
}:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.30.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed55f0cb2d2f84b6e97be9583d582480ba9777cb0179aac0bb0ac480cd6760f5";
  };

  propagatedBuildInputs = [ pyusb pyserial ];

  meta = {
    description = "User-space driver for modern FTDI devices";
    homepage = "http://github.com/eblot/pyftdi";
    license = lib.licenses.lgpl2;
  };
}
