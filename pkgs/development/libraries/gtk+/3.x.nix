{ stdenv, fetchurl, pkgconfig, gettext
, expat, glib, cairo, pango, gdk_pixbuf, atk, at_spi2_atk, xlibs, x11, gobjectIntrospection
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? stdenv.isLinux, cups ? null
}:

assert xineramaSupport -> xlibs.libXinerama != null;
assert cupsSupport -> cups != null;

let
  ver_maj = "3.8";
  ver_min = "8";
in
stdenv.mkDerivation rec {
  name = "gtk+-3.8.4";
  name = "gtk+-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/${ver_maj}/${name}.tar.xz";
    sha256 = "19hrvvvj8l3hv4cbfcx4xn005v8x8kg1ghkgs4cyngqydsq9lafr";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig gettext gobjectIntrospection ];
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
