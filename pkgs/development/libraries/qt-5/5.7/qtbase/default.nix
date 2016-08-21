{
  stdenv, lib, copyPathsToStore,
  src, version,

  coreutils, bison, flex, gdb, gperf, lndir, patchelf, perl, pkgconfig, python,
  ruby,

  dbus, fontconfig, freetype, glib, gtk3, harfbuzz, icu, libX11, libXcomposite,
  libXcursor, libXext, libXi, libXrender, libinput, libjpeg, libpng, libtiff,
  libxcb, libxkbcommon, libxml2, libxslt, openssl, pcre16, sqlite, udev,
  xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, xcbutilwm, xlibs,
  zlib, libmng, libwebp, jasper, double_conversion,

  # OS X
  Cocoa, CoreServices, CoreGraphics, CoreText, OpenGL, AppKit, Security,
  SystemConfiguration, CFNetwork, DiskArbitration, IOKit,

  # optional dependencies
  cups ? null, mysql ? null, postgresql ? null, mesa ? null,

  # options
  buildExamples ? false,
  buildTests ? false,
  developerBuild ? false,
  decryptSslTraffic ? false
}:

let
  system-x86_64 = lib.elem stdenv.system lib.platforms.x86_64;
in

stdenv.mkDerivation {

  name = "qtbase-${version}";
  inherit src version;

  outputs = [ "dev" "out" ];

  patches =
    copyPathsToStore (lib.readPathsFromFile ./. ./series)
    ++ lib.optional decryptSslTraffic ./decrypt-ssl-traffic.patch
    ++ lib.optional (mesa != null) [ ./dlopen-gl.patch ./mkspecs-libgl.patch ];

  postPatch =
    ''
      sed -i "s|/bin/sh|/bin/bash|g" configure
      sed -i 's|/bin/pwd|pwd|g' configure
      sed -i "s|/bin/ls|${coreutils}/bin/ls|g" src/corelib/global/global.pri
      sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i mkspecs/*/*.conf

      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "src/corelib/Qt5Config.cmake.in"
      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "src/corelib/Qt5CoreMacros.cmake"
      sed -i 's/NO_DEFAULT_PATH//' "src/gui/Qt5GuiConfigExtras.cmake.in"
      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in"

      sed -i "s|@glibc@|${stdenv.cc.libc.out}|g" src/network/kernel/qdnslookup_unix.cpp
      sed -i "s|@glibc@|${stdenv.cc.libc.out}|g" src/network/kernel/qhostinfo_unix.cpp

      sed -i "s|@libXcursor@|${libXcursor.out}|g" src/plugins/platforms/xcb/qxcbcursor.cpp

      sed -i "s|@openssl@|${openssl.out}|g" src/network/ssl/qsslsocket_openssl_symbols.cpp

      sed -i "s|@dbus_libs@|${dbus.lib}|g" src/dbus/qdbus_symbols.cpp

      sed -i "s|@libX11@|${libX11.out}|g" src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp
    ''
    + lib.optionalString (mesa != null) ''
      sed -i "s|@mesa_lib@|${mesa.out}|g" src/plugins/platforms/xcb/gl_integrations/xcb_glx/qglxintegration.cpp
      sed -i "s|@mesa_lib@|${mesa.out}|g" mkspecs/common/linux.conf
      sed -i "s|@mesa_inc@|${mesa.dev or mesa}|g" mkspecs/common/linux.conf
    '';

  setOutputFlags = false;

  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/lib:$PWD/plugins/platforms:$LD_LIBRARY_PATH"
    export MAKEFLAGS=-j$NIX_BUILD_CORES

    configureFlags+="\
        -plugindir $out/lib/qt5/plugins \
        -importdir $out/lib/qt5/imports \
        -qmldir $out/lib/qt5/qml \
        -docdir $out/share/doc/qt5"
  '';

  prefixKey = "-prefix ";

  # -no-eglfs, -no-directfb, -no-linuxfb and -no-kms because of the current minimalist mesa

  /* Build with no ICU support on Darwin because of this:
  https://wiki.qt.io/Locale_Support_in_Qt_5 */

  # Configure flags in same order as used by `./configure --help`.

  configureFlags = with stdenv; ''
    -release
    ${lib.optionalString developerBuild "-developer-build"}
    -no-optimized-tools
    -opensource
    -confirm-license
    -c++std c++11
    -shared
    -largefile
    -accessibility

    -no-sql-db2
    -no-sql-ibase
    ${lib.optionalString (null != mysql) "-plugin-sql-mysql"}
    ${lib.optionalString (null == mysql) "-no-sql-mysql"}
    -no-sql-oci
    -no-sql-odbc
    -no-sql-sqlite2
    ${lib.optionalString (null != postgresql) "-plugin-sql-psql"}
    ${lib.optionalString (null == postgresql) "-no-sql-psql"}
    -no-sql-tds

    -system-sqlite
    -qml-debug

    ${lib.optionalString (!system-x86_64) "-no-sse2"}
    -no-sse3
    -no-ssse3
    -no-sse4.1
    -no-sse4.2
    -no-avx
    -no-avx2
    -no-avx512
    -no-mips_dsp
    -no-mips_dspr2

    -pkg-config

    -system-zlib
    -no-mtdev
    -system-libpng
    -system-libjpeg
    -system-doubleconversion
    ${lib.optionalString isLinux "-system-freetype"}
    ${lib.optionalString isDarwin "-no-freetype"}
    -system-harfbuzz
    ${lib.optionalString isLinux "-openssl-linked"}
    ${lib.optionalString isDarwin "-no-openssl"}
    -no-libproxy
    -system-pcre
    -system-xcb
    ${lib.optionalString isDarwin "-no-xkbcommon-x11"}
    ${lib.optionalString isDarwin "-no-xkbcommon-evdev"}
    -${lib.optionalString isDarwin "no-"}glib
    ${lib.optionalString isDarwin "-no-pulseaudio"}
    ${lib.optionalString isDarwin "-no-alsa"}
    -${lib.optionalString isDarwin "no-"}gtk

    -make libs
    -make tools
    -${lib.optionalString (buildExamples == false) "no"}make examples
    -${lib.optionalString (buildTests == false) "no"}make tests

    -gui
    -widgets
    -${lib.optionalString isDarwin "no-"}rpath
    -verbose
    -nis
    -${lib.optionalString (cups == null) "no-"}cups
    -iconv
    ${lib.optionalString isDarwin "-no-evdev"}
    -no-tslib
    -${lib.optionalString isDarwin "no-"}icu
    -${lib.optionalString isDarwin "no-"}fontconfig
    -strip
    -pch
    -no-ltcg
    -dbus-linked
    -no-reduce-relocations
    ${lib.optionalString isDarwin "-no-use-gold-linker"}
    -${lib.optionalString isDarwin "no-"}xcb
    -no-eglfs
    -no-kms
    -no-gbm
    -no-directfb
    -no-linuxfb
    -no-mirclient
    -no-openvg
    ${lib.optionalString isLinux "-qpa xcb"}
    ${lib.optionalString isDarwin "-qpa cocoa"}
    -opengl desktop
    -${lib.optionalString isDarwin "no-"}libinput
    -system-proxies

    ${lib.optionalString isDarwin "-no-framework"}
    ${lib.optionalString isDarwin "-securetransport"}
    ${lib.optionalString isDarwin "-sdk macosx10.11"}

    ${lib.optionalString isDarwin "-no-libudev"}
'' +
# TODO Figure out why autodetection fails on Darwin for the following libraries.
lib.optionalString isDarwin ''
    -I${zlib.out}/include/ -L${zlib.out}/lib
    -I${libpng.dev}/include/ -L${libpng.out}/lib
    -I${libjpeg.dev}/include/ -L${libjpeg.out}/lib
    -I${double_conversion.out}/include/ -L${double_conversion.out}/lib
    -I${harfbuzz.dev}/include/ -I${harfbuzz.out}/include/
    -L${harfbuzz.out}/lib
    -I${pcre16.dev}/include/ -L${pcre16.out}/lib
    -I${libtiff.dev}/include/ -L${libtiff.out}/lib
    -I${libmng.dev}/include/ -L${libmng.out}/lib
    -I${libwebp.out}/include/ -L${libwebp.out}/lib
    -I${jasper.dev}/include/ -L${jasper.out}/lib
  '';

  # PostgreSQL autodetection fails sporadically because Qt omits the "-lpq" flag
  # if dependency paths contain the string "pq", which can occur in the hash.
  # To prevent these failures, we need to override PostgreSQL detection.
  PSQL_LIBS = lib.optionalString (postgresql != null) "-L${postgresql.lib}/lib -lpq";

  propagatedBuildInputs = with stdenv; [
    dbus libxml2 libxslt pcre16 sqlite zlib double_conversion

    # Image formats
    libjpeg libpng libtiff libmng libwebp jasper

    # Text rendering
    harfbuzz
  ]
  ++ lib.optional isLinux [
    glib openssl udev

    # Text rendering
    fontconfig freetype icu

    # X11 libs
    libX11 libXcomposite libXext libXi libXrender libxcb libxkbcommon xcbutil
    xcbutilimage xcbutilkeysyms xcbutilrenderutil xcbutilwm
  ]
  ++ lib.optional isDarwin [
    Cocoa CoreServices CoreGraphics CoreText OpenGL AppKit
    Security SystemConfiguration CFNetwork DiskArbitration IOKit
  ]
  ++ lib.optional (mesa != null) mesa;

  buildInputs = with stdenv;
    lib.optional isLinux [ gtk3 libinput ]
    ++ lib.optional developerBuild gdb
    ++ lib.optional (cups != null) cups
    ++ lib.optional (mysql != null) mysql.lib
    ++ lib.optional (postgresql != null) postgresql;

  nativeBuildInputs =
    [ bison flex gperf lndir patchelf perl pkgconfig python ruby ];

  # freetype-2.5.4 changed signedness of some struct fields
  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare";

  postInstall = ''
    find "$out" -name "*.cmake" | while read file; do
        substituteInPlace "$file" \
            --subst-var-by NIX_OUT "$out" \
            --subst-var-by NIX_DEV "$dev"
    done
  '';

  preFixup = ''
    # We cannot simply set these paths in configureFlags because libQtCore retains
    # references to the paths it was built with.
    moveToOutput "bin" "$dev"
    moveToOutput "include" "$dev"
    moveToOutput "mkspecs" "$dev"

    # The destination directory must exist or moveToOutput will do nothing
    mkdir -p "$dev/share"
    moveToOutput "share/doc" "$dev"
  '';

  postFixup =
    ''
      # Don't retain build-time dependencies like gdb and ruby.
      sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri

      # Move libtool archives and qmake projects
      if [ "z''${!outputLib}" != "z''${!outputDev}" ]; then
          pushd "''${!outputLib}"
          find lib -name '*.a' -o -name '*.la' -o -name '*.prl' | \
              while read -r file; do
                  mkdir -p "''${!outputDev}/$(dirname "$file")"
                  mv "''${!outputLib}/$file" "''${!outputDev}/$file"
              done
          popd
      fi
    '';

  inherit lndir;
  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://www.qt.io;
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ bbenoist qknight ttuegel ];
    platforms = with platforms; linux ++ darwin;
    hydraPlatforms = platforms.linux;
  };

}
