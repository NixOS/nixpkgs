{ stdenv, fetchurl, pkgconfig, gettext, x11, glib, cairo, libpng }:

stdenv.mkDerivation rec {
  name = "pango-1.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/1.30/${name}.tar.xz";
    sha256 = "7c6d2ab024affaed0e942f9279b818235f9c6a36d9fc50688f48d387f4102dff";
  };

  buildInputs = stdenv.lib.optional stdenv.isDarwin gettext;

  buildNativeInputs = [ pkgconfig ];

  propagatedBuildInputs = [ x11 glib cairo libpng ];

  enableParallelBuilding = true;

  postInstall = "rm -rf $out/share/gtk-doc";

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

    maintainers = with stdenv.lib.maintainers; [ raskin urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
