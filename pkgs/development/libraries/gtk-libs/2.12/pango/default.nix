args: with args;

stdenv.mkDerivation {
  name = "pango-1.18.4";
  
  src = fetchurl {
    url = mirror://gnome/sources/pango/1.18/pango-1.18.4.tar.bz2;
    sha256 = "1pggwyvklj5pbfwab0dki8nqhph90nq8j4g2rl8d87xanwpcilvg";
  };
  
  buildInputs = [pkgconfig];
  
  propagatedBuildInputs = [x11 glib cairo libpng];

  # The configure script doesn't seem to pick up the Cairo cflags.
  preConfigure = ''
    CAIRO_CFLAGS=$(pkg-config --cflags cairo --debug)
  '';

  meta = {
    description = "A library for laying out and rendering of text, with an emphasis on internationalization";
    homepage = http://www.pango.org/;
  };
}
