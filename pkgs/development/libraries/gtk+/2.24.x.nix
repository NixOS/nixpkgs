{ stdenv, fetchurl, pkgconfig, glib, atk, pango, libtiff, libjpeg
, libpng, cairo, perl, jasper, xlibs, gdk_pixbuf
, xineramaSupport ? true
, cupsSupport ? true, cups ? null
}:

assert xineramaSupport -> xlibs.libXinerama != null;
assert cupsSupport -> cups != null;

stdenv.mkDerivation rec {
  name = "gtk+-2.24.5";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.24/${name}.tar.bz2";
    sha256 = "f355f26003b1b42b97e584bdc475189a423fdd052088ee4bbd7aa0f989815cc8";
  };

  patches =
    [ # Fix broken icons such as the back/forward buttons in Firefox.
      # http://bugs.gentoo.org/339319
      ./old-icons.patch
    ];

  enableParallelBuilding = true;
  
  buildNativeInputs = [ perl ];
  buildInputs = [ pkgconfig jasper ];
  
  propagatedBuildInputs =
    [ xlibs.xlibs glib atk pango gdk_pixbuf /* libtiff libjpeg libpng */ cairo
      xlibs.libXrandr xlibs.libXrender xlibs.libXcomposite xlibs.libXi
    ]
    ++ stdenv.lib.optional xineramaSupport xlibs.libXinerama
    ++ stdenv.lib.optionals cupsSupport [ cups ];

  configureFlags = "--with-xinput=yes";

  postInstall = "rm -rf $out/share/gtk-doc";
  
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
