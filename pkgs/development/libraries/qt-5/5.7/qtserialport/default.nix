{ qtSubmodule, qtbase, substituteAll, libudev, stdenv }:

qtSubmodule {
  name = "qtserialport";
  qtInputs = [ qtbase ];
  patches = if stdenv.isLinux then [
    (substituteAll {
      src = ./0001-dlopen-serialport-udev.patch;
      libudev = libudev.out;
    })
  ] else [];
}
