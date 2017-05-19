{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hicolor-icon-theme-0.15";

  src = fetchurl {
    url = "http://icon-theme.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1k1kf2c5zbqh31nglc3nxs9j6wr083k9kjyql8p22ccc671mmi4w";
  };

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Default fallback theme used by implementations of the icon theme specification";
    homepage = http://icon-theme.freedesktop.org/releases/;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
