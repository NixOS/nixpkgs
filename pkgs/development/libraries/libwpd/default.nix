{ lib, stdenv, fetchurl, zlib, pkg-config, glib, libgsf, libxml2, librevenge }:

stdenv.mkDerivation rec {
  pname = "libwpd";
  version = "0.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/libwpd/libwpd-${version}.tar.xz";
    sha256 = "0b6krzr6kxzm89g6bapn805kdayq70hn16n5b5wfs2lwrf0ag2wx";
  };

  buildInputs = [ glib libgsf libxml2 zlib librevenge ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "A library for importing and exporting WordPerfect documents";
    homepage = "https://libwpd.sourceforge.net/";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
