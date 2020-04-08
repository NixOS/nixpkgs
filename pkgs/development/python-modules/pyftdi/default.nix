{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, pyusb, pyserial }:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.49.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "eblot";
    repo = pname;
    rev = "v${version}";
    sha256 = "063kwvgw7g4nn09pyqwqy72vnhzw0aajg23bi32vr0k49g8fx27s";
  };

  propagatedBuildInputs = [ pyusb pyserial ];

  pythonImportsCheck = [ "pyftdi" ];

  meta = {
    description = "User-space driver for modern FTDI devices";
    homepage = "https://github.com/eblot/pyftdi";
    license = lib.licenses.bsd3;
  };
}
