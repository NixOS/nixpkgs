args: with args;

stdenv.mkDerivation rec {
  name = "gtk+-2.18.0";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.18/${name}.tar.bz2";
    sha256 = "0hfjib98m47nrmv31h6k82fz35hzahykhifdsi5afy5yglrfkz05";
  };
  
  buildInputs = [ pkgconfig perl jasper ];
  
  propagatedBuildInputs = [
    x11 glib atk pango libtiff libjpeg libpng cairo libXrandr
  ] ++ stdenv.lib.optional xineramaSupport libXinerama;
    
  passthru = { inherit libtiff libjpeg libpng; };

  meta = {
    description = "A multi-platform toolkit for creating graphical user interfaces";

    longDescription = ''
      GTK+ is a highly usable, feature rich toolkit for creating
      graphical user interfaces which boasts cross platform
      compatibility and an easy to use API.  GTK+ it is written in C,
      but has bindings to many other popular programming languages
      such as C++, Python and C# among others.  GTK+ is licensed
      under the GNU LGPL 2.1 allowing development of both free and
      proprietary software with GTK+ without any license fees or
      royalties.
    '';

    homepage = http://www.gtk.org/;

    license = "LGPLv2+";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
