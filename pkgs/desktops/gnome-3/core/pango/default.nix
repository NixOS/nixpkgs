{ stdenv, fetchurl, pkgconfig, gettext, x11, glib, cairo, libpng }:

stdenv.mkDerivation rec {

  versionMajor = "1.30";
  versionMinor = "1";
  moduleName   = "pango";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1ghc49b5ahv2is7hlq6is5jbpkvhx5kkays6spf2s9rw2hg0d31s";
  };

  buildInputs = stdenv.lib.optional stdenv.isDarwin gettext;

  buildNativeInputs = [ pkgconfig ];

  propagatedBuildInputs = [ x11 glib cairo libpng ];

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
