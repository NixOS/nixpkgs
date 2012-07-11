{ fetchurl, stdenv, perl, perlXMLParser, pkgconfig, libxml2
, gettext, intltool, bzip2, glib, python
, gnomeSupport ? true,  gdk_pixbuf ? null
, gnome_vfs ? null, libbonobo ? null }:

assert gnomeSupport -> gdk_pixbuf != null && gnome_vfs != null && libbonobo != null
  && glib != null;

stdenv.mkDerivation rec {
  name = "libgsf-1.14.22";

  src = fetchurl {
    url = mirror://gnome/sources/libgsf/1.14/libgsf-1.14.22.tar.xz;
    sha256 = "0gvq1gbbcl078s3kgdc508jp7p3a3ps34fj4pf8vsamprbikpwm5";
  };

  buildNativeInputs = [ intltool pkgconfig ];
  buildInputs =
    [ perl perlXMLParser gettext bzip2 python ]
    ++ stdenv.lib.optionals gnomeSupport [ gnome_vfs gdk_pixbuf ];

  propagatedBuildInputs = [ libxml2 glib ]
    ++ stdenv.lib.optionals gnomeSupport [ libbonobo ];

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
