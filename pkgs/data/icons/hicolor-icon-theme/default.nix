{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "hicolor-icon-theme";
  version = "0.18";

  src = fetchurl {
    url = "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-${version}.tar.xz";
    sha256 = "sha256-2w5QqAqjv2S7RcvKXPn3Xv2TSM8qxpC5B0NSOMPPgdc=";
  };

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Default fallback theme used by implementations of the icon theme specification";
    homepage = "https://icon-theme.freedesktop.org/releases/";
    platforms = platforms.unix;
    license = licenses.gpl2Only;
  };
}
