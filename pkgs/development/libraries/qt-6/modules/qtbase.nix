{ stdenv, lib
, src, patches, version, qtCompatVersion

, coreutils, bison, flex, gdb, gperf, lndir, perl, pkg-config, python3
, which
, cmake # used in configure
, ninja # used in build
, ccache
, xmlstarlet
, libproxy
, xlibs
, zstd
, double_conversion
, utillinux
#, journalctl, systemd
, libb2
, md4c
, mtdev
, lksctp-tools
, libselinux
, libsepol
, vulkan-headers
, openvg, openvg-headers
, libthai
, libdrm
, libdatrie
, epoxy
#, valgrind

  # darwin support
, libiconv, libobjc, xcbuild, AGL, AppKit, ApplicationServices, Carbon, Cocoa, CoreAudio, CoreBluetooth
, CoreLocation, CoreServices, DiskArbitration, Foundation, OpenGL, MetalKit, IOKit

, dbus, fontconfig, freetype, glib, harfbuzz, icu, libX11, libXcomposite
, libXcursor, libXext, libXi, libXrender, libinput, libjpeg, libpng
, libxcb, libxkbcommon, libxml2, libxslt, openssl
, pcre
, pcre2, sqlite, udev
, xcbutil, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, xcbutilwm
, zlib, at-spi2-core
, unixODBC , unixODBCDrivers

  # optional dependencies
, cups, libmysqlclient, postgresql
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
  qmakeCacheName = ".qmake.stash";
  debugSymbols = debug || developerBuild;

  cacheBuildPhaseResult = true; # save the result of buildPhase in a separate derivation
  # make easier to debug postInstall, postFixup

pnameBase = "qtbase";

qtbaseDrv = stdenv.mkDerivation {
  pname = if cacheBuildPhaseResult then "${pnameBase}-buildPhaseResult" else pnameBase;
  inherit qtCompatVersion src version;
  debug = debugSymbols;
  # note: git repo: git://code.qt.io/qt/qtbase.git

  propagatedBuildInputs = [
    libxml2 libxslt openssl sqlite sqlite.out sqlite.dev zlib
    unixODBC

    # Text rendering
    harfbuzz icu

    # Image formats
    libjpeg libpng
    pcre2
    pcre # for glib-2.0
    libproxy libproxy.dev
    xlibs.libXdmcp.dev # xdmcp for xcb
    xlibs.libXtst # for atspi-2
    zstd
    double_conversion
    utillinux.dev # mount for gio-2.0
    #journalctl systemd # journald logging backend
    libb2
    md4c
    mtdev
    lksctp-tools
    libselinux
    libsepol

    # TODO enable vulkan/openvg only when openGL is available
    vulkan-headers
    openvg-headers

    # testing qt openvg: https://bugreports.qt.io/browse/QTBUG-25720
    # TODO allow to pass openvg impl as parameter to qtbase
    openvg.shivavg # FIXME not detected
    #openvg.monkvg # FIXME not detected
    #openvg.amanithvg # commercial openvg impl

    libthai # for pango
    libdrm
    libdatrie # for libthai
    epoxy # for gdk-3.0
    #valgrind # for libdrm (optional, too large)
  ] ++ (with unixODBCDrivers; [
    psql
    sqlite
    mariadb
  ]) ++ (
    if stdenv.isDarwin then [
      # TODO: move to buildInputs, this should not be propagated.
      AGL AppKit ApplicationServices Carbon Cocoa CoreAudio CoreBluetooth
      CoreLocation CoreServices DiskArbitration Foundation OpenGL
      libobjc libiconv MetalKit IOKit
    ] else [
      dbus glib udev

      # Text rendering
      fontconfig freetype

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

  nativeBuildInputs = [ bison flex gperf lndir perl pkg-config which cmake ninja ccache xmlstarlet ]
    ++ lib.optionals stdenv.isDarwin [ xcbuild ];

  propagatedNativeBuildInputs = [ lndir ];

  enableParallelBuilding = true;

  outputs = if cacheBuildPhaseResult then [ "out" ] else [ "bin" "dev" "out" ];

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

    # TODO remove when upstream bug is fixed https://bugreports.qt.io/browse/QTBUG-97568
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace util/cmake/tests/data/quoted.pro --replace /bin/ls ${coreutils}/bin/ls
    substituteInPlace src/corelib/CMakeLists.txt --replace /bin/ls ${coreutils}/bin/ls

    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i mkspecs/*/*.conf

    # find . -iname '*.cmake.in' -exec grep -Hn NO_DEFAULT_PATH '{}' ';'
    # TODO migrate to qt6?
    if false; then
    sed -i '/PATHS.*NO_DEFAULT_PATH/ d' src/corelib/Qt5Config.cmake.in
    sed -i '/PATHS.*NO_DEFAULT_PATH/ d' src/corelib/Qt5CoreMacros.cmake
    sed -i 's/NO_DEFAULT_PATH//' src/gui/Qt5GuiConfigExtras.cmake.in
    sed -i '/PATHS.*NO_DEFAULT_PATH/ d' mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in
    fi
  '' + (
    if stdenv.isDarwin then ''
        # TODO this is a noop. these search patterns are not in configure
        if false; then
        sed -i \
            -e 's|/usr/bin/xcode-select|xcode-select|' \
            -e 's|/usr/bin/xcrun|xcrun|' \
            -e 's|/usr/bin/xcodebuild|xcodebuild|' \
            -e 's|QMAKE_CONF_COMPILER=`getXQMakeConf QMAKE_CXX`|QMAKE_CXX="clang++"\nQMAKE_CONF_COMPILER="clang++"|' \
            ./configure
        fi
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

  # out-of-tree build in $PWD/build
  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/build/lib:$PWD/build/plugins/platforms''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="${openvg.shivavg}/lib:$LD_LIBRARY_PATH"
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QT_PLUGIN_PREFIX=\"$qtPluginPrefix\""
  '' +
    # enable openvg. experimental. maybe not implemented
    # testing qt openvg: https://bugreports.qt.io/browse/QTBUG-25720
    # qtperf6 -graphicssystem openvg
    # qtperf6 -graphicssystem OpenVG
    # qtperf6 -graphicssystem ShivaVG
  ''
    sed -i 's,#### Tests,qt_find_package(OpenVG PROVIDED_TARGETS OpenVG::OpenVG MODULE_NAME gui QMAKE_LIB openvg MARK_OPTIONAL)\n\n&,' src/gui/configure.cmake
    sed -i 's,CONDITION libs.openvg OR FIXME,CONDITION QT_FEATURE_library AND QT_FEATURE_opengl AND OpenVG_FOUND,' src/gui/configure.cmake
    cp ${../cmake/FindOpenVG.cmake} cmake/FindOpenVG.cmake
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

  #ninjaFlags = [ "--verbose" ]; # too noisy

  preBuild = ''
    export TERM=dumb # disable ninja line-clearing
  '';

  NIX_CFLAGS_COMPILE = toString ([
    "-Wno-error=sign-compare" # freetype-2.5.4 changed signedness of some struct fields
    ''-DNIXPKGS_QTCOMPOSE="${libX11.out}/share/X11/locale"''
    ''-D${if compareVersion "5.11.0" >= 0 then "LIBRESOLV_SO" else "NIXPKGS_LIBRESOLV"}="${stdenv.cc.libc.out}/lib/libresolv"''
    ''-DNIXPKGS_LIBXCURSOR="${libXcursor.out}/lib/libXcursor"''
  ] ++ lib.optional libGLSupported ''-DNIXPKGS_MESA_GL="${libGL.out}/lib/libGL"''
    ++ lib.optional stdenv.isLinux "-DUSE_X11"
    ++ lib.optionals withGtk3 [
      ''-DNIXPKGS_QGTK3_XDG_DATA_DIRS="${gtk3}/share/gsettings-schemas/${gtk3.name}"''
      ''-DNIXPKGS_QGTK3_GIO_EXTRA_MODULES="${dconf.lib}/lib/gio/modules"''
    ] ++ lib.optional decryptSslTraffic "-DQT_DECRYPT_SSL_TRAFFIC");

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
    "-ccache" # FIXME Using ccache: no

    "-openvg" # FIXME remove? no effect?
    # qtbase/src/gui/qt_cmdline.cmake:26:qt_commandline_option(openvg TYPE boolean)
    # qtbase/src/gui/configure.cmake:1208:qt_configure_add_summary_entry(ARGS "openvg")

    "-journald"
    "-sctp"
    "-libproxy"
    "-sqlite" "system"

    "-gui"
    "-widgets"
    "-opengl desktop"
    "-libproxy"
    "-sctp"
    "-icu"
    "-L" "${icu.out}/lib"
    "-I" "${icu.dev}/include"
    "-pch"
  ] ++ lib.optional debugSymbols "-debug"
    ++ lib.optionals developerBuild [
    "-developer-build"
    "-no-warnings-are-errors"
  ] ++ (if (!stdenv.hostPlatform.isx86_64) then [
    "-no-sse2"
  ] else

  [
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
    # TODO maybe remove examples + tests
    "-make examples"
    "-make tests"
    ''-${lib.optionalString (!buildExamples) "no"}make examples''
    ''-${lib.optionalString (!buildTests) "no"}make tests''
  ] ++ (
    if stdenv.isDarwin then [
      "-platform macx-clang"
      "-no-fontconfig"
      "-qt-freetype"
      "-qt-libpng"
      "-no-framework"
    ] else [
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
      "-system-libpng"
    ] ++ lib.optional withGtk3 "-gtk"
      ++ [
      "-inotify"
      # Without these, Qt stops working on kernels < 3.17. See:
      # https://github.com/NixOS/nixpkgs/issues/38832
      "-no-feature-renameat2"
      "-no-feature-getentropy"
    ] ++ lib.optionals (cups != null) [
      "-L" "${cups.lib}/lib"
      "-I" "${cups.dev}/include"
    ] ++ lib.optionals (libmysqlclient != null) [
      "-L" "${libmysqlclient}/lib"
      "-I" "${libmysqlclient}/include"
    ]
  );

  cmakeFlags = if cacheBuildPhaseResult then [ "-DINSTALL_COMMAND=:" ] else [ ];

  # Move selected outputs.
  # TODO dont install $out/mkspecs in the first place
  preInstall = if cacheBuildPhaseResult then ''
    cd ..
    cp -r . $out
  '' else ''
    echo preInstall 0
    echo find plugins folder
    find . -name plugins
    echo find plugins folder done
    echo find plugins files
    find . -name '*plugin.so'
    echo find plugins files done
    # TODO move to qtbase-6.2.0-bin/lib/qt-6.2.0/plugins/generic/libqevdevkeyboardplugin.so ... etc

    echo preInstall 1

    # FIXME why is this both in pre and post install?
    moveToOutput "mkspecs" "$dev" || {
      echo FIXME preInstall moveToOutput failed
    }

    echo preInstall 2
    if [ -d mkspecs ]; then
      echo "ERROR: qtbase preInstall: dir mkspecs still exists after moveToOutput. forcing remove"

      # FIXME why is this both in pre and post install?
      rm -rf $out/mkspecs || {
        echo FIXME preInstall remove failed
      }

    else
      echo "SUCCESS: qtbase preInstall: dir mkspecs was removed by moveToOutput"
    fi
    echo preInstall done
  '';

  # Move selected outputs.
  # TODO dont install $out/mkspecs in the first place
  postInstall = if cacheBuildPhaseResult then ":" else ''
    echo postInstall 1

    # FIXME why is this both in pre and post install?
    moveToOutput "mkspecs" "$dev" || {
      echo FIXME preInstall remove failed
    }

    echo postInstall 2

    # FIXME why is this both in pre and post install?
    rm -rf $out/mkspecs || {
      echo FIXME preInstall remove failed
    }

    echo postInstall done
  '';

  devTools = [
    "build/bin/fixqt4headers.pl"
    "build/bin/moc"
    "build/bin/qdbuscpp2xml"
    "build/bin/qdbusxml2cpp"
    "build/bin/qlalr"
    "build/bin/qmake"
    "build/bin/rcc"
    "build/bin/syncqt.pl"
    "build/bin/uic"
  ];

  # cwd is /build/qtbase*/build
  postFixup = if cacheBuildPhaseResult then ":" else ''
    #set -o xtrace # debug

    echo postFixup 1
    # Don't retain build-time dependencies like gdb.

    echo postFixup 2
    sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri

    echo postFixup 3
    fixQtModulePaths "''${!outputDev}/mkspecs/modules" || {
      echo FIXME fixQtModulePaths failed
    }

    echo postFixup 4
    fixQtBuiltinPaths "''${!outputDev}" '*.pr?' || {
      echo FIXME fixQtBuiltinPaths failed
    }

    echo "postFixup ls:"; ls; echo ":postFixup ls"

    # debug
    echo "postFixup: find bin"
    find bin || {
      echo FIXME find bin failed
    }

    echo postFixup 5
    # Move development tools to $dev
    moveQtDevTools || {
      echo FIXME moveQtDevTools failed
      echo "ls:"; ls; echo ":ls"
    }

    # debug
    echo "postFixup: find bin 2"
    find bin || {
      echo FIXME find bin 2 failed
    }

    # fix: error: builder for 'qtbase-6.2.0.drv' failed to produce output path for output 'bin'
    # TODO how is this working in qt5?
    set -o xtrace
    mkdir $bin
    cp -r --verbose bin $bin
    set +o xtrace

    echo postFixup 6
    moveToOutput bin "$dev" || {
      echo FIXME postFixup command failed: moveToOutput bin "$dev"
      echo "ls:"; ls; echo ":ls"
    }

    echo postFixup done
  '';

  dontStrip = debugSymbols;

  setupHook = ../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ qknight ttuegel periklis bkchr ];
    platforms = platforms.unix;
  };
};

in

if !cacheBuildPhaseResult then qtbaseDrv
else stdenv.mkDerivation {
  # TODO install qtbaseDrv
  buildInputs = [ qtbaseDrv ];
  pname = pnameBase;
  version = qtbaseDrv.version;
  outputs = [ "bin" "dev" "out" ];
  buildPhase = ''
    echo TODO qtbaseDrv ${qtbaseDrv}
    exit 1
  '';
}
