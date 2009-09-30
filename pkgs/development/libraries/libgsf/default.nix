{ fetchurl, stdenv, perl, perlXMLParser, pkgconfig, libxml2
, glib, gettext, intltool, bzip2
, gnomevfs, libbonobo, python }:


stdenv.mkDerivation rec {
  name = "libgsf-1.14.9";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/${name}.tar.bz2";
    sha256 = "1mkw60052sd6k9sq8ppz4yra0s3sdinngqi6bcmrj9977zk8yqfi";
  };

  buildInputs = [
    perl perlXMLParser pkgconfig libxml2 glib gettext bzip2
    gnomevfs libbonobo python intltool
  ];

  doCheck = true;

  meta = {
    homepage = http://www.gnome.org/projects/libgsf;
    license = "LGPLv2";
    description = "GNOME's Structured File Library";

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
