{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyusb
, pyserial
}:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.42.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bpb2rq7bc3p4g9qrfp4a7qcic79cvv1wh17j231bnpmy48njhvj";
  };

  propagatedBuildInputs = [ pyusb pyserial ];

  meta = {
    description = "User-space driver for modern FTDI devices";
    homepage = "https://github.com/eblot/pyftdi";
    license = lib.licenses.lgpl2;
  };
}
