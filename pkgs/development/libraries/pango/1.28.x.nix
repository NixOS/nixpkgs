{ stdenv, fetchurl, pkgconfig, gettext, x11, glib, cairo, libpng }:

stdenv.mkDerivation rec {
  name = "pango-1.28.3";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/1.28/${name}.tar.bz2";
    sha256 = "0ch640zmf159gr9qp3i4a5mh1ib2s9h3660g4w0bpiqc8g4qn9sy";
  };

  buildInputs = [ pkgconfig ] ++ stdenv.lib.optional stdenv.isDarwin gettext;

  propagatedBuildInputs = [ x11 glib cairo libpng ];

  meta = {
    description = "A library for laying out and rendering of text, with an emphasis on internationalization";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';

    homepage = http://www.pango.org/;
    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.all;
  };
}
