{ stdenv, substituteAll
, srcs, version

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
}:

with stdenv.lib;

stdenv.mkDerivation {

  name = "qtbase-${version}";
  inherit version;

  srcs = with srcs; [ qt5-opensource-src qtbase-opensource-src ];
  sourceRoot = "qt-everywhere-opensource-src-${version}";

  postUnpack = ''
    mv qtbase-opensource-src-${version} ./qt-everywhere-opensource-src-${version}/qtbase
  '';

  prePatch = ''
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace qtbase/configure --replace /bin/pwd pwd
    substituteInPlace qtbase/src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
    substituteInPlace qtbase/src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp \
        --replace /usr/share/X11/locale ${libX11}/share/X11/locale \
        --replace /usr/lib/X11/locale ${libX11}/share/X11/locale
    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i qtbase/mkspecs/*/*.conf
  '';

  patches =
    optional gtkStyle
      (substituteAll {
        src = ./0001-dlopen-gtkstyle.patch;
        # substituteAll ignores env vars starting with capital letter
        gconf = GConf;
        inherit gnome_vfs libgnomeui gtk;
      })
    ++ [
      (substituteAll {
        src = ./0004-dlopen-resolv.patch;
        glibc = stdenv.cc.libc;
      })
      (substituteAll {
        src = ./0005-dlopen-gl.patch;
        openglDriver = if mesaSupported then mesa.driverLink else "/no-such-path";
      })
      ./0006-tzdir.patch
      (substituteAll { src = ./0010-dlopen-libXcursor.patch; inherit libXcursor; })
      (substituteAll { src = ./0011-dlopen-openssl.patch; inherit openssl; })
      (substituteAll { src = ./0012-dlopen-dbus.patch; dbus_libs = dbus; })
    ];

  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/qtbase/lib:$PWD/qtbase/plugins/platforms:$PWD/qttools/lib:$LD_LIBRARY_PATH"
    export MAKEFLAGS=-j$NIX_BUILD_CORES

    sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/src/corelib/Qt5Config.cmake.in"
    sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/src/corelib/Qt5CoreMacros.cmake"
    sed -i 's/NO_DEFAULT_PATH//' "qtbase/src/gui/Qt5GuiConfigExtras.cmake.in"
    sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in"

    export configureFlags+="-plugindir $out/lib/qt5/plugins -importdir $out/lib/qt5/imports -qmldir $out/lib/qt5/qml"
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

    -no-eglfs
    -no-directfb
    -no-linuxfb
    -no-kms

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

  propagatedBuildInputs = [
    xlibs.libXcomposite libX11 libxcb libXext libXrender libXi
    fontconfig freetype openssl dbus.libs glib udev libxml2 libxslt pcre
    zlib libjpeg libpng libtiff sqlite icu
    xcbutil xcbutilimage xcbutilkeysyms xcbutilwm libxkbcommon
  ]
  # Qt doesn't directly need GLU (just GL), but many apps use, it's small and
  # doesn't remain a runtime-dep if not used
  ++ optionals mesaSupported [ mesa mesa_glu ]
  ++ optional (cups != null) cups
  ++ optional (mysql != null) mysql
  ++ optional (postgresql != null) postgresql;

  buildInputs = [ gdb bison flex gperf ruby ];

  nativeBuildInputs = [ python perl pkgconfig ];

  # freetype-2.5.4 changed signedness of some struct fields
  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare";

  postInstall =
    ''
      ${optionalString buildDocs ''
        make docs && make install_docs
      ''}

      # Don't retain build-time dependencies like gdb and ruby.
      sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $out/mkspecs/qconfig.pri

      mkdir -p "$out/nix-support"
      substitute ${./setup-hook.sh} "$out/nix-support/setup-hook" \
        --subst-var out --subst-var-by lndir "${lndir}"
    '';

  enableParallelBuilding = true; # often fails on Hydra, as well as qt4

  meta = {
    homepage = http://qt-project.org;
    description = "A cross-platform application framework for C++";
    license = "GPL/LGPL";
    maintainers = with maintainers; [ bbenoist qknight ttuegel ];
    platforms = platforms.linux;
  };

}
