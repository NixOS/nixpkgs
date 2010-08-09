{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hicolor-icon-theme-0.12";

  src = fetchurl {
    url = "http://icon-theme.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0wzc7g4ldb2l8zc0x2785ck808c03i857jji942ikakyc68adp4y";
  };

  meta = {
    description = "Default fallback theme used by implementations of the icon theme specification";
    homepage = http://icon-theme.freedesktop.org/releases/;
  };
}
