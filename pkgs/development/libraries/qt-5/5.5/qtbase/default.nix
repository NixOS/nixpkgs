{ stdenv, lib, fetchurl, copyPathsToStore, makeWrapper
, srcs

, xlibs, libX11, libxcb, libXcursor, libXext, libXrender, libXi
, xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilwm, libxkbcommon
, fontconfig, freetype, openssl, dbus, glib, udev, libxml2, libxslt, pcre16
, zlib, libjpeg, libpng, libtiff, sqlite, icu, harfbuzz

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

let
  inherit (srcs.qt5) version;
  system-x86_64 = lib.elem stdenv.system lib.platforms.x86_64;

  dontInvalidateBacking = fetchurl {
    url = "https://codereview.qt-project.org/gitweb?p=qt/qtbase.git;a=patch;h=0f68f8920573cdce1729a285a92ac8582df32841;hp=24c50f8dcf7fa61ac3c3d4d6295c259a104a2b8c";
    name = "qtbug-48321-dont-invalidate-backing-store.patch";
    sha256 = "07vnndmvri73psz0nrs2hg0zw2i4b1k1igy2al6kwjbp7d5xpglr";
  };
in

stdenv.mkDerivation {

  name = "qtbase-${version}";
  inherit version;

  srcs = with srcs; [ qt5.src qtbase.src ];

  sourceRoot = "qt-everywhere-opensource-src-${version}";

  postUnpack = ''
    mv qtbase-opensource-src-${version} ./qt-everywhere-opensource-src-${version}/qtbase
  '';

  patches =
    copyPathsToStore (lib.readPathsFromFile ./. ./series)
    ++ lib.optional gtkStyle ./dlopen-gtkstyle.patch
    ++ lib.optional decryptSslTraffic ./decrypt-ssl-traffic.patch
    ++ lib.optional mesaSupported [ ./dlopen-gl.patch ./mkspecs-libgl.patch ];

  postPatch =
    ''
      cd qtbase
      patch -p1 <${dontInvalidateBacking}
      cd ..

      substituteInPlace configure --replace /bin/pwd pwd
      substituteInPlace qtbase/configure --replace /bin/pwd pwd
      substituteInPlace qtbase/src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
      sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i qtbase/mkspecs/*/*.conf

      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/src/corelib/Qt5Config.cmake.in"
      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/src/corelib/Qt5CoreMacros.cmake"
      sed -i 's/NO_DEFAULT_PATH//' "qtbase/src/gui/Qt5GuiConfigExtras.cmake.in"
      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "qtbase/mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in"

      substituteInPlace qtbase/src/network/kernel/qdnslookup_unix.cpp \
        --replace "@glibc@" "${stdenv.cc.libc}"
      substituteInPlace qtbase/src/network/kernel/qhostinfo_unix.cpp \
        --replace "@glibc@" "${stdenv.cc.libc}"

      substituteInPlace qtbase/src/plugins/platforms/xcb/qxcbcursor.cpp \
        --replace "@libXcursor@" "${libXcursor}"

      substituteInPlace qtbase/src/network/ssl/qsslsocket_openssl_symbols.cpp \
        --replace "@openssl@" "${openssl}"

      substituteInPlace qtbase/src/dbus/qdbus_symbols.cpp \
        --replace "@dbus_libs@" "${dbus}"

      substituteInPlace \
        qtbase/src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp \
        --replace "@libX11@" "${libX11}"
    ''
    + lib.optionalString gtkStyle ''
      substituteInPlace qtbase/src/widgets/styles/qgtk2painter.cpp --replace "@gtk@" "${gtk}"
      substituteInPlace qtbase/src/widgets/styles/qgtkstyle_p.cpp \
        --replace "@gtk@" "${gtk}" \
        --replace "@gnome_vfs@" "${gnome_vfs}" \
        --replace "@libgnomeui@" "${libgnomeui}" \
        --replace "@gconf@" "${GConf}"
    ''
    + lib.optionalString mesaSupported ''
      substituteInPlace \
        qtbase/src/plugins/platforms/xcb/gl_integrations/xcb_glx/qglxintegration.cpp \
        --replace "@mesa@" "${mesa}"
      substituteInPlace qtbase/mkspecs/common/linux.conf --replace "@mesa@" "${mesa}"
    '';

  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/qtbase/lib:$PWD/qtbase/plugins/platforms:$LD_LIBRARY_PATH"
    export MAKEFLAGS=-j$NIX_BUILD_CORES

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
    ${lib.optionalString developerBuild "-developer-build"}
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
    -${lib.optionalString (cups == null) "no-"}cups
    -${lib.optionalString (!gtkStyle) "no-"}gtkstyle

    -no-eglfs
    -no-directfb
    -no-linuxfb
    -no-kms

    ${lib.optionalString (!system-x86_64) "-no-sse2"}
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
    -system-harfbuzz
    -system-xcb
    -system-xkbcommon
    -system-pcre
    -openssl-linked
    -dbus-linked

    -system-sqlite
    -${if mysql != null then "plugin" else "no"}-sql-mysql
    -${if postgresql != null then "plugin" else "no"}-sql-psql

    -make libs
    -make tools
    -${lib.optionalString (buildExamples == false) "no"}make examples
    -${lib.optionalString (buildTests == false) "no"}make tests
  '';

  # PostgreSQL autodetection fails sporadically because Qt omits the "-lpq" flag
  # if dependency paths contain the string "pq", which can occur in the hash.
  # To prevent these failures, we need to override PostgreSQL detection.
  PSQL_LIBS = lib.optionalString (postgresql != null) "-L${postgresql}/lib -lpq";

  propagatedBuildInputs = [
    xlibs.libXcomposite libX11 libxcb libXext libXrender libXi
    fontconfig freetype openssl dbus.libs glib udev libxml2 libxslt pcre16
    zlib libjpeg libpng libtiff sqlite icu harfbuzz
    xcbutil xcbutilimage xcbutilkeysyms xcbutilwm libxkbcommon
  ]
  # Qt doesn't directly need GLU (just GL), but many apps use, it's small and
  # doesn't remain a runtime-dep if not used
  ++ lib.optionals mesaSupported [ mesa mesa_glu ]
  ++ lib.optional (cups != null) cups
  ++ lib.optional (mysql != null) mysql.lib
  ++ lib.optional (postgresql != null) postgresql
  ++ lib.optionals gtkStyle [gnome_vfs libgnomeui gtk GConf];

  buildInputs =
    [ bison flex gperf ruby ]
    ++ lib.optional developerBuild gdb;

  nativeBuildInputs = [ python perl pkgconfig ];

  propagatedNativeBuildInputs = [ makeWrapper ];

  # freetype-2.5.4 changed signedness of some struct fields
  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare";

  postInstall =
    ''
      # Don't retain build-time dependencies like gdb and ruby.
      sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $out/mkspecs/qconfig.pri
    ''
    + lib.optionalString buildDocs ''
      make docs && make install_docs
    '';

  inherit lndir;
  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://qt-project.org;
    description = "A cross-platform application framework for C++";
    license = "GPL/LGPL";
    maintainers = with maintainers; [ bbenoist qknight ttuegel ];
    platforms = platforms.linux;
  };

}
