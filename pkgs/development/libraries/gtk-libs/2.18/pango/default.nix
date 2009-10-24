args: with args;

stdenv.mkDerivation rec {
  name = "pango-1.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/1.26/${name}.tar.bz2";
    sha256 = "1hx6v6w3xk9wfcrb26gg7rrfl6m6ykxk2bqm67aqdzql4vysxgz1";
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
