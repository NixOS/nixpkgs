args: with args;

stdenv.mkDerivation {
  name = "gtk+-2.12.10";
  
  src = fetchurl {
    url = mirror://gnome/sources/gtk+/2.12/gtk+-2.12.10.tar.bz2;
    md5 = "5fcbdd2254eedb6b9ae828afc01d9eaa";
  };
  
  buildInputs = [pkgconfig perl];
  
  propagatedBuildInputs = [
    x11 glib atk pango libtiff libjpeg libpng cairo libXrandr
  ] ++ stdenv.lib.optional xineramaSupport libXinerama;
    
  passthru = { inherit libtiff libjpeg libpng; };

  meta = {
    description = "A multi-platform toolkit for creating graphical user interfaces";
    homepage = http://www.gtk.org/;
  };
}
