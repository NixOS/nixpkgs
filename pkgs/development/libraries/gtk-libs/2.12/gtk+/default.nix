args: with args;

stdenv.mkDerivation {
  name = "gtk+-2.12.8";
  
  src = fetchurl {
    url = mirror://gnome/sources/gtk+/2.12/gtk+-2.12.8.tar.bz2;
    sha256 = "1vzh73lxpp4m85zxhwjkigc28qnfxfjppxmywvwqj86ablnm8bzz";
  };
  
  buildInputs = [pkgconfig perl];
  
  propagatedBuildInputs = [
    x11 glib atk pango libtiff libjpeg libpng cairo libXrandr
  ] ++ stdenv.lib.optional xineramaSupport [libXinerama];
    
  passthru = { inherit libtiff libjpeg libpng; };

  meta = {
    description = "A multi-platform toolkit for creating graphical user interfaces";
    homepage = http://www.gtk.org/;
  };
}
