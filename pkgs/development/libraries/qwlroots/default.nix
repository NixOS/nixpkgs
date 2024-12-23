{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  wayland-scanner,
  qtbase,
  wayland,
  wayland-protocols,
  wlr-protocols,
  pixman,
  libgbm,
  vulkan-loader,
  libinput,
  xorg,
  seatd,
  wlroots,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qwlroots";
  version = "0.3.0-wlroots0.17-0.18";

  src = fetchFromGitHub {
    owner = "vioken";
    repo = "qwlroots";
    rev = finalAttrs.version;
    hash = "sha256-ObXegiJ4LT8bTUxNVJ9wBKN5oILWPDYTsuCy+OCsh3k=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    qtbase
    wayland
    wayland-protocols
    wlr-protocols
    pixman
    libgbm
    vulkan-loader
    libinput
    xorg.libXdmcp
    xorg.xcbutilerrors
    seatd
  ];

  propagatedBuildInputs = [
    wlroots
  ];

  cmakeFlags = [
    (lib.cmakeBool "PREFER_QT_5" (lib.versionOlder qtbase.version "6"))
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Qt and QML bindings for wlroots";
    homepage = "https://github.com/vioken/qwlroots";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
      asl20
    ];
    platforms = wlroots.meta.platforms;
    maintainers = with lib.maintainers; [ rewine ];
  };
})
