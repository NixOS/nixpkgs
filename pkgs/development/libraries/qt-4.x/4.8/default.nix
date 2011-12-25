{ stdenv, fetchurl, substituteAll
, alsaLib, gstreamer, gstPluginsBase
, libXrender, libXinerama, libXcursor, libXmu , libXv, libXext
, libXfixes, libXrandr, libSM, freetype, fontconfig
, zlib, libjpeg, libpng, libmng, which, mesa, openssl, dbus, cups, pkgconfig
, libtiff, glib, icu
, mysql, postgresql, sqlite
, perl, coreutils, libXi
, flashplayerFix ? true, gdk_pixbuf
, gtkStyle ? false, libgnomeui, gtk, GConf, gnome_vfs
}:

let
  v = "4.8.0";
in

# TODO:
#  * move some plugins (e.g., SQL plugins) to dedicated derivations to avoid
#    false build-time dependencies

stdenv.mkDerivation rec {
  name = "qt-${v}";

  src = fetchurl {
    url = "ftp://ftp.qt.nokia.com/qt/source/qt-everywhere-opensource-src-${v}.tar.gz";
    sha256 = "0vhb6bysjqz8l0dygg2yypm4frsggma2g9877rdgf5ay917bg4lk";
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
      -qdbus -cups -glib -dbus-linked -openssl-linked

      -plugin-sql-mysql -system-sqlite

      -exceptions -xmlpatterns

      -make libs -make tools -make translations
      -nomake demos -nomake examples -nomake docs

      -no-phonon -webkit -multimedia -audio-backend
    '';

  propagatedBuildInputs =
    [ libXrender libXrandr libXinerama libXcursor libXext libXfixes
      libXv libXi libSM mesa
      alsaLib zlib libpng openssl dbus.libs freetype fontconfig glib
      gstreamer gstPluginsBase
    ];

  # The following libraries are only used in plugins
  buildInputs = [ cups # Qt dlopen's libcups instead of linking to it
    mysql postgresql sqlite libjpeg libmng libtiff icu ];

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
