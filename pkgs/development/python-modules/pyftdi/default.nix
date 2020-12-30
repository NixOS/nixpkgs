{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pythonOlder
, pyusb
}:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.52.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "eblot";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nm4z7v9qcb9mxqbl21jgzica4faldnpy5qmbkrc6scnx55pxfm9";
  };

  propagatedBuildInputs = [ pyusb pyserial ];

  # tests requires access to the serial port
  doCheck = false;

  pythonImportsCheck = [ "pyftdi" ];

  meta = {
    description = "User-space driver for modern FTDI devices";
    homepage = "https://github.com/eblot/pyftdi";
    license = lib.licenses.bsd3;
  };
}
