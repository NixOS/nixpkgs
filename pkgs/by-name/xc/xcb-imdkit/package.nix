{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  uthash,
  xcbutil,
  xcbutilkeysyms,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-imdkit";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "xcb-imdkit";
    rev = finalAttrs.version;
    hash = "sha256-QfuetGPY6u4OhFiE5/CoVEpdODWnd1PHWBtM3ymsZ98=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    xorgproto
    uthash
  ];

  buildInputs = [
    xcbutil
    xcbutilkeysyms
  ];

  meta = {
    description = "Input method development support for xcb";
    homepage = "https://github.com/fcitx/xcb-imdkit";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
  };
})
