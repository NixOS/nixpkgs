{ stdenv, lib
, src, patches, version, qtCompatVersion

, coreutils, bison, flex, gdb, gperf, lndir, perl, pkg-config, python3
, which
  # darwin support
, libiconv, libobjc, xcbuild, AGL, AppKit, ApplicationServices, Carbon, Cocoa, CoreAudio, CoreBluetooth
, CoreLocation, CoreServices, DiskArbitration, Foundation, OpenGL, MetalKit, IOKit

, dbus, fontconfig, freetype, glib, harfbuzz, icu, libX11, libXcomposite
, libXcursor, libXext, libXi, libXrender, libinput, libjpeg, libpng
, libxcb, libxkbcommon, libxml2, libxslt, openssl, pcre16, pcre2, sqlite, udev
, xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, xcbutilwm
, zlib, libglvnd, llvmPackages_10

  # optional dependencies
, cups ? null, libmysqlclient ? null, postgresql ? null
, withGtk3 ? false, dconf ? null, gtk3 ? null

  # options
, libGLSupported ? !stdenv.isDarwin
, libGL
, buildExamples ? false
, buildTests ? false
, debug ? false
, developerBuild ? false
, decryptSslTraffic ? false
}:

assert withGtk3 -> dconf != null;
assert withGtk3 -> gtk3 != null;

let
  compareVersion = v: builtins.compareVersions version v;
  qmakeCacheName = if compareVersion "5.12.4" < 0 then ".qmake.cache" else ".qmake.stash";
  debugSymbols = debug || developerBuild;

  libcxxIncDir = "${llvmPackages_10.libcxx.dev}/include/c++/v1";
  libcxxLibDir = "${llvmPackages_10.libcxx.out}/lib";
  clangCxxFlags = "-nostdinc++ -isystem ${libcxxIncDir}";
  clangCxxLdflags = "-nostdlib++ -L ${libcxxIncDir} -Wl,-rpath,${libcxxLibDir} -lc++ -lc++abi";

  # Building with libc++ implies that all statically linked c++ deps are also
  # linked with it.
  icuFixed = if !stdenv.hostPlatform.isStatic then icu else
  (icu.override { stdenv = llvmPackages_10.stdenv; })
  .overrideAttrs (old: {
    preConfigure = ''
      export CC=${llvmPackages_10.stdenv.cc.targetPrefix}cc
      export CXX=${llvmPackages_10.stdenv.cc.targetPrefix}c++
      export CXXFLAGS="${clangCxxFlags}"
      export LDFLAGS="${clangCxxLdflags}"
    '';
    buildInputs = (old.buildInputs or []) ++ (with llvmPackages_10; [
      libcxx
      libcxxabi
    ]);
    NIX_LDFLAGS = " -lc++ -lc++abi";
  });

stage1 = llvmPackages_10.stdenv.mkDerivation ({
  pname = "qtbase";
  inherit qtCompatVersion src version;
  debug = debugSymbols;

  buildInputs = [
    python3
    libxml2 libxslt openssl sqlite zlib

    # Text rendering
    harfbuzz icuFixed

    # Image formats
    libjpeg libpng
    (if compareVersion "5.9.0" < 0 then pcre16 else pcre2)
  ] ++ (
    if stdenv.isDarwin then [
      # TODO: move to buildInputs, this should not be propagated.
      AGL AppKit ApplicationServices Carbon Cocoa CoreAudio CoreBluetooth
      CoreLocation CoreServices DiskArbitration Foundation OpenGL
      libobjc libiconv MetalKit IOKit
    ] else ([
      libinput
      dbus glib udev

      # Text rendering
      fontconfig freetype

      # X11 libs
      libX11 libXcomposite libXext libXi libXrender libxcb libxkbcommon xcbutil
      xcbutilimage xcbutilkeysyms xcbutilrenderutil xcbutilwm
    ] ++ lib.optional withGtk3 gtk3)
      ++ lib.optional libGLSupported libGL
    )
    ++ lib.optional developerBuild gdb
    ++ lib.optional (cups != null) cups
    ++ lib.optional (libmysqlclient != null) libmysqlclient
    ++ lib.optional (postgresql != null) postgresql
    ++ lib.optionals (stdenv.hostPlatform.isStatic) [
      llvmPackages_10.libcxx
      llvmPackages_10.libcxxabi
    ];

  nativeBuildInputs = [ bison flex gperf lndir perl pkg-config which ]
    ++ lib.optionals stdenv.isDarwin [ xcbuild ];

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

  postPatch = ''
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
  '' + lib.optionalString stdenv.hostPlatform.isStatic ''
    sed -iE 's/^QMAKE_COMPILER.*/QMAKE_COMPILER = cc/g' mkspecs/common/g++-base.conf
    sed -iE 's!^QMAKE_CC.*!QMAKE_CC = ${llvmPackages_10.stdenv.cc}/bin/${llvmPackages_10.stdenv.cc.targetPrefix}cc!g' mkspecs/common/clang.conf
    sed -iE 's!^QMAKE_CXX.*!QMAKE_CXX = ${llvmPackages_10.stdenv.cc}/bin/${llvmPackages_10.stdenv.cc.targetPrefix}c++!g' mkspecs/common/clang.conf
    sed -iE 's!^QMAKE_AR.*!QMAKE_AR = ${llvmPackages_10.stdenv.cc.targetPrefix}ar cqs!g' mkspecs/common/linux.conf
    substituteInPlace .qmake.conf \
      --replace 'CONFIG += warning_clean' \
                'CONFIG += warning_clean c++11'

    sed -iE 's!^QMAKE_CXXFLAGS.*!QMAKE_CXXFLAGS += ${clangCxxFlags}!g'\
      mkspecs/linux-clang-libc++/qmake.conf
    sed -iE 's!^QMAKE_LFLAGS.*!QMAKE_LFLAGS += ${clangCxxLdflags}!g'\
      mkspecs/linux-clang-libc++/qmake.conf

    sed -iE 's!^#define QT_SOCKLEN_T.*int!#define QT_SOCKLEN_T socklen_t!g' \
      mkspecs/linux-clang/qplatformdefs.h
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
    lib.optional stdenv.hostPlatform.isStatic "-static"
  ++ [
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
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    "-I" "${libglvnd.dev}/include"
  ] ++
  [
    "-icu"
    "-L" "${icuFixed.out}/lib"
    "-I" "${icuFixed.dev}/include"
  ] ++ lib.optional debugSymbols "-debug"
    ++ lib.optional (!stdenv.hostPlatform.isStatic) "-pch"
    ++ lib.optional (compareVersion "5.11.0" < 0) "-qml-debug"
    ++ lib.optionals (compareVersion "5.9.0" < 0) [
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
    "-L" "${openssl.out}/lib"
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
      "-platform macx-clang"
      "-no-fontconfig"
      "-qt-freetype"
      "-qt-libpng"
      "-no-framework"
    ] else [
      "-${lib.optionalString (stdenv.hostPlatform.isStatic || compareVersion "5.9.0" < 0) "no-"}rpath"
    ] ++ lib.optional (compareVersion "5.15.0" < 0) "-system-xcb"
      ++ [
      "-xcb"
    ] ++
    lib.optionals (stdenv.hostPlatform.isStatic) [
      "-platform linux-clang-libc++"
      "-feature-std-atomic64"
      "-L" "${libxcb.out}/lib"
      "-I" "${libxcb.dev}/include"
    ] ++ [
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
    ] ++ lib.optionals (libmysqlclient != null)
    (if stdenv.hostPlatform.isStatic then [
      "-L" "${libmysqlclient.out}/lib/mysql"
      "-I" "${libmysqlclient.dev}/include/mysql"
    ] else [
      "-L" "${libmysqlclient}/lib"
      "-I" "${libmysqlclient}/include"
    ])
  );

  postInstall = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
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

  postFixup = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    # Don't retain build-time dependencies like gdb.
    sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri
    fixQtModulePaths "''${!outputDev}/mkspecs/modules"
    fixQtBuiltinPaths "''${!outputDev}" '*.pr?'

    # Move development tools to $dev
    moveQtDevTools
    moveToOutput bin "$dev"

  '' + ''
    # fixup .pc file (where to find 'moc' etc.)
    sed -i "$dev/lib/pkgconfig/Qt5Core.pc" \
      -e "/^host_bins=/ c host_bins=$dev/bin"
  '';

  dontStrip = debugSymbols;

  setupHook = ../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ qknight ttuegel periklis bkchr ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin && (compareVersion "5.9.0" < 0);
  };

} // lib.optionalAttrs stdenv.hostPlatform.isStatic {
  configurePlatforms = [];
  NIX_LDFLAGS = " -lc++ -lc++abi";
});
# The postInstall and postFixup don't seem to work
# for the static build and considering the build time
# it's just easier to separate the build from the fixup
# and do/tweak it in a second/final stage.
in if (!stdenv.hostPlatform.isStatic) then stage1 else (stdenv.mkDerivation {
  pname = "qtbase-final";
  inherit version;

  outputs = [ "bin" "dev" "out" ];
  dontUnpack = true;

  buildPhase = "";

  nativeBuildInputs = [ lndir ];

  fix_qt_builtin_paths = ../hooks/fix-qt-builtin-paths.sh;
  fix_qt_module_paths = ../hooks/fix-qt-module-paths.sh;
  preHook = ''
    . "$fix_qt_builtin_paths"
    . "$fix_qt_module_paths"
    . ${../hooks/move-qt-dev-tools.sh}
    . ${../hooks/fix-qmake-libtool.sh}
  '';
  installPhase = ''
    mkdir "$out"
    mkdir "$bin"
    mkdir "$dev"
    cpFromDirToDir() {
      find "$1" -maxdepth 1 -mindepth 1 -exec cp --no-preserve=mode,ownership -r {} "$2" \;
    }
    cpFromDirToDir "${stage1.out}" "$out"
    cpFromDirToDir "${stage1.bin}" "$bin"
    cpFromDirToDir "${stage1.dev}" "$dev"
    mv "$dev/mkspecs" mkspecs.old
    moveToOutput "mkspecs" "$dev"
    cpFromDirToDir "mkspecs.old" "$dev/mkspecs"
    rm -rf mkspecs.old

    # Don't retain build-time dependencies like gdb.
    sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri
    fixQtModulePaths "''${!outputDev}/mkspecs/modules"
    fixQtBuiltinPaths "''${!outputDev}" '*.pr?'
    # Move development tools to $dev
    moveToOutput bin "$dev"

    chmod -R 0555 "$dev/bin"

    runHook postInstall
  '';

  postInstall = ''
    sed -i '/pritarget.path/a pritarget.path = \$\$NIX_OUTPUT_PLUGIN\/mkspecs\/modules' "$dev/mkspecs/features/qt_plugin.prf"
    sed -i '/pritarget.path = \//d' "$dev/mkspecs/features/qt_plugin.prf"
    sed -i "s!plug_path = /.*!plug_path = $bin/lib/qt-5.15.2/plugins!g" "$dev/mkspecs/features/qt.prf"
  '';
})
