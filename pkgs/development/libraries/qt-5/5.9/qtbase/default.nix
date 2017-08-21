{
  stdenv, lib, copyPathsToStore,
  src, version, qtCompatVersion,

  coreutils, bison, flex, gdb, gperf, lndir, patchelf, perl, pkgconfig, python2,
  ruby,
  # darwin support
  darwin, libiconv, libcxx,

  dbus, dconf, fontconfig, freetype, glib, gtk3, harfbuzz, icu, libX11, libXcomposite,
  libXcursor, libXext, libXi, libXrender, libinput, libjpeg, libpng, libtiff,
  libxcb, libxkbcommon, libxml2, libxslt, openssl, pcre2, sqlite, udev,
  xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, xcbutilwm, xlibs,
  zlib,

  # optional dependencies
  cups ? null, mysql ? null, postgresql ? null,

  # options
  mesaSupported ? (!stdenv.isDarwin),
  mesa,
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
  inherit qtCompatVersion src version;

  propagatedBuildInputs =
    [
      libxml2 libxslt openssl pcre2 sqlite zlib

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
      libX11 libXcomposite libXext libXi libXrender libxcb libxkbcommon xcbutil
      xcbutilimage xcbutilkeysyms xcbutilrenderutil xcbutilwm
    ]

    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      AGL AppKit ApplicationServices Carbon Cocoa
      CoreAudio CoreBluetooth CoreLocation CoreServices
      DiskArbitration Foundation OpenGL
      darwin.cf-private darwin.libobjc libiconv
    ]);

  buildInputs = [ ]
    ++ lib.optionals (!stdenv.isDarwin) [ gtk3 libinput ]
    ++ lib.optional developerBuild gdb
    ++ lib.optional (cups != null) cups
    ++ lib.optional (mysql != null) mysql.lib
    ++ lib.optional (postgresql != null) postgresql;

  nativeBuildInputs =
    [ bison flex gperf lndir perl pkgconfig python2 ]
    ++ lib.optional (!stdenv.isDarwin) patchelf;

  outputs = [ "out" "dev" "bin" ];

  patches =
    copyPathsToStore (lib.readPathsFromFile ./. ./series);

  postPatch =
    ''
      substituteInPlace configure --replace /bin/pwd pwd
      substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
      sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i config.tests/*/*.test -i mkspecs/*/*.conf

      sed -i '/PATHS.*NO_DEFAULT_PATH/ d' src/corelib/Qt5Config.cmake.in
      sed -i '/PATHS.*NO_DEFAULT_PATH/ d' src/corelib/Qt5CoreMacros.cmake
      sed -i 's/NO_DEFAULT_PATH//' src/gui/Qt5GuiConfigExtras.cmake.in
      sed -i '/PATHS.*NO_DEFAULT_PATH/ d' mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in
    ''

    + lib.optionalString mesaSupported ''
      sed -i mkspecs/common/linux.conf \
          -e "/^QMAKE_INCDIR_OPENGL/ s|$|${mesa.dev or mesa}/include|" \
          -e "/^QMAKE_LIBDIR_OPENGL/ s|$|${mesa.out}/lib|"
    ''

    + lib.optionalString stdenv.isDarwin ''
      sed -i \
          -e 's|! /usr/bin/xcode-select --print-path >/dev/null 2>&1;|false;|' \
          -e 's|! /usr/bin/xcrun -find xcodebuild >/dev/null 2>&1;|false;|' \
          -e 's|sysroot=$(/usr/bin/xcodebuild -sdk $sdk -version Path 2>/dev/null)|sysroot=/nonsense|' \
          -e 's|QMAKE_CONF_COMPILER=`getXQMakeConf QMAKE_CXX`|QMAKE_CXX="clang++"\nQMAKE_CONF_COMPILER="clang++"|' \
          -e 's|XCRUN=`/usr/bin/xcrun -sdk macosx clang -v 2>&1`|XCRUN="clang -v 2>&1"|' \
          -e 's#sdk_val=$(/usr/bin/xcrun -sdk $sdk -find $(echo $val | cut -d \x27 \x27 -f 1))##' \
          -e 's#val=$(echo $sdk_val $(echo $val | cut -s -d \x27 \x27 -f 2-))##' \
          ./configure
      sed -i '3,$d' ./mkspecs/features/mac/default_pre.prf
      sed -i '26,$d' ./mkspecs/features/mac/default_post.prf
      sed -i '1,$d' ./mkspecs/features/mac/sdk.prf
      sed -i 's/QMAKE_LFLAGS_RPATH      = -Wl,-rpath,/QMAKE_LFLAGS_RPATH      =/' ./mkspecs/common/mac.conf
     '';
     # Note on the above: \x27 is a way if including a single-quote
     # character in the sed string arguments.

  qtPluginPrefix = "lib/qt-${qtCompatVersion}/plugins";
  qtQmlPrefix = "lib/qt-${qtCompatVersion}/qml";
  qtDocPrefix = "share/doc/qt-${qtCompatVersion}";

  setOutputFlags = false;
  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/lib:$PWD/plugins/platforms:$LD_LIBRARY_PATH"
    export MAKEFLAGS=-j$NIX_BUILD_CORES

    configureFlags+="\
        -plugindir $out/$qtPluginPrefix \
        -qmldir $out/$qtQmlPrefix \
        -docdir $out/$qtDocPrefix"

    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QT_PLUGIN_PREFIX=\"$qtPluginPrefix\""
  '';


  NIX_CFLAGS_COMPILE =
    [
      "-Wno-error=sign-compare" # freetype-2.5.4 changed signedness of some struct fields
      ''-DNIXPKGS_QTCOMPOSE="${libX11.out}/share/X11/locale"''
      ''-DNIXPKGS_LIBRESOLV="${stdenv.cc.libc.out}/lib/libresolv"''
      ''-DNIXPKGS_LIBXCURSOR="${libXcursor.out}/lib/libXcursor"''
    ]

    ++ lib.optional mesaSupported
       ''-DNIXPKGS_MESA_GL="${mesa.out}/lib/libGL"''

    ++ lib.optionals (!stdenv.isDarwin)
    [
      ''-DNIXPKGS_QGTK3_XDG_DATA_DIRS="${gtk3}/share/gsettings-schemas/${gtk3.name}"''
      ''-DNIXPKGS_QGTK3_GIO_EXTRA_MODULES="${dconf.lib}/lib/gio/modules"''
    ]

    ++ lib.optionals stdenv.isDarwin
    [
      "-D__MAC_OS_X_VERSION_MAX_ALLOWED=1090"
      "-D__AVAILABILITY_INTERNAL__MAC_10_10=__attribute__((availability(macosx,introduced=10.10)))"
      # Note that nixpkgs's objc4 is from macOS 10.11 while the SDK is
      # 10.9 which necessitates the above macro definition that mentions
      # 10.10
    ]

    ++ lib.optional decryptSslTraffic "-DQT_DECRYPT_SSL_TRAFFIC";

  prefixKey = "-prefix ";

  # PostgreSQL autodetection fails sporadically because Qt omits the "-lpq" flag
  # if dependency paths contain the string "pq", which can occur in the hash.
  # To prevent these failures, we need to override PostgreSQL detection.
  PSQL_LIBS = lib.optionalString (postgresql != null) "-L${postgresql.lib}/lib -lpq";

  # -no-eglfs, -no-directfb, -no-linuxfb and -no-kms because of the current minimalist mesa
  # TODO Remove obsolete and useless flags once the build will be totally mastered
  configureFlags =
    [
      "-verbose"
      "-confirm-license"
      "-opensource"

      "-release"
      "-shared"
      "-accessibility"
      "-optimized-qmake"
      "-strip"
      "-system-proxies"
      "-pkg-config"
    ]
    ++ lib.optionals developerBuild [
      "-developer-build"
      "-no-warnings-are-errors"
    ]
    ++ [
      "-gui"
      "-widgets"
      "-opengl desktop"
      "-qml-debug"
      "-icu"
      "-pch"
    ]

    ++ [
      ''${lib.optionalString (!system-x86_64) "-no"}-sse2''
      "-no-sse3"
      "-no-ssse3"
      "-no-sse4.1"
      "-no-sse4.2"
      "-no-avx"
      "-no-avx2"
      "-no-mips_dsp"
      "-no-mips_dspr2"
    ]

    ++ [
      "-system-zlib"
      "-system-libjpeg"
      "-system-harfbuzz"
      "-system-pcre"
      "-openssl-linked"
      "-system-sqlite"
      ''-${if mysql != null then "plugin" else "no"}-sql-mysql''
      ''-${if postgresql != null then "plugin" else "no"}-sql-psql''

      "-make libs"
      "-make tools"
      ''-${lib.optionalString (buildExamples == false) "no"}make examples''
      ''-${lib.optionalString (buildTests == false) "no"}make tests''
      "-v"
    ]

    ++ lib.optionals (!stdenv.isDarwin) [
      "-rpath"

      "-system-xcb"
      "-xcb"
      "-qpa xcb"

      "-system-xkbcommon"
      "-libinput"
      "-xkbcommon-evdev"

      "-no-eglfs"
      "-no-gbm"
      "-no-kms"
      "-no-linuxfb"

      ''-${lib.optionalString (cups == null) "no-"}cups''
      "-dbus-linked"
      "-glib"
      "-gtk"
      "-inotify"
      "-system-libjpeg"
      "-system-libpng"
    ]

    ++ lib.optionals stdenv.isDarwin [
      "-platform macx-clang"
      "-no-use-gold-linker"
      "-no-fontconfig"
      "-qt-freetype"
      "-qt-libpng"
    ];

  enableParallelBuilding = true;

  postInstall =
    # Hardcode some CMake module paths.
    ''
      find "$out" -name "*.cmake" | while read file; do
          substituteInPlace "$file" \
              --subst-var-by NIX_OUT "''${!outputLib}" \
              --subst-var-by NIX_DEV "''${!outputDev}" \
              --subst-var-by NIX_BIN "''${!outputBin}"
      done
    '';

  preFixup =
    # Move selected outputs.
    ''
      moveToOutput "bin" "$dev"
      moveToOutput "include" "$dev"
      moveToOutput "mkspecs" "$dev"

      mkdir -p "$dev/share"
      moveToOutput "share/doc" "$dev"

      moveToOutput "$qtPluginPrefix" "$bin"
    '';

  postFixup =
    # Don't retain build-time dependencies like gdb.
    ''
      sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri
    ''

    # Move libtool archives into $dev
    + ''
      if [ "z''${!outputLib}" != "z''${!outputDev}" ]; then
          pushd "''${!outputLib}"
          find lib -name '*.a' -o -name '*.la' | while read -r file; do
              mkdir -p "''${!outputDev}/$(dirname "$file")"
              mv "''${!outputLib}/$file" "''${!outputDev}/$file"
          done
          popd
      fi
    ''

    # Move qmake project files into $dev.
    # Don't move .prl files on darwin because they end up in
    # "dev/lib/Foo.framework/Foo.prl" which interferes with subsequent
    # use of lndir in the qtbase setup-hook. On Linux, the .prl files
    # are in lib, and so do not cause a subsequent recreation of deep
    # framework directory trees.
    + lib.optionalString (!stdenv.isDarwin) ''
      if [ "z''${!outputLib}" != "z''${!outputDev}" ]; then
          pushd "''${!outputLib}"
          find lib -name '*.prl' | while read -r file; do
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

  meta = with lib; {
    homepage = http://www.qt.io;
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ qknight ttuegel periklis ];
    platforms = platforms.unix;
  };

}
