{ stdenv, fetchurl, pkgconfig, gettext, perl
, expat, glib, cairo, pango, gdk_pixbuf, atk, at_spi2_atk, gobjectIntrospection
, xlibs, x11, wayland, libxkbcommon
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? stdenv.isLinux, cups ? null
}:

assert xineramaSupport -> xlibs.libXinerama != null;
assert cupsSupport -> cups != null;

let
  ver_maj = "3.10";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "gtk+-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/${ver_maj}/${name}.tar.xz";
    sha256 = "1zjkbjvp6ay08107r6zfsrp39x7qfadbd86p3hs5v4ydc2rzwnb5";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig gettext gobjectIntrospection perl ];

  buildInputs = [ wayland libxkbcommon ];
  propagatedBuildInputs = with xlibs; with stdenv.lib;
    [ expat glib cairo pango gdk_pixbuf atk at_spi2_atk ]
    ++ optionals stdenv.isLinux [ libXrandr libXrender libXcomposite libXi libXcursor ]
    ++ optional stdenv.isDarwin x11
    ++ stdenv.lib.optional xineramaSupport libXinerama
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

    maintainers = with stdenv.lib.maintainers; [ urkud raskin vcunat];
    platforms = stdenv.lib.platforms.all;
  };
}
