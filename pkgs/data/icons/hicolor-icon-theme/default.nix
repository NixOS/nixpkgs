{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hicolor-icon-theme-0.14";

  src = fetchurl {
    url = "http://icon-theme.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1k9fj0lb9b44inb5q5m04910x5nfkzrxl3ys9ckihqrixzk0dvbv";
  };

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Default fallback theme used by implementations of the icon theme specification";
    homepage = http://icon-theme.freedesktop.org/releases/;
    platforms = stdenv.lib.platforms.linux;
  };
}
