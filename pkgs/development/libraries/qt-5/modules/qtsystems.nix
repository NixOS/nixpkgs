{ qtModule
, stdenv
, lib
, bluez
, libevdev
, libX11
, pkg-config
, qtbase
, udev
}:

qtModule {
  pname = "qtsystems";

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  qtInputs = [
    qtbase
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    bluez
    libevdev
    libX11
    udev
  ];

  qmakeFlags = [
    "CONFIG+=git_build"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    "CONFIG+=ofono"
    "CONFIG+=udisks"
    "CONFIG+=upower"
  ];

  meta = {
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
}
