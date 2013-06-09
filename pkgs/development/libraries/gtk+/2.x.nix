{ stdenv, fetchurl, pkgconfig, glib, atk, pango, cairo, perl, xlibs
, gdk_pixbuf, xz
, xineramaSupport ? true
, cupsSupport ? true, cups ? null
}:

assert xineramaSupport -> xlibs.libXinerama != null;
assert cupsSupport -> cups != null;

stdenv.mkDerivation rec {
  name = "gtk+-2.24.18";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.24/${name}.tar.xz";
    sha256 = "1193frzg0qrwa885w77kd055zfpbdjwby88xn2skpx9g4w0k35kc";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ perl pkgconfig ];

  propagatedBuildInputs = with xlibs;
    [ glib cairo pango gdk_pixbuf atk
      libXrandr libXrender libXcomposite libXi libXcursor
    ]
    ++ stdenv.lib.optional xineramaSupport libXinerama
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
