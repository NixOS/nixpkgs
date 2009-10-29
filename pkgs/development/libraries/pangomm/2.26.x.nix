{ stdenv, fetchurl, pkgconfig, pango, glibmm, cairomm, libpng }:

stdenv.mkDerivation rec {
  name = "pangomm-2.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/pangomm/2.26/${name}.tar.bz2";
    sha256 = "0ph93cjbzmb36k6a9cjd1pcch0ba4bzq1jnf69f1xj0j5kjfn9mz";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pango glibmm cairomm libpng ];

  meta = {
    description = "C++ interface to the Pango text rendering library";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';

    homepage = http://www.pango.org/;
    license = "LGPLv2+";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
