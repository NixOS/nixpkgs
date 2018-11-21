{ stdenv, fetchurl, pkgconfig, glib, libgsf, libxml2, bzip2 }:

stdenv.mkDerivation rec {
  name = "libwpd-0.8.14";

  src = fetchurl {
    url = "mirror://sourceforge/libwpd/${name}.tar.gz";
    sha256 = "1syli6i5ma10cwzpa61a18pyjmianjwsf6pvmvzsh5md6yk4yx01";
  };

  patches = [ ./gcc-0.8.patch ];

  buildInputs = [ glib libgsf libxml2 ];

  nativeBuildInputs = [ pkgconfig bzip2 ];

  meta = with stdenv.lib; {
    description = "Library for importing WordPerfect documents";
    homepage = http://libwpd.sourceforge.net;
    license = with licenses; [ lgpl21 mpl20 ];
    platforms = platforms.unix;
  };
}
