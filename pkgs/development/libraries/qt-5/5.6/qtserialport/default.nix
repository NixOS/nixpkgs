{ qtSubmodule, qtbase, substituteAll, systemd }:

qtSubmodule {
  name = "qtserialport";
  qtInputs = [ qtbase ];
  patches = [
    (substituteAll {
      src = ./0001-dlopen-serialport-udev.patch;
      libudev = systemd.lib;
    })
  ];
}
