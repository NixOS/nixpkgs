args: with args;

stdenv.mkDerivation rec {
  name = "pango-1.24.1";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/1.24/${name}.tar.bz2";
    sha256 = "1cls9cbk6sx81101gh2pkiri8v14shqpvy37cydbh8scs4yk8370";
  };

  buildInputs = [pkgconfig] ++ (if stdenv.system == "i686-darwin" then [gettext] else []);

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
  };
}
