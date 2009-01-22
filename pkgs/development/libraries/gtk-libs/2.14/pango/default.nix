args: with args;

stdenv.mkDerivation rec {
  name = "pango-1.20.5";
  
  src = fetchurl {
    url = "mirror://gnome/sources/pango/1.20/${name}.tar.bz2";
    sha256 = "1cpsm32prbxwq7hhfpc2f6a1hhz61nnllpy9sqr4r8hqmm5skxc6";
  };
  
  buildInputs = [pkgconfig];
  
  propagatedBuildInputs = [x11 glib cairo libpng];

  # The configure script doesn't seem to pick up the Cairo cflags.
  preConfigure = ''
    CAIRO_CFLAGS=$(pkg-config --cflags cairo --debug)
  '';

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
