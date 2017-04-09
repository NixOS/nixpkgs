{ stdenv, qtSubmodule, qtbase, substituteAll, systemd }:

with stdenv.lib;

qtSubmodule {
  name = "qtserialport";
  qtInputs = [ qtbase ];
  patches = optionals (stdenv.isLinux) [
    (substituteAll {
      src = ./0001-dlopen-serialport-udev.patch;
      libudev = systemd.lib;
    })
  ];
}
