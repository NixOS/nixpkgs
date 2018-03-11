{
  stdenv, lib,
  src, patches, version, qtCompatVersion,

  coreutils, bison, flex, gdb, gperf, lndir, patchelf, perl, pkgconfig, python2,
  ruby, which,
  # darwin support
  darwin, libiconv, libcxx,

  dbus, fontconfig, freetype, glib, harfbuzz, icu, libX11, libXcomposite,
  libXcursor, libXext, libXi, libXrender, libinput, libjpeg, libpng, libtiff,
  libxcb, libxkbcommon, libxml2, libxslt, openssl, pcre16, pcre2, sqlite, udev,
  xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, xcbutilwm, xlibs,
  zlib,

  # optional dependencies
  cups ? null, mysql ? null, postgresql ? null,
  withGtk3 ? false, dconf ? null, gtk3 ? null,

  # options
  libGLSupported ? (!stdenv.isDarwin),
  libGL,
  buildExamples ? false,
  buildTests ? false,
  developerBuild ? false,
  decryptSslTraffic ? false
}:

assert withGtk3 -> dconf != null;
assert withGtk3 -> gtk3 != null;

let
  system-x86_64 = lib.elem stdenv.system lib.platforms.x86_64;
  compareVersion = v: builtins.compareVersions version v;
in

stdenv.mkDerivation {

  name = "qtbase-${version}";
  inherit qtCompatVersion src version;

  propagatedBuildInputs =
    [
      libxml2 libxslt openssl sqlite zlib

      # Text rendering
      harfbuzz icu

      # Image formats
      libjpeg libpng libtiff
      (if compareVersion "5.9.0" >= 0 then pcre2 else pcre16)
    ]
    ++ (
      if stdenv.isDarwin
      then with darwin.apple_sdk.frameworks;
        [
          AGL AppKit ApplicationServices Carbon Cocoa CoreAudio CoreBluetooth
          CoreLocation CoreServices DiskArbitration Foundation OpenGL
          darwin.libobjc libiconv
        ]
      else
        [
          dbus glib udev

          # Text rendering
          fontconfig freetype

          # X11 libs
          libX11 libXcomposite libXext libXi libXrender libxcb libxkbcommon xcbutil
          xcbutilimage xcbutilkeysyms xcbutilrenderutil xcbutilwm
        ]
        ++ lib.optional libGLSupported libGL
    );

  buildInputs =
    lib.optionals (!stdenv.isDarwin)
    (
      [ libinput ]
      ++ lib.optional withGtk3 gtk3
    )
    ++ lib.optional developerBuild gdb
    ++ lib.optional (cups != null) cups
    ++ lib.optional (mysql != null) mysql.connector-c
    ++ lib.optional (postgresql != null) postgresql;

  nativeBuildInputs =
    [ bison flex gperf lndir perl pkgconfig python2 which ]
    ++ lib.optional (!stdenv.isDarwin) patchelf;

  propagatedNativeBuildInputs = [ lndir ];

  outputs = [ "bin" "dev" "out" ];

  inherit patches;

  fix_qt_builtin_paths = ../hooks/fix-qt-builtin-paths.sh;
  fix_qt_module_paths = ../hooks/fix-qt-module-paths.sh;
  preHook = ''
    . "$fix_qt_builtin_paths"
    . "$fix_qt_module_paths"
    . ${../hooks/move-qt-dev-tools.sh}
  '';

  postPatch =
    ''
      for prf in qml_plugin.prf qt_plugin.prf qt_docs.prf qml_module.prf create_cmake.prf; do
          substituteInPlace "mkspecs/features/$prf" \
              --subst-var qtPluginPrefix \
              --subst-var qtQmlPrefix \
              --subst-var qtDocPrefix
      done

      substituteInPlace configure --replace /bin/pwd pwd
      substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
      sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i mkspecs/*/*.conf

      sed -i '/PATHS.*NO_DEFAULT_PATH/ d' src/corelib/Qt5Config.cmake.in
      sed -i '/PATHS.*NO_DEFAULT_PATH/ d' src/corelib/Qt5CoreMacros.cmake
      sed -i 's/NO_DEFAULT_PATH//' src/gui/Qt5GuiConfigExtras.cmake.in
      sed -i '/PATHS.*NO_DEFAULT_PATH/ d' mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in
    ''

    + (
      if stdenv.isDarwin
      then
        ''
          sed -i \
              -e 's|! /usr/bin/xcode-select --print-path >/dev/null 2>&1;|false;|' \
              -e 's|! /usr/bin/xcrun -find xcodebuild >/dev/null 2>&1;|false;|' \
              -e 's|sysroot=$(/usr/bin/xcodebuild -sdk $sdk -version Path 2>/dev/null)|sysroot=/nonsense|' \
              -e 's|sysroot=$(/usr/bin/xcrun --sdk $sdk --show-sdk-path 2>/dev/null)|sysroot=/nonsense|' \
              -e 's|QMAKE_CONF_COMPILER=`getXQMakeConf QMAKE_CXX`|QMAKE_CXX="clang++"\nQMAKE_CONF_COMPILER="clang++"|' \
              -e 's|XCRUN=`/usr/bin/xcrun -sdk macosx clang -v 2>&1`|XCRUN="clang -v 2>&1"|' \
              -e 's#sdk_val=$(/usr/bin/xcrun -sdk $sdk -find $(echo $val | cut -d \x27 \x27 -f 1))##' \
              -e 's#val=$(echo $sdk_val $(echo $val | cut -s -d \x27 \x27 -f 2-))##' \
              ./configure
              substituteInPlace ./mkspecs/common/mac.conf \
                  --replace "/System/Library/Frameworks/OpenGL.framework/" "${darwin.apple_sdk.frameworks.OpenGL}/Library/Frameworks/OpenGL.framework/"
              substituteInPlace ./mkspecs/common/mac.conf \
                  --replace "/System/Library/Frameworks/AGL.framework/" "${darwin.apple_sdk.frameworks.AGL}/Library/Frameworks/AGL.framework/"
        ''
        # Note on the above: \x27 is a way if including a single-quote
        # character in the sed string arguments.
      else
        lib.optionalString libGLSupported
          ''
            sed -i mkspecs/common/linux.conf \
                -e "/^QMAKE_INCDIR_OPENGL/ s|$|${libGL.dev or libGL}/include|" \
                -e "/^QMAKE_LIBDIR_OPENGL/ s|$|${libGL.out}/lib|"
          ''
    );

  qtPluginPrefix = "lib/qt-${qtCompatVersion}/plugins";
  qtQmlPrefix = "lib/qt-${qtCompatVersion}/qml";
  qtDocPrefix = "share/doc/qt-${qtCompatVersion}";

  setOutputFlags = false;
  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/lib:$PWD/plugins/platforms:$LD_LIBRARY_PATH"
    ${lib.optionalString (compareVersion "5.9.0" < 0) ''
    # We need to set LD to CXX or otherwise we get nasty compile errors
    export LD=$CXX
    ''}

    configureFlags+="\
        -plugindir $out/$qtPluginPrefix \
        -qmldir $out/$qtQmlPrefix \
        -docdir $out/$qtDocPrefix"

    createQmakeCache() {
        cat >>"$1" <<EOF
    NIX_OUTPUT_BIN = $bin
    NIX_OUTPUT_DEV = $dev
    NIX_OUTPUT_OUT = $out
    NIX_OUTPUT_DOC = $dev/$qtDocPrefix
    NIX_OUTPUT_QML = $bin/$qtQmlPrefix
    NIX_OUTPUT_PLUGIN = $bin/$qtPluginPrefix
    EOF
    }

    find . -name '.qmake.conf' | while read conf; do
        cache=$(dirname $conf)/.qmake.cache
        echo "Creating \`$cache'"
        createQmakeCache "$cache"
    done

    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QT_PLUGIN_PREFIX=\"$qtPluginPrefix\""
  '';


  NIX_CFLAGS_COMPILE =
    [
      "-Wno-error=sign-compare" # freetype-2.5.4 changed signedness of some struct fields
      ''-DNIXPKGS_QTCOMPOSE="${libX11.out}/share/X11/locale"''
      ''-DNIXPKGS_LIBRESOLV="${stdenv.cc.libc.out}/lib/libresolv"''
      ''-DNIXPKGS_LIBXCURSOR="${libXcursor.out}/lib/libXcursor"''
    ]

    ++ (
      if stdenv.isDarwin
      then
        [
          "-Wno-missing-sysroot"
          "-D__MAC_OS_X_VERSION_MAX_ALLOWED=1090"
          "-D__AVAILABILITY_INTERNAL__MAC_10_10=__attribute__((availability(macosx,introduced=10.10)))"
          # Note that nixpkgs's objc4 is from macOS 10.11 while the SDK is
          # 10.9 which necessitates the above macro definition that mentions
          # 10.10
        ]
      else
        lib.optional libGLSupported ''-DNIXPKGS_MESA_GL="${libGL.out}/lib/libGL"''
        ++ lib.optionals withGtk3
          [
            ''-DNIXPKGS_QGTK3_XDG_DATA_DIRS="${gtk3}/share/gsettings-schemas/${gtk3.name}"''
            ''-DNIXPKGS_QGTK3_GIO_EXTRA_MODULES="${dconf.lib}/lib/gio/modules"''
          ]
    )

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

      "-gui"
      "-widgets"
      "-opengl desktop"
      "-qml-debug"
      "-icu"
      "-pch"
    ]
    ++ lib.optionals (compareVersion "5.9.0" < 0)
    [
      "-c++11"
      "-no-reduce-relocations"
    ]
    ++ lib.optionals developerBuild [
      "-developer-build"
      "-no-warnings-are-errors"
    ]
    ++ (
      if (!system-x86_64)
      then [ "-no-sse2" ]
      else lib.optional (compareVersion "5.9.0" >= 0) [ "-sse2" ]
    )
    ++ [
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
      ''-${lib.optionalString (!buildExamples) "no"}make examples''
      ''-${lib.optionalString (!buildTests) "no"}make tests''
      "-v"
    ]

    ++ (
      if stdenv.isDarwin
      then
        [
          "-platform macx-clang"
          "-no-use-gold-linker"
          "-no-fontconfig"
          "-qt-freetype"
          "-qt-libpng"
        ]
      else
        [
          "-${lib.optionalString (compareVersion "5.9.0" < 0) "no-"}rpath"

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
          "-system-libjpeg"
          "-system-libpng"
          # gold linker of binutils 2.28 generates duplicate symbols
          # TODO: remove for newer version of binutils
          "-no-use-gold-linker"
        ]
        ++ lib.optional withGtk3 "-gtk"
        ++ lib.optional (compareVersion "5.9.0" >= 0) "-inotify"
    );

  enableParallelBuilding = true;

  postInstall =
    # Move selected outputs.
    ''
      moveToOutput "mkspecs" "$dev"
    '';

  devTools = [
    "bin/fixqt4headers.pl"
    "bin/moc"
    "bin/qdbuscpp2xml"
    "bin/qdbusxml2cpp"
    "bin/qlalr"
    "bin/qmake"
    "bin/rcc"
    "bin/syncqt.pl"
    "bin/uic"
  ];

  postFixup =
    # Don't retain build-time dependencies like gdb.
    ''
      sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri
    ''

    + ''
      fixQtModulePaths "''${!outputDev}/mkspecs/modules"
      fixQtBuiltinPaths "''${!outputDev}" '*.pr?'
    ''

    # Move development tools to $dev
    + ''
      moveQtDevTools
      moveToOutput bin "$dev"
    ''

    + (
      if stdenv.isDarwin
      then
        ''
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
        ''
      else
        # fixup .pc file (where to find 'moc' etc.)
        ''
          sed -i "$dev/lib/pkgconfig/Qt5Core.pc" \
              -e "/^host_bins=/ c host_bins=$dev/bin"
        ''
    );

  setupHook = ../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = http://www.qt.io;
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ qknight ttuegel periklis ];
    platforms = platforms.unix;
  };

}
