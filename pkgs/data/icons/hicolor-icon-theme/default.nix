{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hicolor-icon-theme-0.13";

  src = fetchurl {
    url = "http://icon-theme.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "01ilkizzal3wq2naaj84rqmd850aari1ahiw9vfis3a82n4h72x3";
  };

  meta = {
    description = "Default fallback theme used by implementations of the icon theme specification";
    homepage = http://icon-theme.freedesktop.org/releases/;
    platforms = stdenv.lib.platforms.linux;
  };
}
