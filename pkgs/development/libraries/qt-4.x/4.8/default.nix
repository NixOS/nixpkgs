{ stdenv, fetchurl, substituteAll
, libXrender, libXinerama, libXcursor, libXmu , libXv, libXext
, libXfixes, libXrandr, libSM, freetype, fontconfig
, zlib, libjpeg, libpng, libmng, which, mesa, openssl, dbus, cups, pkgconfig
, libtiff, glib, icu
, mysql, postgresql, sqlite
, perl, coreutils, libXi
, buildMultimedia ? true, alsaLib, gstreamer, gst_plugins_base
, buildWebkit ? true
, flashplayerFix ? true, gdk_pixbuf
, gtkStyle ? false, libgnomeui, gtk, GConf, gnome_vfs
}:

let
  v = "4.8.1";
in

# TODO:
#  * move some plugins (e.g., SQL plugins) to dedicated derivations to avoid
#    false build-time dependencies

stdenv.mkDerivation rec {
  name = "qt-${v}";

  src = fetchurl {
    url = "ftp://ftp.qt.nokia.com/qt/source/qt-everywhere-opensource-src-${v}.tar.gz";
    sha256 = "1s3sv2p8q4bjy0h6r81gdnd64apdx8kwm5jc7rxavd21m8v1m1gg";
  };

  patches = [ ( substituteAll {
        src = ./dlopen-absolute-paths.diff;
        inherit cups icu libXfixes;
        glibc = stdenv.gcc.libc;
      })
    ] ++ stdenv.lib.optional gtkStyle (
      substituteAll {
        src = ./dlopen-gtkstyle.diff;
        # substituteAll ignores env vars starting with capital letter
        gconf = GConf; 
        inherit gnome_vfs libgnomeui gtk;
      }
    ) ++ stdenv.lib.optional flashplayerFix (
      substituteAll {
        src = ./dlopen-webkit-nsplugin.diff;
        inherit gtk gdk_pixbuf;
      }
    );

  preConfigure =
    ''
      export LD_LIBRARY_PATH="`pwd`/lib:$LD_LIBRARY_PATH"
      configureFlags+="
        -docdir $out/share/doc/${name}
        -plugindir $out/lib/qt4/plugins
        -importdir $out/lib/qt4/imports
        -examplesdir $out/share/doc/${name}/examples
        -demosdir $out/share/doc/${name}/demos
        -datadir $out/share/${name}
        -translationdir $out/share/${name}/translations
      "
    '';

  configureFlags =
    ''
      -v -no-separate-debug-info -release -no-fast -confirm-license -opensource

      -opengl -xrender -xrandr -xinerama -xcursor -xinput -xfixes -fontconfig
      -qdbus -${if cups == null then "no-" else ""}cups -glib -dbus-linked -openssl-linked

      ${if mysql != null then "-plugin" else "-no"}-sql-mysql -system-sqlite

      -exceptions -xmlpatterns

      -make libs -make tools -make translations
      -nomake demos -nomake examples -nomake docs

      -no-phonon ${if buildWebkit then "" else "-no"}-webkit ${if buildMultimedia then "" else "-no"}-multimedia -audio-backend
    '';

  propagatedBuildInputs =
    [ libXrender libXrandr libXinerama libXcursor libXext libXfixes
      libXv libXi libSM mesa
    ] ++ (stdenv.lib.optional (buildWebkit || buildMultimedia) alsaLib)
    ++ [ zlib libpng openssl dbus.libs freetype fontconfig glib ]
    ++ (stdenv.lib.optionals (buildWebkit || buildMultimedia)
        [ gstreamer gst_plugins_base ]);

  # The following libraries are only used in plugins
  buildInputs = [ cups # Qt dlopen's libcups instead of linking to it
    mysql postgresql sqlite libjpeg libmng libtiff icu ]
    ++ stdenv.lib.optionals gtkStyle [ gtk gdk_pixbuf ];

  buildNativeInputs = [ perl pkgconfig which ];

  prefixKey = "-prefix ";

  prePatch = ''
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i mkspecs/*/*.conf
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://qt.nokia.com/products;
    description = "A cross-platform application framework for C++";
    license = "GPL/LGPL";
    maintainers = with maintainers; [ urkud sander ];
    platforms = platforms.linux;
  };
}
