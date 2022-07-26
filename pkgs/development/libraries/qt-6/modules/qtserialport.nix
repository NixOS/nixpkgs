{ qtModule
, stdenv
, lib
, qtbase
, udev
, pkg-config
}:

qtModule {
  pname = "qtserialport";
  qtInputs = [ qtbase ];
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ udev ];
}
