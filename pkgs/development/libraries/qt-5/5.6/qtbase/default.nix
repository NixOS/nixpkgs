{ stdenv, lib, fetchgit, copyPathsToStore
, srcs

, xlibs, libX11, libxcb, libXcursor, libXext, libXrender, libXi
, xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilwm, libxkbcommon
, fontconfig, freetype, harfbuzz
, openssl, dbus, glib, udev, libxml2, libxslt, pcre16
, zlib, libjpeg, libpng, libtiff, sqlite, icu

, coreutils, bison, flex, gdb, gperf, lndir
, patchelf, perl, pkgconfig, python2
, darwin, libiconv

# optional dependencies
, cups ? null
, mysql ? null, postgresql ? null

# options
, mesaSupported ? (!stdenv.isDarwin)
, mesa
, buildExamples ? false
, buildTests ? false
, developerBuild ? false
, decryptSslTraffic ? false
}:

let
  system-x86_64 = lib.elem stdenv.system lib.platforms.x86_64;
in

stdenv.mkDerivation {

  name = "qtbase-${srcs.qtbase.version}";
  inherit (srcs.qtbase) src version;

  outputs = [ "out" "dev" ];

  patches =
    copyPathsToStore (lib.readPathsFromFile ./. ./series)
    ++ [(if stdenv.isDarwin then ./cmake-paths-darwin.patch else ./cmake-paths.patch)]
    ++ lib.optional decryptSslTraffic ./decrypt-ssl-traffic.patch
    ++ lib.optional mesaSupported [ ./dlopen-gl.patch ./mkspecs-libgl.patch ];

  postPatch =
    ''
      substituteInPlace configure --replace /bin/pwd pwd
      substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
      sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i mkspecs/*/*.conf

      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "src/corelib/Qt5Config.cmake.in"
      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "src/corelib/Qt5CoreMacros.cmake"
      sed -i 's/NO_DEFAULT_PATH//' "src/gui/Qt5GuiConfigExtras.cmake.in"
      sed -i 's/PATHS.*NO_DEFAULT_PATH//' "mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in"

      substituteInPlace src/network/kernel/qdnslookup_unix.cpp \
        --replace "@glibc@" "${stdenv.cc.libc.out}"
      substituteInPlace src/network/kernel/qhostinfo_unix.cpp \
        --replace "@glibc@" "${stdenv.cc.libc.out}"

      substituteInPlace src/network/ssl/qsslsocket_openssl_symbols.cpp \
        --replace "@openssl@" "${openssl.out}"
    '' + lib.optionalString stdenv.isLinux ''
      substituteInPlace src/plugins/platforms/xcb/qxcbcursor.cpp \
        --replace "@libXcursor@" "${libXcursor.out}"

      substituteInPlace src/dbus/qdbus_symbols.cpp \
        --replace "@dbus_libs@" "${dbus.lib}"

      substituteInPlace \
        src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp \
        --replace "@libX11@" "${libX11.out}"
    '' + lib.optionalString mesaSupported ''
      substituteInPlace \
        src/plugins/platforms/xcb/gl_integrations/xcb_glx/qglxintegration.cpp \
        --replace "@mesa_lib@" "${mesa.out}"
      substituteInPlace mkspecs/common/linux.conf \
        --replace "@mesa_lib@" "${mesa.out}" \
        --replace "@mesa_inc@" "${mesa.dev or mesa}"
    '' + lib.optionalString stdenv.isDarwin ''
      sed -i \
          -e 's|! /usr/bin/xcode-select --print-path >/dev/null 2>&1;|false;|' \
          -e 's|! /usr/bin/xcrun -find xcodebuild >/dev/null 2>&1;|false;|' \
          -e 's|sysroot=$(/usr/bin/xcodebuild -sdk $sdk -version Path 2>/dev/null)|sysroot="${darwin.apple_sdk.sdk}"|' \
          -e 's|QMAKE_CONF_COMPILER=`getXQMakeConf QMAKE_CXX`|QMAKE_CXX="clang++"\nQMAKE_CONF_COMPILER="clang++"|' \
          -e 's|XCRUN=`/usr/bin/xcrun -sdk macosx clang -v 2>&1`|XCRUN="clang -v 2>&1"|' \
          -e 's#sdk_val=$(/usr/bin/xcrun -sdk $sdk -find $(echo $val | cut -d \x27 \x27 -f 1))##' \
          -e 's#val=$(echo $sdk_val $(echo $val | cut -s -d \x27 \x27 -f 2-))##' \
          ./configure
      sed -i '3,$d' ./mkspecs/features/mac/default_pre.prf
      sed -i '26,$d' ./mkspecs/features/mac/default_post.prf
      sed -i '1,$d' ./mkspecs/features/mac/sdk.prf
      sed 's/QMAKE_LFLAGS_RPATH      = -Wl,-rpath,/QMAKE_LFLAGS_RPATH      =/' -i ./mkspecs/common/mac.conf
    '';
    # Note on the above: \x27 is a way if including a single-quote
    # character in the sed string arguments.

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
    -optimized-qmake
    -strip
    -no-reduce-relocations
    -system-proxies
    -pkg-config

    -gui
    -widgets
    -opengl desktop
    -qml-debug
    -iconv
    -icu
    -pch

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
    -system-pcre
    -openssl-linked

    -system-sqlite
    -${if mysql != null then "plugin" else "no"}-sql-mysql
    -${if postgresql != null then "plugin" else "no"}-sql-psql

    -make libs
    -make tools
    -${lib.optionalString (buildExamples == false) "no"}make examples
    -${lib.optionalString (buildTests == false) "no"}make tests
  '' + lib.optionalString (!stdenv.isDarwin) ''
    -no-rpath
    -glib
    -xcb
    -qpa xcb

    -${lib.optionalString (cups == null) "no-"}cups

    -no-eglfs
    -no-directfb
    -no-linuxfb
    -no-kms

    -system-xcb
    -system-xkbcommon
    -dbus-linked
  '' + lib.optionalString stdenv.isDarwin ''
    -platform macx-clang
    -no-use-gold-linker
    -no-fontconfig
    -qt-freetype
  '';

  # PostgreSQL autodetection fails sporadically because Qt omits the "-lpq" flag
  # if dependency paths contain the string "pq", which can occur in the hash.
  # To prevent these failures, we need to override PostgreSQL detection.
  PSQL_LIBS = lib.optionalString (postgresql != null) "-L${postgresql.lib}/lib -lpq";

  propagatedBuildInputs = [
    libxml2 libxslt openssl pcre16 sqlite zlib

    # Text rendering
    harfbuzz icu

    # Image formats
    libjpeg libpng libtiff
  ]
  ++ lib.optional mesaSupported mesa
  ++ lib.optionals (!stdenv.isDarwin) [
    dbus glib udev

    # Text rendering
    fontconfig freetype
    # X11 libs
    xlibs.libXcomposite libX11 libxcb libXext libXrender libXi
    xcbutil xcbutilimage xcbutilkeysyms xcbutilwm libxkbcommon
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    ApplicationServices CoreServices AppKit Carbon OpenGL AGL Cocoa
    DiskArbitration darwin.cf-private libiconv darwin.apple_sdk.sdk
  ]);

  buildInputs =
    [ bison flex gperf ]
    ++ lib.optional developerBuild gdb
    ++ lib.optional (cups != null) cups
    ++ lib.optional (mysql != null) mysql.lib
    ++ lib.optional (postgresql != null) postgresql;

  nativeBuildInputs = [ lndir perl pkgconfig python2 ] ++ lib.optional (!stdenv.isDarwin) patchelf;

  # freetype-2.5.4 changed signedness of some struct fields
  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare"
    + lib.optionalString stdenv.isDarwin " -D__MAC_OS_X_VERSION_MAX_ALLOWED=1090 -D__AVAILABILITY_INTERNAL__MAC_10_10=__attribute__((availability(macosx,introduced=10.10)))";
  # Note that nixpkgs's objc4 is from macOS 10.11 while the SDK is
  # 10.9 which necessitates the above macro definition that mentions
  # 10.10

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

  # Don't move .prl files on darwin because they end up in
  # "dev/lib/Foo.framework/Foo.prl" which interferes with subsequent
  # use of lndir in the qtbase setup-hook. On Linux, the .prl files
  # are in lib, and so do not cause a subsequent recreation of deep
  # framework directory trees.
  postFixup =
    ''
      # Don't retain build-time dependencies like gdb.
      sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri

      # Move libtool archives and qmake projects
      if [ "z''${!outputLib}" != "z''${!outputDev}" ]; then
          pushd "''${!outputLib}"
          find lib -name '*.a' -o -name '*.la'${if stdenv.isDarwin then "" else "-o -name '*.prl'"} | \
              while read -r file; do
                  mkdir -p "''${!outputDev}/$(dirname "$file")"
                  mv "''${!outputLib}/$file" "''${!outputDev}/$file"
              done
          popd
      fi
    ''

    # fixup .pc file (where to find 'moc' etc.)
    + lib.optionalString (!stdenv.isDarwin) ''
      sed -i "$dev/lib/pkgconfig/Qt5Core.pc" \
          -e "/^host_bins=/ c host_bins=$dev/bin"
    ''

    # Don't move .prl files on darwin because they end up in
    # "dev/lib/Foo.framework/Foo.prl" which interferes with subsequent
    # use of lndir in the qtbase setup-hook. On Linux, the .prl files
    # are in lib, and so do not cause a subsequent recreation of deep
    # framework directory trees.
    + lib.optionalString stdenv.isDarwin ''
      fixDarwinDylibNames_rpath() {
        local flags=()

        for fn in "$@"; do
          flags+=(-change "@rpath/$fn.framework/Versions/5/$fn" "$out/lib/$fn.framework/Versions/5/$fn")
        done

        for fn in "$@"; do
          echo "$fn: fixing dylib"
          install_name_tool -id "$out/lib/$fn.framework/Versions/5/$fn" "''${flags[@]}" "$out/lib/$fn.framework/Versions/5/$fn"
        done
      }
      fixDarwinDylibNames_rpath "QtConcurrent" "QtPrintSupport" "QtCore" "QtSql" "QtDBus" "QtTest" "QtGui" "QtWidgets" "QtNetwork" "QtXml" "QtOpenGL"
    '';

  inherit lndir;
  setupHook = if stdenv.isDarwin
              then ../../qtbase-setup-hook-darwin.sh
              else ../../qtbase-setup-hook.sh;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://www.qt.io;
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ bbenoist qknight ttuegel ];
    platforms = platforms.unix;
  };
}
