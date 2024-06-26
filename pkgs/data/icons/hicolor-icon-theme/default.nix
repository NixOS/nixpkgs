{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hicolor-icon-theme";
  version = "0.17";

  src = fetchurl {
    url = "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-${version}.tar.xz";
    sha256 = "1n59i3al3zx6p90ff0l43gzpzmlqnzm6hf5cryxqrlbi48sq8x1i";
  };

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Default fallback theme used by implementations of the icon theme specification";
    homepage = "https://icon-theme.freedesktop.org/releases/";
    platforms = platforms.unix;
    license = licenses.gpl2Only;
  };
}
