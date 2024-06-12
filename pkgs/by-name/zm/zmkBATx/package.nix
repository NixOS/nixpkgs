{
  stdenv,
  fetchFromGitHub,
  lib,
  qt6,
  pkg-config,
  dbus,
  simpleBluez,
  simpleDBus,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zmkBATx";

  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mh4x0f";
    repo = "zmkBATx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xbiwRHVTuaZDH3RZlMK2CpKBThtS8g6q5r3C+OccDZg=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    pkg-config
    qt6.qmake
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtconnectivity
    dbus.lib
    simpleBluez
    simpleDBus
  ];

  postPatch = ''
    substituteInPlace zmkBATx.pro --replace-fail "/usr/include/dbus-1.0" "${dbus.dev}/include/dbus-1.0"
    substituteInPlace zmkBATx.pro --replace-fail "/usr/lib/x86_64-linux-gnu/dbus-1.0/include" "${dbus.lib}/lib/dbus-1.0/include"
  '';

  meta = with lib; {
    description = "Battery monitoring for ZMK split keyboards";
    longDescription = "Opensource tool for peripheral battery monitoring zmk split keyboard over BLE for linux.";
    homepage = "https://github.com/mh4x0f/zmkBATx";
    license = licenses.mit;
    mainProgram = "zmkbatx";
    platforms = platforms.linux;
    maintainers = with maintainers; [ aciceri ];
  };
})
