{ stdenv, fetchurl, zlib, pkgconfig, glib, libgsf, libxml2, librevenge }:

stdenv.mkDerivation rec {
  name = "libwpd-0.10.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/libwpd/${name}.tar.xz";
    sha256 = "0b6krzr6kxzm89g6bapn805kdayq70hn16n5b5wfs2lwrf0ag2wx";
  };
  
  buildInputs = [ glib libgsf libxml2 zlib librevenge ];

  nativeBuildInputs = [ pkgconfig ];
}
