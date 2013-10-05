{ stdenv, fetchurl, pkgconfig, gettext, glib, atk, pango, cairo, perl, xlibs
, gdk_pixbuf, libintlOrEmpty, x11
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? true, cups ? null
}:

assert xineramaSupport -> xlibs.libXinerama != null;
assert cupsSupport -> cups != null;

stdenv.mkDerivation rec {
  name = "gtk+-2.24.22";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.24/${name}.tar.xz";
    sha256 = "0zxf810znlk80j230rbr0xscx3gm71jmf2bdiamg76rqzglvc55i";
  };

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (libintlOrEmpty != []) "-lintl";

  nativeBuildInputs = [ perl pkgconfig gettext ];

  propagatedBuildInputs = with xlibs; with stdenv.lib;
    [ glib cairo pango gdk_pixbuf atk ]
    ++ optionals stdenv.isLinux
      [ libXrandr libXrender libXcomposite libXi libXcursor ]
    ++ optional stdenv.isDarwin x11
    ++ libintlOrEmpty
    ++ optional xineramaSupport libXinerama
    ++ optionals cupsSupport [ cups ];

  configureFlags = "--with-xinput=yes";

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    description = "A multi-platform toolkit for creating graphical user interfaces";
    homepage    = http://www.gtk.org/;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 raskin ];
    platforms   = platforms.all;

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
  };
}
