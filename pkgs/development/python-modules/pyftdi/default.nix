{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, pyusb, pyserial }:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.51.2";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "eblot";
    repo = pname;
    rev = "v${version}";
    sha256 = "14mkwk44bgm6s4kqagz7nm6p6gsygmksl2628jaqh7ppblxca9as";
  };

  propagatedBuildInputs = [ pyusb pyserial ];

  pythonImportsCheck = [ "pyftdi" ];

  meta = {
    description = "User-space driver for modern FTDI devices";
    homepage = "https://github.com/eblot/pyftdi";
    license = lib.licenses.bsd3;
  };
}
