{ stdenv, fetchurl, substituteAll
, libXrender, libXinerama, libXcursor, libXmu , libXv, libXext
, libXfixes, libXrandr, libSM, freetype, fontconfig
, zlib, libjpeg, libpng, libmng, which, mesa, openssl, dbus, cups, pkgconfig
, libtiff, glib, icu
, mysql, postgresql, sqlite
, perl, coreutils, libXi
, buildMultimedia ? true, alsaLib, gstreamer, gst_plugins_base
, buildWebkit ? true
, flashplayerFix ? false, gdk_pixbuf
, gtkStyle ? false, libgnomeui, gtk, GConf, gnome_vfs
, developerBuild ? false
}:

with stdenv.lib;

let v = "4.8.4"; in

# TODO:
#  * move some plugins (e.g., SQL plugins) to dedicated derivations to avoid
#    false build-time dependencies

stdenv.mkDerivation rec {
  name = "qt-${v}";

  src = fetchurl {
    url = "http://releases.qt-project.org/qt4/source/qt-everywhere-opensource-src-${v}.tar.gz";
    sha256 = "0w1j16q6glniv4hppdgcvw52w72gb2jab35ylkw0qjn5lj5y7c1k";
  };

  patches =
    [ ./glib-2.32.patch
      (substituteAll {
        src = ./dlopen-absolute-paths.diff;
        inherit cups icu libXfixes;
        glibc = stdenv.gcc.libc;
      })
    ] ++ stdenv.lib.optional gtkStyle (substituteAll {
        src = ./dlopen-gtkstyle.diff;
        # substituteAll ignores env vars starting with capital letter
        gconf = GConf;
        inherit gnome_vfs libgnomeui gtk;
      })
    ++ stdenv.lib.optional flashplayerFix (substituteAll {
        src = ./dlopen-webkit-nsplugin.diff;
        inherit gtk gdk_pixbuf;
      });

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
      ${if developerBuild then "-developer-build" else ""}
    '';

  propagatedBuildInputs =
    [ libXrender libXrandr libXinerama libXcursor libXext libXfixes
      libXv libXi libSM
    ]
    ++ optional (stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms) mesa
    ++ optional (buildWebkit || buildMultimedia) alsaLib
    ++ [ zlib libpng openssl dbus.libs freetype fontconfig glib ]
    ++ optionals (buildWebkit || buildMultimedia) [ gstreamer gst_plugins_base ];

  # The following libraries are only used in plugins
  buildInputs =
    [ cups # Qt dlopen's libcups instead of linking to it
      mysql postgresql sqlite libjpeg libmng libtiff icu ]
    ++ optionals gtkStyle [ gtk gdk_pixbuf ];

  buildNativeInputs = [ perl pkgconfig which ];

  prefixKey = "-prefix ";

  prePatch = ''
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i mkspecs/*/*.conf
  '';

  enableParallelBuilding = true;

  crossAttrs = let
    isMingw = stdenv.cross.config == "i686-pc-mingw32" ||
      stdenv.cross.config == "x86_64-w64-mingw32";
  in {
    # I've not tried any case other than i686-pc-mingw32.
    # -nomake tools:   it fails linking some asian language symbols
    # -no-svg: it fails to build on mingw64
    configureFlags = ''
      -static -release -confirm-license -opensource
      -no-opengl -no-phonon
      -no-svg
      -make qmake -make libs -nomake tools
      -nomake demos -nomake examples -nomake docs
    '' + optionalString isMingw " -xplatform win32-g++-4.6";
    patches = [];
    preConfigure = ''
      sed -i -e 's/ g++/ ${stdenv.cross.config}-g++/' \
        -e 's/ gcc/ ${stdenv.cross.config}-gcc/' \
        -e 's/ ar/ ${stdenv.cross.config}-ar/' \
        -e 's/ strip/ ${stdenv.cross.config}-strip/' \
        -e 's/ windres/ ${stdenv.cross.config}-windres/' \
        mkspecs/win32-g++/qmake.conf
    '';

    # I don't know why it does not install qmake
    postInstall = ''
      cp bin/qmake* $out/bin
    '';
    dontSetConfigureCross = true;
    dontStrip = true;
  } // optionalAttrs isMingw {
    propagatedBuildInputs = [ ];
  };

  meta = {
    homepage = http://qt-project.org/;
    description = "A cross-platform application framework for C++";
    license = "GPL/LGPL";
    maintainers = with maintainers; [ urkud sander ];
    platforms = platforms.linux;
  };
}
