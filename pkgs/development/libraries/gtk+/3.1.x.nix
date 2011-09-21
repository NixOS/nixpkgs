{ stdenv, fetchurl_gnome, pkgconfig, glib, atk, pango, cairo, perl, xlibs
, gdk_pixbuf, xz
, xineramaSupport ? true
, cupsSupport ? true, cups ? null
}:

assert xineramaSupport -> xlibs.libXinerama != null;
assert cupsSupport -> cups != null;

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "gtk+";
    major = "3"; minor = "1"; patchlevel = "16"; extension = "xz";
    sha256 = "15arbf75qpchr9wrawb3zkn52rzf5wm2qv4dq10zfzlflimrq2rg";
  };

  enableParallelBuilding = true;

  buildNativeInputs = [ perl pkgconfig xz ];

  propagatedBuildInputs =
    [ xlibs.xlibs glib atk pango gdk_pixbuf cairo
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

    maintainers = with stdenv.lib.maintainers; [urkud raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
