{ stdenv, fetchurl, pkgconfig, gettext, x11, glib, cairo, libpng }:

stdenv.mkDerivation rec {
  name = "pango-1.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/1.26/${name}.tar.bz2";
    sha256 = "021ygk3l9bk00gsvxk02flxsk68w0wl99dx221fmb547bng8g19v";
  };

  buildInputs = [pkgconfig] ++ stdenv.lib.optional (stdenv.system == "i686-darwin") gettext;

  propagatedBuildInputs = [x11 glib cairo libpng];

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

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
