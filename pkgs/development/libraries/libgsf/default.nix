{ fetchurl, stdenv, perl, perlXMLParser, pkgconfig, libxml2
, glib, gettext, intltool, bzip2
, gnome_vfs, libbonobo, python }:


stdenv.mkDerivation rec {
  name = "libgsf-1.14.16";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/${name}.tar.bz2";
    sha256 = "0249n2hgrcnzphinaxng0cpn7afchg84l4ka4wka9kyv3g58zz8i";
  };

  buildInputs =
    [ perl perlXMLParser pkgconfig gettext bzip2 gnome_vfs python intltool ];

  propagatedBuildInputs = [ glib libxml2 libbonobo ];

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
