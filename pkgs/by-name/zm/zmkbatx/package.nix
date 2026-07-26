{
  stdenv,
  fetchFromGitHub,
  lib,
  qt6,
  pkg-config,
  dbus,
  simplebluez,
  simpledbus,
}:
let
  # zmkBATx is incompatible against the new ABI
  simplebluez' = simplebluez.overrideAttrs rec {
    version = "0.7.3";
    src = fetchFromGitHub {
      owner = "OpenBluetoothToolbox";
      repo = "SimpleBLE";
      rev = "v${version}";
      hash = "sha256-CPBdPnBeQ0c3VjSX0Op6nCHF3w0MdXGULbk1aavr+LM=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zmkbatx";

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
    simpledbus
    simplebluez'
  ];

  postPatch = ''
    substituteInPlace zmkBATx.pro --replace-fail "/usr/include/dbus-1.0" "${dbus.dev}/include/dbus-1.0"
    substituteInPlace zmkBATx.pro --replace-fail "/usr/lib/x86_64-linux-gnu/dbus-1.0/include" "${dbus.lib}/lib/dbus-1.0/include"
  '';

  meta = {
    description = "Battery monitoring for ZMK split keyboards";
    longDescription = "Opensource tool for peripheral battery monitoring zmk split keyboard over BLE for linux.";
    homepage = "https://github.com/mh4x0f/zmkBATx";
    changelog = "https://github.com/mh4x0f/zmkBATx/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "zmkbatx";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aciceri ];
  };
})
