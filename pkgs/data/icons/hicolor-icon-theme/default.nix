{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hicolor-icon-theme-0.17";

  src = fetchurl {
    url = "http://icon-theme.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1n59i3al3zx6p90ff0l43gzpzmlqnzm6hf5cryxqrlbi48sq8x1i";
  };

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "Default fallback theme used by implementations of the icon theme specification";
    homepage = https://icon-theme.freedesktop.org/releases/;
    platforms = platforms.unix;
  };
}
