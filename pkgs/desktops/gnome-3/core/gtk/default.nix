{ stdenv, fetchurl, pkgconfig, gnome3, cairo, perl, xlibs
, xz
, xineramaSupport ? true
, cupsSupport ? true, cups ? null
}:

assert xineramaSupport -> xlibs.libXinerama != null;
assert cupsSupport -> cups != null;

stdenv.mkDerivation rec {
  versionMajor = "3.5";
  versionMinor = "6";
  moduleName   = "gtk+";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1088d5n3yzzjxm13c29sys83m28dmd5b95i1wxc6459vq2d4l14g";
  };

  enableParallelBuilding = true;

  configureFlags =
    [ "--without-atk-bridge"
      "--enable-gtk-doc-html=no"
      "--enable-x11-backend"
      "--disable-tests"
    ];

  buildNativeInputs = [ perl pkgconfig ];

  propagatedBuildInputs =
    [ xlibs.xlibs gnome3.glib gnome3.atk gnome3.gdk_pixbuf gnome3.pango cairo
      xlibs.libXrandr xlibs.libXrender xlibs.libXcomposite xlibs.libXi
    ]
    ++ stdenv.lib.optional xineramaSupport xlibs.libXinerama
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

    maintainers = with stdenv.lib.maintainers; [ urkud raskin antono ];
    platforms = stdenv.lib.platforms.linux;
  };
}
