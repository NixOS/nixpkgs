{ stdenv, lib
, src, patches, version, qtCompatVersion

, coreutils, bison, flex, gdb, gperf, lndir, perl, pkg-config, python3
, which
  # darwin support
, libiconv, libobjc, xcbuild, AGL, AppKit, ApplicationServices, AVFoundation, Carbon, Cocoa, CoreAudio, CoreBluetooth
, CoreLocation, CoreServices, DiskArbitration, Foundation, OpenGL, MetalKit, IOKit

, dbus, fontconfig, freetype, glib, harfbuzz, icu, libdrm, libX11, libXcomposite
, libXcursor, libXext, libXi, libXrender, libinput, libjpeg, libpng , libxcb
, libxkbcommon, libxml2, libxslt, openssl, pcre16, pcre2, sqlite, udev, xcbutil
, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, xcbutilwm , zlib, at-spi2-core

  # optional dependencies
, cups ? null, libmysqlclient ? null, postgresql ? null
, withGtk3 ? false, dconf, gtk3

  # options
, libGLSupported ? !stdenv.isDarwin
, libGL
, buildExamples ? false
, buildTests ? false
, debug ? false
, developerBuild ? false
, decryptSslTraffic ? false
}:

let
  compareVersion = v: builtins.compareVersions version v;
  qmakeCacheName = if compareVersion "5.12.4" < 0 then ".qmake.cache" else ".qmake.stash";
  debugSymbols = debug || developerBuild;
in

stdenv.mkDerivation {
  pname = "qtbase";
  inherit qtCompatVersion src version;
  debug = debugSymbols;

  propagatedBuildInputs = [
    libxml2 libxslt openssl sqlite zlib

    # Text rendering
    harfbuzz icu

    # Image formats
    libjpeg libpng
    (if compareVersion "5.9.0" < 0 then pcre16 else pcre2)
  ] ++ (
    if stdenv.isDarwin then [
      # TODO: move to buildInputs, this should not be propagated.
      AGL AppKit ApplicationServices AVFoundation Carbon Cocoa CoreAudio CoreBluetooth
      CoreLocation CoreServices DiskArbitration Foundation OpenGL
      libobjc libiconv MetalKit IOKit
    ] else [
      dbus glib udev

      # Text rendering
      fontconfig freetype

      libdrm

      # X11 libs
      libX11 libXcomposite libXext libXi libXrender libxcb libxkbcommon xcbutil
      xcbutilimage xcbutilkeysyms xcbutilrenderutil xcbutilwm
    ] ++ lib.optional libGLSupported libGL
  );

  buildInputs = [ python3 at-spi2-core ]
    ++ lib.optionals (!stdenv.isDarwin)
    (
      [ libinput ]
      ++ lib.optional withGtk3 gtk3
    )
    ++ lib.optional developerBuild gdb
    ++ lib.optional (cups != null) cups
    ++ lib.optional (libmysqlclient != null) libmysqlclient
    ++ lib.optional (postgresql != null) postgresql;

  nativeBuildInputs = [ bison flex gperf lndir perl pkg-config which ]
    ++ lib.optionals stdenv.isDarwin [ xcbuild ];

  propagatedNativeBuildInputs = [ lndir ];

  enableParallelBuilding = true;

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

  postPatch = ''
    substituteInPlace src/gui/kernel/qguiapplication.cpp \
        --replace 'qgetenv("QT_QPA_PLATFORM_PLUGIN_PATH")' 'QByteArrayLiteral("@bin@/@qtPluginPrefix@/platforms")' \
        --subst-var qtPluginPrefix \
        --subst-var bin
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

    # https://bugs.gentoo.org/803470
    sed -i 's/-lpthread/-pthread/' mkspecs/common/linux.conf src/corelib/configure.json
  '' + lib.optionalString (compareVersion "5.15.0" >= 0) ''
    patchShebangs ./bin
  '' + (
    if stdenv.isDarwin then ''
        sed -i \
            -e 's|/usr/bin/xcode-select|xcode-select|' \
            -e 's|/usr/bin/xcrun|xcrun|' \
            -e 's|/usr/bin/xcodebuild|xcodebuild|' \
            -e 's|QMAKE_CONF_COMPILER=`getXQMakeConf QMAKE_CXX`|QMAKE_CXX="clang++"\nQMAKE_CONF_COMPILER="clang++"|' \
            ./configure
            substituteInPlace ./mkspecs/common/mac.conf \
                --replace "/System/Library/Frameworks/OpenGL.framework/" "${OpenGL}/Library/Frameworks/OpenGL.framework/" \
                --replace "/System/Library/Frameworks/AGL.framework/" "${AGL}/Library/Frameworks/AGL.framework/"
    '' else lib.optionalString libGLSupported ''
      sed -i mkspecs/common/linux.conf \
          -e "/^QMAKE_INCDIR_OPENGL/ s|$|${libGL.dev or libGL}/include|" \
          -e "/^QMAKE_LIBDIR_OPENGL/ s|$|${libGL.out}/lib|"
    '' + lib.optionalString (stdenv.hostPlatform.isx86_32 && stdenv.cc.isGNU) ''
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

    # paralellize compilation of qtmake, which happens within ./configure
    export MAKEFLAGS+=" -j$NIX_BUILD_CORES"
  '' + lib.optionalString (compareVersion "5.15.0" >= 0) ''
    ./bin/syncqt.pl -version $version
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
    ++ lib.optional stdenv.isLinux "-DUSE_X11"
    ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-darwin") [
      # ignore "is only available on macOS 10.12.2 or newer" in obj-c code
      "-Wno-error=unguarded-availability"
    ]
    ++ lib.optionals ((compareVersion "5.15.0" >= 0) && stdenv.isDarwin) [
      # .moc/moc_qprintdialog.cpp:96:31: error: no member named '_q_togglePageSetCombo' in 'QPrintDialogPrivate'
      "-DQ_OS_MAC"
    ] ++ lib.optionals withGtk3 [
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
  configureFlags = [
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
  ] ++ lib.optional debugSymbols "-debug"
    ++ lib.optionals (compareVersion "5.11.0" < 0) [
    "-qml-debug"
  ] ++ lib.optionals (compareVersion "5.9.0" < 0) [
    "-c++11"
    "-no-reduce-relocations"
  ] ++ lib.optionals developerBuild [
    "-developer-build"
    "-no-warnings-are-errors"
  ] ++ (if (!stdenv.hostPlatform.isx86_64) then [
    "-no-sse2"
  ] else lib.optionals (compareVersion "5.9.0" >= 0) [
    "-sse2"
    "${lib.optionalString (!stdenv.hostPlatform.sse3Support)   "-no"}-sse3"
    "${lib.optionalString (!stdenv.hostPlatform.ssse3Support)  "-no"}-ssse3"
    "${lib.optionalString (!stdenv.hostPlatform.sse4_1Support) "-no"}-sse4.1"
    "${lib.optionalString (!stdenv.hostPlatform.sse4_2Support) "-no"}-sse4.2"
    "${lib.optionalString (!stdenv.hostPlatform.avxSupport)    "-no"}-avx"
    "${lib.optionalString (!stdenv.hostPlatform.avx2Support)   "-no"}-avx2"
    ]
  ) ++ [
    "-no-mips_dsp"
    "-no-mips_dspr2"
  ] ++ [
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
    "-L" "${lib.getLib openssl}/lib"
    "-I" "${openssl.dev}/include"
    "-system-sqlite"
    ''-${if libmysqlclient != null then "plugin" else "no"}-sql-mysql''
    ''-${if postgresql != null then "plugin" else "no"}-sql-psql''

    "-make libs"
    "-make tools"
    ''-${lib.optionalString (!buildExamples) "no"}make examples''
    ''-${lib.optionalString (!buildTests) "no"}make tests''
  ] ++ lib.optional (compareVersion "5.15.0" < 0) "-v"
    ++ (
      if stdenv.isDarwin then [
      "-no-fontconfig"
      "-qt-freetype"
      "-qt-libpng"
      "-no-framework"
    ] else [
      "-${lib.optionalString (compareVersion "5.9.0" < 0) "no-"}rpath"
    ] ++ lib.optional (compareVersion "5.15.0" < 0) "-system-xcb"
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
    ] ++ lib.optional (compareVersion "5.15.0" < 0) "-system-libjpeg"
      ++ [
      "-system-libpng"
    ] ++ lib.optional withGtk3 "-gtk"
      ++ lib.optional (compareVersion "5.9.0" >= 0) "-inotify"
      ++ lib.optionals (compareVersion "5.10.0" >= 0) [
      # Without these, Qt stops working on kernels < 3.17. See:
      # https://github.com/NixOS/nixpkgs/issues/38832
      "-no-feature-renameat2"
      "-no-feature-getentropy"
    ] ++ lib.optionals (compareVersion "5.12.1" < 0) [
      # use -xkbcommon and -xkbcommon-evdev for versions before 5.12.1
      "-system-xkbcommon"
      "-xkbcommon-evdev"
    ] ++ lib.optionals (cups != null) [
      "-L" "${cups.lib}/lib"
      "-I" "${cups.dev}/include"
    ] ++ lib.optionals (libmysqlclient != null) [
      "-L" "${libmysqlclient}/lib"
      "-I" "${libmysqlclient}/include"
    ]
  );

  # Move selected outputs.
  postInstall = ''
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

  postFixup = ''
    # Don't retain build-time dependencies like gdb.
    sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri
    fixQtModulePaths "''${!outputDev}/mkspecs/modules"
    fixQtBuiltinPaths "''${!outputDev}" '*.pr?'

    # Move development tools to $dev
    moveQtDevTools
    moveToOutput bin "$dev"

    # fixup .pc file (where to find 'moc' etc.)
    sed -i "$dev/lib/pkgconfig/Qt5Core.pc" \
      -e "/^host_bins=/ c host_bins=$dev/bin"
  '';

  dontStrip = debugSymbols;

  setupHook = ../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13Plus gpl2Plus lgpl21Plus lgpl3Plus ];
    maintainers = with maintainers; [ qknight ttuegel periklis bkchr ];
    platforms = platforms.unix;
    # Qt5 is broken on aarch64-darwin
    # the build ends up with the following error:
    #   error: unknown target CPU 'armv8.3-a+crypto+sha2+aes+crc+fp16+lse+simd+ras+rdm+rcpc'
    #   note: valid target CPU values are: nocona, core2, penryn, ..., znver1, znver2, x86-64
    # it seems the qmake/cmake passes x86_64 as preferred architecture somewhere
    broken = stdenv.isDarwin && stdenv.isAarch64 && (compareVersion "5.15.3" < 0);
  };

}
