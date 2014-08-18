{ stdenv, fetchurl, pkgconfig, gettext, x11, glib, cairo, libpng, harfbuzz, fontconfig
, libintlOrEmpty, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "pango-1.32.5"; #.6 and higher need fontconfig-2.11.* which is troublesome

  src = fetchurl {
    url = "mirror://gnome/sources/pango/1.32/${name}.tar.xz";
    sha256 = "08aqis6j8nd1lb4f2h4h9d9kjvp54iwf8zvqzss0qn4v7nfcjyvx";
  };

  buildInputs = with stdenv.lib;
    optional (!stdenv.isDarwin) gobjectIntrospection # build problems of itself and flex
    ++ optionals stdenv.isDarwin [ gettext fontconfig ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ x11 glib cairo libpng harfbuzz ] ++ libintlOrEmpty;

  enableParallelBuilding = true;

  # jww (2014-05-05): The tests currently fail on Darwin:
  #
  # ERROR:testiter.c:139:iter_char_test: assertion failed: (extents.width == x1 - x0)
  # .../bin/sh: line 5: 14823 Abort trap: 6 srcdir=. PANGO_RC_FILE=./pangorc ${dir}$tst
  # FAIL: testiter
  doCheck = !stdenv.isDarwin;
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
    hydraPlatforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
