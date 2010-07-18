{ stdenv, fetchurl, pkgconfig, glib, atk, pango, libtiff, libjpeg
, libpng, cairo, perl, jasper, xlibs
, xineramaSupport ? true
, cupsSupport ? true, cups ? null
}:

assert xineramaSupport -> xlibs.libXinerama != null;
assert cupsSupport -> cups != null;

stdenv.mkDerivation rec {
  name = "gtk+-2.18.9";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.18/${name}.tar.bz2";
    sha256 = "5dcd8c406acbb8779c0b081a089fa87dfd7ab4d7d4c6075db478997ce96aa9b4";
  };
  
  buildNativeInputs = [ perl ];
  buildInputs = [ pkgconfig jasper ];
  
  propagatedBuildInputs =
    [ xlibs.xlibs glib atk pango libtiff libjpeg libpng cairo xlibs.libXrandr ]
    ++ stdenv.lib.optional xineramaSupport xlibs.libXinerama
    ++ stdenv.lib.optionals cupsSupport [ cups ];

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
