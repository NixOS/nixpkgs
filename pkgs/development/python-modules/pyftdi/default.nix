{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pythonOlder
, pyusb
}:

buildPythonPackage rec {
  pname = "pyftdi";
<<<<<<< HEAD
  version = "0.55.0";
=======
  version = "0.54.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eblot";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-EEMHY5EKftci72huF5UmJyh2wJAc8uNh/QhGSSAVXIU=";
=======
    hash = "sha256-vL8jSgTtDvaHuCvaCYmFixILQFasTl82yINL5yRtOwU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyserial
    pyusb
  ];

  # Tests require access to the serial port
  doCheck = false;

  pythonImportsCheck = [
    "pyftdi"
  ];

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
