{ lib, stdenvNoCC, fetchurl, meson, pkg-config, ninja }:

stdenvNoCC.mkDerivation rec {
  pname = "hicolor-icon-theme";
  version = "0.18";

  src = fetchurl {
    url = "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-${version}.tar.xz";
    hash = "sha256-2w5QqAqjv2S7RcvKXPn3Xv2TSM8qxpC5B0NSOMPPgdc=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Default fallback theme used by implementations of the icon theme specification";
    homepage = "https://icon-theme.freedesktop.org/releases/";
    platforms = platforms.unix;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jopejoe1 ];
  };
}
