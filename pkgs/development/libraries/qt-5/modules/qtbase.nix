{
  stdenv, lib,
  src, patches, version, qtCompatVersion,

  coreutils, bison, flex, gdb, gperf, lndir, perl, pkg-config, python3,
  which,
  # darwin support
  darwin, libiconv,

  dbus, fontconfig, freetype, glib, harfbuzz, icu, libX11, libXcomposite,
  libXcursor, libXext, libXi, libXrender, libinput, libjpeg, libpng,
  libxcb, libxkbcommon, libxml2, libxslt, openssl, pcre16, pcre2, sqlite, udev,
  xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, xcbutilwm,
  zlib,

  # optional dependencies
  cups ? null, libmysqlclient ? null, postgresql ? null,
  withGtk3 ? false, dconf ? null, gtk3 ? null,

  # options
  libGLSupported ? !stdenv.isDarwin,
  libGL,
  buildExamples ? false,
  buildTests ? false,
  debug ? false,
  developerBuild ? false,
  decryptSslTraffic ? false
}:

assert withGtk3 -> dconf != null;
assert withGtk3 -> gtk3 != null;

let
  compareVersion = v: builtins.compareVersions version v;
  qmakeCacheName =
    if compareVersion "5.12.4" < 0 then ".qmake.cache" else ".qmake.stash";
  debugSymbols = debug || developerBuild;
in

stdenv.mkDerivation {

  name = "qtbase-${version}";
  inherit qtCompatVersion src version;
  debug = debugSymbols;

  propagatedBuildInputs =
    [
      libxml2 libxslt openssl sqlite zlib

      # Text rendering
      harfbuzz icu

      # Image formats
      libjpeg libpng
      (if compareVersion "5.9.0" < 0 then pcre16 else pcre2)
    ]
    ++ (
      if stdenv.isDarwin
      then with darwin.apple_sdk.frameworks;
        [
          # TODO: move to buildInputs, this should not be propagated.
          AGL AppKit ApplicationServices Carbon Cocoa CoreAudio CoreBluetooth
          CoreLocation CoreServices DiskArbitration Foundation OpenGL
          darwin.libobjc libiconv MetalKit IOKit
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
    [ python3 ]
    ++ lib.optionals (!stdenv.isDarwin)
    (
      [ libinput ]
      ++ lib.optional withGtk3 gtk3
    )
    ++ lib.optional developerBuild gdb
    ++ lib.optional (cups != null) cups
    ++ lib.optional (libmysqlclient != null) libmysqlclient
    ++ lib.optional (postgresql != null) postgresql;

  nativeBuildInputs =
    [ bison flex gperf lndir perl pkg-config which ];

  propagatedNativeBuildInputs = [ lndir ];

  outputs = [ "bin" "dev" "out" ];

  inherit patches;

  fix_qt_builtin_paths = ../hooks/fix-qt-builtin-paths.sh;
  fix_qt_module_paths = ../hooks/fix-qt-module-paths.sh;
  preHook = ''
    . "$fix_qt_builtin_paths"
    . "$fix_qt_module_paths"
    . ${../hooks/move-qt-dev-tools.sh}
    . ${../hooks/fix-qmake-libtool.sh}
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
          '' +
        lib.optionalString (stdenv.hostPlatform.isx86_32 && stdenv.cc.isGNU)
          ''
            sed -i mkspecs/common/gcc-base-unix.conf \
                -e "/^QMAKE_LFLAGS_SHLIB/ s/-shared/-shared -static-libgcc/"
          ''
    );

  qtPluginPrefix = "lib/qt-${qtCompatVersion}/plugins";
  qtQmlPrefix = "lib/qt-${qtCompatVersion}/qml";
  qtDocPrefix = "share/doc/qt-${qtCompatVersion}";

  setOutputFlags = false;
  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/lib:$PWD/plugins/platforms''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    ${lib.optionalString (compareVersion "5.9.0" < 0) ''
    # We need to set LD to CXX or otherwise we get nasty compile errors
    export LD=$CXX
    ''}

    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QT_PLUGIN_PREFIX=\"$qtPluginPrefix\""
  '';

  postConfigure = ''
    qmakeCacheInjectNixOutputs() {
        local cache="$1/${qmakeCacheName}"
        echo "qmakeCacheInjectNixOutputs: $cache"
        if ! [ -f "$cache" ]; then
            echo >&2 "qmakeCacheInjectNixOutputs: WARNING: $cache does not exist"
        fi
        cat >>"$cache" <<EOF
    NIX_OUTPUT_BIN = $bin
    NIX_OUTPUT_DEV = $dev
    NIX_OUTPUT_OUT = $out
    NIX_OUTPUT_DOC = $dev/$qtDocPrefix
    NIX_OUTPUT_QML = $bin/$qtQmlPrefix
    NIX_OUTPUT_PLUGIN = $bin/$qtPluginPrefix
    EOF
    }

    find . -name '.qmake.conf' | while read conf; do
        qmakeCacheInjectNixOutputs "$(dirname $conf)"
    done
  '';

  NIX_CFLAGS_COMPILE = toString ([
    "-Wno-error=sign-compare" # freetype-2.5.4 changed signedness of some struct fields
    ''-DNIXPKGS_QTCOMPOSE="${libX11.out}/share/X11/locale"''
    ''-D${if compareVersion "5.11.0" >= 0 then "LIBRESOLV_SO" else "NIXPKGS_LIBRESOLV"}="${stdenv.cc.libc.out}/lib/libresolv"''
    ''-DNIXPKGS_LIBXCURSOR="${libXcursor.out}/lib/libXcursor"''
  ] ++ lib.optional libGLSupported ''-DNIXPKGS_MESA_GL="${libGL.out}/lib/libGL"''
    ++ lib.optionals withGtk3 [
         ''-DNIXPKGS_QGTK3_XDG_DATA_DIRS="${gtk3}/share/gsettings-schemas/${gtk3.name}"''
         ''-DNIXPKGS_QGTK3_GIO_EXTRA_MODULES="${dconf.lib}/lib/gio/modules"''
       ]
    ++ lib.optional decryptSslTraffic "-DQT_DECRYPT_SSL_TRAFFIC");

  prefixKey = "-prefix ";

  # PostgreSQL autodetection fails sporadically because Qt omits the "-lpq" flag
  # if dependency paths contain the string "pq", which can occur in the hash.
  # To prevent these failures, we need to override PostgreSQL detection.
  PSQL_LIBS = lib.optionalString (postgresql != null) "-L${postgresql.lib}/lib -lpq";

  # TODO Remove obsolete and useless flags once the build will be totally mastered
  configureFlags =
    [
      "-plugindir $(out)/$(qtPluginPrefix)"
      "-qmldir $(out)/$(qtQmlPrefix)"
      "-docdir $(out)/$(qtDocPrefix)"

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
      "-icu"
      "-L" "${icu.out}/lib"
      "-I" "${icu.dev}/include"
      "-pch"
    ]
    ++ lib.optional debugSymbols "-debug"
    ++ lib.optionals (compareVersion "5.11.0" < 0)
    [
      "-qml-debug"
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
      if (!stdenv.hostPlatform.isx86_64) then [
        "-no-sse2"
      ] else if (compareVersion "5.9.0" >= 0) then [
        "-sse2"
        "${if stdenv.hostPlatform.sse3Support   then "" else "-no"}-sse3"
        "${if stdenv.hostPlatform.ssse3Support  then "" else "-no"}-ssse3"
        "${if stdenv.hostPlatform.sse4_1Support then "" else "-no"}-sse4.1"
        "${if stdenv.hostPlatform.sse4_2Support then "" else "-no"}-sse4.2"
        "${if stdenv.hostPlatform.avxSupport    then "" else "-no"}-avx"
        "${if stdenv.hostPlatform.avx2Support   then "" else "-no"}-avx2"
      ] else [
      ]
    )
    ++ [
      "-no-mips_dsp"
      "-no-mips_dspr2"
    ]

    ++ [
      "-system-zlib"
      "-L" "${zlib.out}/lib"
      "-I" "${zlib.dev}/include"
      "-system-libjpeg"
      "-L" "${libjpeg.out}/lib"
      "-I" "${libjpeg.dev}/include"
      "-system-harfbuzz"
      "-L" "${harfbuzz.out}/lib"
      "-I" "${harfbuzz.dev}/include"
      "-system-pcre"
      "-openssl-linked"
      "-L" "${openssl.out}/lib"
      "-I" "${openssl.dev}/include"
      "-system-sqlite"
      ''-${if libmysqlclient != null then "plugin" else "no"}-sql-mysql''
      ''-${if postgresql != null then "plugin" else "no"}-sql-psql''

      "-make libs"
      "-make tools"
      ''-${lib.optionalString (!buildExamples) "no"}make examples''
      ''-${lib.optionalString (!buildTests) "no"}make tests''
    ]
    ++ lib.optional (compareVersion "5.15.0" < 0) "-v"

    ++ (
      if stdenv.isDarwin
      then
        [
          "-platform macx-clang"
          "-no-fontconfig"
          "-qt-freetype"
          "-qt-libpng"
          "-no-framework"
        ]
      else
        [
          "-${lib.optionalString (compareVersion "5.9.0" < 0) "no-"}rpath"
        ]
        ++ lib.optional (compareVersion "5.15.0" < 0) "-system-xcb"
        ++ [
          "-xcb"
          "-qpa xcb"
          "-L" "${libX11.out}/lib"
          "-I" "${libX11.out}/include"
          "-L" "${libXext.out}/lib"
          "-I" "${libXext.out}/include"
          "-L" "${libXrender.out}/lib"
          "-I" "${libXrender.out}/include"

          "-libinput"

          ''-${lib.optionalString (cups == null) "no-"}cups''
          "-dbus-linked"
          "-glib"
        ]
        ++ lib.optional (compareVersion "5.15.0" < 0) "-system-libjpeg"
        ++ [
          "-system-libpng"
        ]
        ++ lib.optional withGtk3 "-gtk"
        ++ lib.optional (compareVersion "5.9.0" >= 0) "-inotify"
        ++ lib.optionals (compareVersion "5.10.0" >= 0) [
          # Without these, Qt stops working on kernels < 3.17. See:
          # https://github.com/NixOS/nixpkgs/issues/38832
          "-no-feature-renameat2"
          "-no-feature-getentropy"
        ]
        ++ lib.optionals (compareVersion "5.12.1" < 0) [
          # use -xkbcommon and -xkbcommon-evdev for versions before 5.12.1
          "-system-xkbcommon"
          "-xkbcommon-evdev"
        ]
        ++ lib.optionals (cups != null) [
          "-L" "${cups.lib}/lib"
          "-I" "${cups.dev}/include"
        ]
        ++ lib.optionals (libmysqlclient != null) [
          "-L" "${libmysqlclient}/lib"
          "-I" "${libmysqlclient}/include"
        ]
    );

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

    # fixup .pc file (where to find 'moc' etc.)
    + ''
      sed -i "$dev/lib/pkgconfig/Qt5Core.pc" \
          -e "/^host_bins=/ c host_bins=$dev/bin"
    '';

  dontStrip = debugSymbols;

  setupHook = ../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = "http://www.qt.io";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ qknight ttuegel periklis bkchr ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin && (compareVersion "5.9.0" < 0);
  };

}
