{ qtModule
, stdenv
, lib
, bluez
, libevdev
, libX11
, pkg-config
, qtbase
, udev
, wrapQtAppsHook
}:

qtModule {
  pname = "qtsystems";

  outputs = [
    "out"
    "dev"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    "bin"
  ];

  qtInputs = [
    qtbase
  ];

  nativeBuildInputs = [
    pkg-config
    wrapQtAppsHook
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

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapQtApp $bin/bin/servicefw
  '';

  meta = {
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
}
