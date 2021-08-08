{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pythonOlder
, pyusb
}:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.53.2";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "eblot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6cTQlYG/z8ZulMZLggGQ+PhuOOclWM0/+cfy0SF6dls=";
  };

  propagatedBuildInputs = [ pyusb pyserial ];

  # tests requires access to the serial port
  doCheck = false;

  pythonImportsCheck = [ "pyftdi" ];

  meta = with lib; {
    description = "User-space driver for modern FTDI devices";
    longDescription = ''
      PyFtdi aims at providing a user-space driver for popular FTDI devices.
      This includes UART, GPIO and multi-serial protocols (SPI, I2C, JTAG)
      bridges.
    '';
    homepage = "https://github.com/eblot/pyftdi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
