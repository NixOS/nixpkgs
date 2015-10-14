{ stdenv, fetchurl, substituteAll, makeWrapper
, srcs

, xlibs, libX11, libxcb, libXcursor, libXext, libXrender, libXi
, xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilwm, libxkbcommon
, fontconfig, freetype, openssl, dbus, glib, udev, libxml2, libxslt, pcre
, zlib, libjpeg, libpng, libtiff, sqlite, icu

, coreutils, bison, flex, gdb, gperf, lndir, ruby
, python, perl, pkgconfig

# optional dependencies
, cups ? null
, mysql ? null, postgresql ? null

# options
, mesaSupported, mesa, mesa_glu
, buildDocs ? false
, buildExamples ? false
, buildTests ? false
, developerBuild ? false
, gtkStyle ? false, libgnomeui, GConf, gnome_vfs, gtk
, decryptSslTraffic ? false
}:

with stdenv.lib;

let
  inherit (srcs.qt5) version;
  system-x86_64 = elem stdenv.system platforms.x86_64;
in

stdenv.mkDerivation {

  name = "qtbase-${version}";
  inherit version;

  srcs = with srcs; [ qt5.src qtbase.src ];

  sourceRoot = "qt-everywhere-opensource-src-${version}";

  postUnpack = ''
    mv qtbase-opensource-src-${version} ./qt-everywhere-opensource-src-${version}/qtbase
  '';

  prePatch = ''
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace qtbase/configure --replace /bin/pwd pwd
    substituteInPlace qtbase/src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
    substituteInPlace qtbase/src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp \
        --replace /usr/share/X11/locale ${libX11.out}/share/X11/locale \
        --replace /usr/lib/X11/locale ${libX11.out}/share/X11/locale
    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i qtbase/mkspecs/*/*.conf
  '';

  patches =
    let dlopen-gtkstyle = substituteAll {
          src = ./0001-dlopen-gtkstyle.patch;
          # substituteAll ignores env vars starting with capital letter
          gconf = GConf.out;
          gtk = gtk.out;
          libgnomeui = libgnomeui.out;
          gnome_vfs = gnome_vfs.out;
        };
        dlopen-resolv = substituteAll {
          src = ./0002-dlopen-resolv.patch;
          glibc = stdenv.cc.libc.out;
        };
        dlopen-gl = substituteAll {
          src = ./0003-dlopen-gl.patch;
          openglDriver = if mesaSupported then mesa.driverLink else "/no-such-path";
        };
        tzdir = ./0004-tzdir.patch;
        dlopen-libXcursor = substituteAll {
          src = ./0005-dlopen-libXcursor.patch;
          libXcursor = libXcursor.out;
        };
        dlopen-openssl = substituteAll {
          src = ./0006-dlopen-openssl.patch;
          openssl = openssl.out;
        };
        dlopen-dbus = substituteAll {
          src = ./0007-dlopen-dbus.patch;
          dbus_libs = dbus.lib;
        };
        xdg-config-dirs = ./0008-xdg-config-dirs.patch;
        decrypt-ssl-traffic = ./0009-decrypt-ssl-traffic.patch;
        mkspecs-libgl = substituteAll {
          src = ./0014-mkspecs-libgl.patch;
          mesa_inc = mesa.dev;
          mesa_lib = mesa.out;
        };
    in [
      dlopen-resolv dlopen-gl tzdir dlopen-libXcursor dlopen-openssl
      dlopen-dbus xdg-config-dirs
    ]
    ++ optional gtkStyle dlopen-gtkstyle
    ++ optional decryptSslTraffic decrypt-ssl-traffic
    ++ optional mesaSupported mkspecs-libgl;

  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/qtbase/lib:$PWD/qtbase/plugins/platforms:$PWD/qttools/lib:$LD_LIBRARY_PATH"
    export MAKEFLAGS=-j$NIX_BUILD_CORES

    sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/src/corelib/Qt5Config.cmake.in"
    sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/src/corelib/Qt5CoreMacros.cmake"
    sed -i 's/NO_DEFAULT_PATH//' "qtbase/src/gui/Qt5GuiConfigExtras.cmake.in"
    sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in"

    export configureFlags+="-plugindir $out/lib/qt5/plugins -importdir $out/lib/qt5/imports -qmldir $out/lib/qt5/qml"
    export configureFlags+=" -docdir $out/share/doc/qt5"
  '';

  prefixKey = "-prefix ";

  # -no-eglfs, -no-directfb, -no-linuxfb and -no-kms because of the current minimalist mesa
  # TODO Remove obsolete and useless flags once the build will be totally mastered
  configureFlags = ''
    -verbose
    -confirm-license
    -opensource

    -release
    -shared
    -c++11
    ${optionalString developerBuild "-developer-build"}
    -largefile
    -accessibility
    -rpath
    -optimized-qmake
    -strip
    -reduce-relocations
    -system-proxies
    -pkg-config

    -gui
    -widgets
    -opengl desktop
    -qml-debug
    -nis
    -iconv
    -icu
    -pch
    -glib
    -xcb
    -qpa xcb
    -${optionalString (cups == null) "no-"}cups
    -${optionalString (!gtkStyle) "no-"}gtkstyle

    -no-eglfs
    -no-directfb
    -no-linuxfb
    -no-kms

    ${optionalString (!system-x86_64) "-no-sse2"}
    -no-sse3
    -no-ssse3
    -no-sse4.1
    -no-sse4.2
    -no-avx
    -no-avx2
    -no-mips_dsp
    -no-mips_dspr2

    -system-zlib
    -system-libpng
    -system-libjpeg
    -system-xcb
    -system-xkbcommon
    -openssl-linked
    -dbus-linked

    -system-sqlite
    -${if mysql != null then "plugin" else "no"}-sql-mysql
    -${if postgresql != null then "plugin" else "no"}-sql-psql

    -make libs
    -make tools
    -${optionalString (buildExamples == false) "no"}make examples
    -${optionalString (buildTests == false) "no"}make tests
  '';

  # PostgreSQL autodetection fails sporadically because Qt omits the "-lpq" flag
  # if dependency paths contain the string "pq", which can occur in the hash.
  # To prevent these failures, we need to override PostgreSQL detection.
  PSQL_LIBS = optionalString (postgresql != null) "-L${postgresql.lib}/lib -lpq";

  propagatedBuildInputs = [
    xlibs.libXcomposite libX11 libxcb libXext libXrender libXi
    fontconfig freetype openssl dbus glib udev libxml2 libxslt pcre
    zlib libjpeg libpng libtiff sqlite icu
    xcbutil xcbutilimage xcbutilkeysyms xcbutilwm libxkbcommon
  ]
  # Qt doesn't directly need GLU (just GL), but many apps use, it's small and
  # doesn't remain a runtime-dep if not used
  ++ optionals mesaSupported [ mesa mesa_glu ]
  ++ optional (cups != null) cups
  ++ optional (mysql != null) mysql.lib
  ++ optional (postgresql != null) postgresql
  ++ optionals gtkStyle [gnome_vfs libgnomeui gtk GConf];

  buildInputs =
    [ bison flex gperf ruby ]
    ++ optional developerBuild gdb;

  nativeBuildInputs = [ python perl pkgconfig ];

  propagatedNativeBuildInputs = [ makeWrapper ];

  # freetype-2.5.4 changed signedness of some struct fields
  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare";

  postInstall =
    ''
      ${optionalString buildDocs ''
        make docs && make install_docs
      ''}

      # Don't retain build-time dependencies like gdb and ruby.
      sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $out/mkspecs/qconfig.pri
    '';

  inherit lndir;
  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  meta = {
    homepage = http://qt-project.org;
    description = "A cross-platform application framework for C++";
    license = "GPL/LGPL";
    maintainers = with maintainers; [ bbenoist qknight ttuegel ];
    platforms = platforms.linux;
  };

}
