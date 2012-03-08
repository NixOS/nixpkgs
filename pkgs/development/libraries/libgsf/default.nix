{ fetchurl, stdenv, perl, perlXMLParser, pkgconfig, libxml2
, glib, gettext, intltool, bzip2, gdk_pixbuf
, gnome_vfs, libbonobo, python }:


stdenv.mkDerivation rec {
  name = "libgsf-1.14.22";

  src = fetchurl {
    url = mirror://gnome/sources/libgsf/1.14/libgsf-1.14.22.tar.xz;
    sha256 = "0gvq1gbbcl078s3kgdc508jp7p3a3ps34fj4pf8vsamprbikpwm5";
  };

  buildNativeInputs = [ intltool pkgconfig ];
  buildInputs =
    [ perl perlXMLParser gettext bzip2 gnome_vfs python gdk_pixbuf ];

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
