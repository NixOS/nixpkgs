{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtserialport";
  qtInputs = [ qtbase ];
  patches = [ ./0001-dlopen-serialport-udev.patch ];
}
