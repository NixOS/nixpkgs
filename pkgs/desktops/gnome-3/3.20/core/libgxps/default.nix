{ stdenv, fetchurl, pkgconfig, glib, cairo, libarchive, freetype, libjpeg, libtiff
, openssl, bzip2, acl, attr, libxml2
}:

stdenv.mkDerivation rec {
  name = "libgxps-0.2.2";

  src = fetchurl {
    url = "http://ftp.acc.umu.se/pub/GNOME/core/3.10/3.10.2/sources/${name}.tar.xz";
    sha256 = "1gi0b0x0354jyqc48vspk2hg2q1403cf2p9ibj847nzhkdrh9l9r";
  };

  buildInputs = [ pkgconfig glib cairo freetype libjpeg libtiff acl openssl bzip2 attr libxml2 ];
  propagatedBuildInputs = [ libarchive ];

  configureFlags = "--without-liblcms2";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
