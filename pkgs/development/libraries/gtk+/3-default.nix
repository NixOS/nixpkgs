{ stdenv, fetchurl, pkgconfig
, expat, glib, cairo, pango, gdk_pixbuf, atk, at_spi2_atk, xlibs
, xineramaSupport ? true
, cupsSupport ? true, cups ? null
}:

assert xineramaSupport -> xlibs.libXinerama != null;
assert cupsSupport -> cups != null;

stdenv.mkDerivation rec {
  name = "gtk+-3.8.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/3.8/${name}.tar.xz";
    sha256 = "0bi5dip7l6d08c6v9c9aipwsi8hq38xjljqv86nmnpvbkpc4a4yv";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = with xlibs; [
    expat glib cairo pango gdk_pixbuf atk at_spi2_atk
    libXrandr libXrender libXcomposite libXi libXcursor
  ] ++ stdenv.lib.optional xineramaSupport libXinerama
    ++ stdenv.lib.optionals cupsSupport [ cups ];

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

    maintainers = with stdenv.lib.maintainers; [urkud raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
