{ qtSubmodule, qtbase, substituteAll, libudev }:

qtSubmodule {
  name = "qtserialport";
  qtInputs = [ qtbase ];

  patches = [
    (substituteAll {
      src = ./0001-dlopen-serialport-udev.patch;
      libudev = libudev.out;
    })
  ];
  postFixup = ''
    fixQtModuleCMakeConfig "SerialPort"
  '';
}
