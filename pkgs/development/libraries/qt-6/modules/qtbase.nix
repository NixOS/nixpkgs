{ stdenv, lib
, src, patches, version, qtCompatVersion

, coreutils, bison, flex, gdb, gperf, lndir, perl, pkg-config, python3
, python3Packages # debug: split ninja build
, bash # debug
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

  splitBuildInstall = true;
  # TODO set default false
  # run buildPhase in a separate derivation, to debug a broken installPhase

  buildWithNinja = !splitBuildInstall;
  # ninja makes it much harder to split buildPhase and installPhase
  # build files are locked via mtime and murmurhash64 in .ninja_log

qtbaseDrv = stdenv.mkDerivation rec {
  pname = "qtbase";
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
    openvg.shivavg
    #openvg.monkvg
    #openvg.amanithvg

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

  nativeBuildInputs = [ bison flex gperf lndir perl pkg-config which cmake ccache xmlstarlet ]
    ++ lib.optional (!splitBuildInstall) ninja
    ++ lib.optionals stdenv.isDarwin [ xcbuild ]
    ++ [ python3 ] ++ (with python3Packages; [ mmh3 murmurhash ]); # debug: split ninja build

  propagatedNativeBuildInputs = [ lndir ];

  enableParallelBuilding = true;

  outputs = [ "out" "bin" "dev" ];

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

  # debug ninja: ninjaFlags = [ "-d" "explain" ];

  # TODO what is setOutputFlags?
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

    [ -z "$(find . -name '.qmake.conf')" ] && echo "FIXME ERROR in postConfigure: .qmake.conf files not found"

    find . -name '.qmake.conf' | while read conf; do
        qmakeCacheInjectNixOutputs "$(dirname $conf)"
    done
  '';

  preBuild = ''
    export TERM=dumb # disable ninja line-clearing
    echo "building qtbase ..."
    t1_buildPhase=$(date +%s)
  '';

  postBuild = ''
    echo "building qtbase done in $(($(date +%s) - $t1_buildPhase)) seconds"
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
    # FIXME? write examples + tests to qtbase-everywhere-src-6.2.0/build/
    # currently in
    # qtbase-everywhere-src-6.2.0/examples
    # qtbase-everywhere-src-6.2.0/tests
    "-make examples"
    "-make tests"
    /*
    FIXME tests are not working / missing
    qtbase-everywhere-src-6.2.0/build/CMakeCache.txt
    FEATURE_itemmodeltester:BOOL=ON
    FEATURE_testlib:BOOL=ON
    QT_BUILD_TESTS_BY_DEFAULT:BOOL=ON
    */
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
      # FIXME why support old kernels?
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

  installPhaseYes = ''
    runHook preInstall
    ${if buildWithNinja then "ninja install" else "make install"}
    runHook postInstall
  '';

  #outputs = [ "bin" "dev" "out" ];
  # we must escape 
  installPhase = if splitBuildInstall then ''
    # do not run install hooks
    #runHook preInstall
    #runHook postInstall

    echo debug installPhase: copy /build to $out
    cp -r /build $out

    ${if !buildWithNinja then "" else ''
      # debug
      cat >$out/get-mtime-millisec-of-all-files-recursive.sh <<'EOF'
      #! ${bash}/bin/bash
      read -d "" fileHandler <<'__EOF'
      file="$1"
      actual=$(stat -c%.Y "$file" | tr -d .)
      echo "$actual $file"
      __EOF
      find . -exec sh -c "$fileHandler" 'dummyArgv0' '{}' \;
      EOF
      chmod +x $out/get-mtime-millisec-of-all-files-recursive.sh

      # debug
      # TODO murmurhash64 of files or build commands??
      cat >$out/murmurhash-cli.py <<'EOF'
      #! ${python3}/bin/python3
      # https://github.com/milahu/murmurhash-cli-python
      import sys
      import mmh3
      for path in sys.argv[1:]:
        try:
          bytes = open(path, 'rb').read()
          hash3 = mmh3.hash_bytes(bytes).hex()
          #print(f"{hash3[0:16]} {path}") # murmurhash3 64bit
          print(f"{hash3[0:16]} {hash3} {path}") # murmurhash3 64bit + 128bit
        except Exception as e:
          print(f"error: {type(e).__name__}: {e} in file {path}")
      EOF
      chmod +x $out/murmurhash-cli.py

      echo "debug: get file hashes ..."
      # TODO should be same as in .ninja_log
      (
        cd $out/qtbase-everywhere-src-6.2.0/build
        find . -exec $out/murmurhash-cli.py '{}' \; >$out/murmurhash.txt
      )
      echo "debug: get file hashes done $out/murmurhash.txt"

      echo "debug: get file times ..."
      # TODO should be same as in .ninja_log
      (
        cd $out/qtbase-everywhere-src-6.2.0/build
        $out/get-mtime-millisec-of-all-files-recursive.sh >$out/filetimes.txt
      )
      echo "debug: get file times done $out/filetimes.txt"
    ''}

    echo "debug: create empty outputs bin + dev"
    # fix: builder failed to produce output path for output 'bin'
    mkdir -v $bin $dev

    nixStoreEscaped=$(date +%s.%N | sha512sum -)
    nixStoreEscaped=''${nixStoreEscaped:0:11}
    echo "debug: nixStoreEscaped = $nixStoreEscaped"

    outHash=''${out:11:32}
    binHash=''${bin:11:32}
    devHash=''${dev:11:32}

    echo "debug: store escaped paths in $out/buildPhaseEscapedPaths"
    cat >$out/buildPhaseEscapedPaths <<EOF
    outHash=$outHash
    binHash=$binHash
    devHash=$devHash
    nixStoreEscaped=$nixStoreEscaped
    EOF

    # a: /nix/store/a3vjswd3i42xy5hzxras78z0m40g9jk7-qtbase-6.2.0
    # b: xxxxxxxxxxxa3vjswd3i42xy5hzxras78z0m40g9jk7-qtbase-6.2.0
    #    ^          ^ outHash: 32 chars
    #    ^ nixStoreEscaped: 11 chars

    echo "debug: regex = s,/nix/store/($outHash|$binHash|$devHash),$nixStoreEscaped\1,g"

    # note: the output paths also appear in binary files = *.so, etc
    # so we use the same length as the original path
    # tr -d '\0': fix "ignored null byte" when replacing binary files
    (
    cd $out
    find . -type f | while read f
    do
      if [ -n "$(sed -i -E "s,/nix/store/($outHash|$binHash|$devHash),$nixStoreEscaped\1,g w /dev/stdout" "$f" | tr -d '\0')" ]
      then
        # file was replaced
        echo "$f" >>$out/patched-files-with-escaped-output-paths.txt
      fi
    done
    )
    echo "debug: replaced install paths in $(wc -l $out/patched-files-with-escaped-output-paths.txt | cut -d' ' -f1) files. see $out/patched-files-with-escaped-output-paths.txt"
  '' else installPhaseYes;

  # Move selected outputs.
  preInstall = ''
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
  postInstall = ''
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

  # TODO set build root "build/" somewhere else
  # for example in the hook functions, see preHook
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

  fixupPhase = if splitBuildInstall then ''echo debug: skip fixupPhase'' else fixupPhaseYes;
  fixupPhaseYes = ''
    runHook preFixup
    runHook postFixup
  '';

  # cwd is /build/qtbase-everywhere-src-6.2.0/build
  # TODO refactor for splitBuildInstall: move everything after buildPhase to "let ... in",
  # so we can modify installPhase, fixupPhase, ... without rebuilding the build derivation
  postFixup = if splitBuildInstall then "echo debug: skip postFixup" else postFixupYes;
  postFixupYes = ''
    #PS4='+ Line $(expr $LINENO + 550): '; set -o xtrace # debug

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

if !splitBuildInstall then qtbaseDrv
else (qtbaseDrv // stdenv.mkDerivation rec {
  buildInputs = [ qtbaseDrv ];
  nativeBuildInputs = qtbaseDrv.nativeBuildInputs;
  inherit (qtbaseDrv) preHook fix_qt_builtin_paths fix_qt_module_paths; # fixQtModulePaths fixQtBuiltinPaths moveQtDevTools
  inherit (qtbaseDrv) pname version outputs;

  # pname must have same length in both qtbaseDrv and qtbase, so binary patching is less risky
  src = qtbaseDrv.out;

  # TODO replace qtbase-everywhere-src-6.2.0 with sourceRoot from qtbaseDrv
  unpackPhase = ''
    echo "installing from cached build ${qtbaseDrv}"

    # this takes about 30 seconds for qtbase. we must copy to get write access
    # TODO microoptimization: manual copy-on-write:
    # hardlink most files, only copy those files that we must modify
    echo "copying cached build files ..."
    t1=$(date +%s)
    cp -rap ${qtbaseDrv}/qtbase-everywhere-src-6.2.0 /build/
    echo "copying cached build files done in $(($(date +%s) - $t1)) seconds"

    chmod -R +w /build

    # set: nixStoreEscaped outHash binHash devHash
    source ${qtbaseDrv}/buildPhaseEscapedPaths

    outHashNew=''${out:11:32}
    binHashNew=''${bin:11:32}
    devHashNew=''${dev:11:32}

    # replace install paths
    echo "replacing output hashes:"
    echo "  out: $outHash -> $outHashNew"
    echo "  bin: $binHash -> $binHashNew"
    echo "  dev: $devHash -> $devHashNew"

    (
    cd /build
    cat ${qtbaseDrv}/patched-files-with-escaped-output-paths.txt | while read f
    do
      if [ "$f" = "./env-vars" ]; then continue; fi
      if [ ! -e "$f" ]
      then
        echo "fatal error: no such file: $f"
        exit 1
      fi
      if [ -z "$(
        sed -i -E "s,$nixStoreEscaped$outHash,/nix/store/$outHashNew,g w /dev/stdout" "$f" | tr -d '\0'
        sed -i -E "s,$nixStoreEscaped$binHash,/nix/store/$binHashNew,g w /dev/stdout" "$f" | tr -d '\0'
        sed -i -E "s,$nixStoreEscaped$devHash,/nix/store/$devHashNew,g w /dev/stdout" "$f" | tr -d '\0'
      )" ]
      then
        echo "fatal error: no paths replaced in $f"
        exit 1
      #else echo "replaced $(echo "$sedOutput" | wc -l | cut -d' ' -f1) paths in $f"
      fi
    done
    )

    # this is working
    if false; then
    # debug: verify patched output paths (slow)
    echo "debug: test replacement of old hashes ..."
    echo "grep -HnE ($outHash|$binHash|$devHash)"
    echo "this should be empty:"
    find /build -type f -not -path /build/env-vars \
      -exec grep -HnEa ".{50}($outHash|$binHash|$devHash).{50}" '{}' \;
    echo ":this should be empty"
    diff -u0 ${qtbaseDrv}/qtbase-everywhere-src-6.2.0/build/cmake_install.cmake /build/qtbase-everywhere-src-6.2.0/build/cmake_install.cmake || true
    fi

    ${if !buildWithNinja then "" else /* much more complex than cmake ... */ ''
      cd /build/qtbase-everywhere-src-6.2.0/build

      echo "debug: restoring timestamps in /build to prevent rerun_cmake"
      if [ "$(head -n 1 .ninja_log)" != "# ninja log v5" ]
      then
        echo "fatal error: unexpected format of ${qtbaseDrv}/qtbase-everywhere-src-6.2.0/build/.ninja_log:"
        head -n 1 .ninja_log
        exit 1
      fi

      mv .ninja_log .ninja_log.bak
      echo "# ninja log v5" >.ninja_log
      # https://github.com/m-ou-se/ninj/issues/13
      #while IFS=$'\t' read -r buildTimeStart buildTimeEnd fileTimeModify filePath buildCommandHash
      while IFS=$'\t' read -r buildTimeStart buildTimeEnd fileTimeModify filePath fileHash
      do
        TAB=$'\t'
        fileTimeModify=1000000000 # stat -c %.Y build/ # modify time is zero in nix store
        ##############murmurhash3_64=$(python -c 'import mmh3; "".join("{:02x}".format(x) for x in mmh3.hash_bytes("sdf")[0:8])')
        echo "$buildTimeStart$TAB$buildTimeEnd$TAB$fileTimeModify$TAB$filePath$TAB$fileHash" >>.ninja_log
        if false
        then
          echo "buildTimeStart = $buildTimeStart"
          echo "buildTimeEnd = $buildTimeEnd"
          echo "fileTimeModify = $fileTimeModify"
          echo "filePath = $filePath"
          echo "fileHash = $fileHash"
        fi
      done < <(tail -n +2 .ninja_log.bak)

      diff -u --color=always <(head .ninja_log.bak) <(head .ninja_log) || true
    ''}
  '';

  # wontfix? "ninja install" will always run RERUN_CMAKE
  # [0/1] Re-running CMake...
  # https://lists.llvm.org/pipermail/llvm-dev/2019-May/132592.html
  installPhase = if buildWithNinja then ''
    touch build.ninja # update mtime
    # debug: show some file times, compare with .ninja_log
    stat -c $'wxyz %.W %.X %.Y %.Z %n' build.ninja CMakeFiles/3.21.2/CMakeCCompiler.cmake
    #ninja install
    cd /build/qtbase-everywhere-src-6.2.0/build
    ninja -d explain install # debug
  '' else ''
    cd /build/qtbase-everywhere-src-6.2.0/build
    cmake -P cmake_install.cmake
    # -Wdev --debug-output --trace # debug cmake
  '';
  # "make install" calls "cmake -P ..."

  dontConfigure = true;
  dontWrapQtApps = true;
  dontBuild = true;

  preInstall = ''
    echo "splitBuildInstall install: preInstall"
    #find . build.ninja # FIXME no such file

    echo "splitBuildInstall install: preInstall: ls"; ls; echo "ls done"

    # TODO patch install paths
    # is this easy to solve?
    # or ... use outputs = [ "out" "bin" "dev" ] in qtbaseDrv
    # but patch the makefiles, so there are no more references to $out $bin $dev

    echo "qtbaseDrv = ${qtbaseDrv}"
    #echo "mkDerivation2: preInstall: ls"; ls; echo "ls done"
    #source env-vars # load env from buildPhase
  '' + qtbaseDrv.preInstall;

  postInstall = ''
    echo "splitBuildInstall install: postInstall"
  '' + qtbaseDrv.postInstall;

  postFixup = ''
    echo "splitBuildInstall install: postFixup"
  '' +
  #'' + qtbaseDrv.postFixupYes;
  ''
    # copy-paste from the build derivation
    # TODO move this back as soon as it works

    #PS4='+ Line $(expr $LINENO + 550): '; set -o xtrace # debug

    echo postFixup 1
    # Don't retain build-time dependencies like gdb.

    # noisy: echo "find $dev"; find $dev

    #echo "find $bin"; find $bin
    # FIXME qtbase-6.2.0-bin: No such file or directory

    if false; then
    echo "searching mkspecs/qconfig.pri ..."
    find $dev -path '*/mkspecs/qconfig.pri'
    find $out -path '*/mkspecs/qconfig.pri'
    echo "searching mkspecs/qconfig.pri done"
    # -> $out/mkspecs/qconfig.pri
    fi

    # FIXME why is this not in $dev?
    #sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri
    sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $out/mkspecs/qconfig.pri

    echo postFixup 3
    # FIXME fixQtModulePaths: command not found
    fixQtModulePaths "''${!outputDev}/mkspecs/modules" || {
      echo FIXME fixQtModulePaths failed
    }

    echo postFixup 4
    # FIXME fixQtBuiltinPaths: command not found
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
    # FIXME moveQtDevTools: command not found
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
    echo "debug: bin = $bin"
    mkdir -v $bin
    cp -r --verbose bin $bin
    set +o xtrace

    echo postFixup 6
    moveToOutput bin "$dev" || {
      echo FIXME postFixup command failed: moveToOutput bin "$dev"
      echo "ls:"; ls; echo ":ls"
    }

    echo postFixup done

    d="$bin/lib/qt-${version}"
    echo "moving plugins to $d"
    mkdir -p $d
    mv $out/plugins $d/

    echo "moving mkspecs to $dev"
    mv $out/mkspecs $dev/

    echo "pwd = $(pwd)"
    echo "ls:"; ls; echo ":ls"
    echo "running tests ..."
    cd /build/qtbase-everywhere-src-6.2.0/build
    echo "running tests: make test"; make test
    # FIXME No tests were found!!!
    echo "running tests done"

    ln -v -s $out/libexec $dev/

    # cmake files require libexec/moc from both $out and $dev ...
    # TODO ideally patch the cmake files to use only $dev, assuming that these are development tools

    # FIXME ...
    # CMake Error at /nix/store/idjvx01d2nalglfzbv0dycirpa9p3cql-qtbase-6.2.0-dev/lib/cmake/Qt6Core/Qt6CoreTargets.cmake:104 (message):
    # The imported target "Qt6::Core" references the file
    # "/nix/store/idjvx01d2nalglfzbv0dycirpa9p3cql-qtbase-6.2.0-dev/lib/libQt6Core.so.6.2.0"
    # but this file does not exist.
    #
    # qt5:
    # nix-locate lib/libQt5Core.so.5.14.2
    # libsForQt514.qt5.qtbase.out                   5,877,576 x /nix/store/r9dhw881gg1ql16m90w8lad57wyvbqbw-qtbase-5.14.2/lib/libQt5Core.so.5.14.2
    # libsForQt514.full.out                                 0 s /nix/store/jxhqm8c8gbmn5rkx377vdvajq8xjg271-qt-full-5.14.2/lib/libQt5Core.so.5.14.2
    #
    # -> Qt6::Core should be searched in $out, not in $dev




    # TODO refactor. same code in qtbase.nix and qtModule.nix
    echo "patching output paths in cmake files ..."
    (
    cd $dev/lib/cmake
    moduleNAME="${lib.toUpper pname}"
    outEscaped=$(echo $out | sed 's,/,\\/,g')
    devEscaped=$(echo $dev | sed 's,/,\\/,g')
    if [ -n "$bin" ]; then
    binEscaped=$(echo $bin | sed 's,/,\\/,g') # optional plugins
    else binEscaped=""; fi

    # TODO build the perlRegex string with nix? avoid the bash escape hell
    # or use: read -d "" perlRegex <<EOF ... EOF
    s=""
    s+="s/^# Compute the installation prefix relative to this file\."
    s+="\n.*?set\(_IMPORT_PREFIX \"\"\)\nendif\(\)"
    s+="/# NixOS was here"
    s+="\nset(_''${moduleNAME}_NIX_OUT \"$outEscaped\")"
    s+="\nset(_''${moduleNAME}_NIX_DEV \"$devEscaped\")"
    s+="\nset(_''${moduleNAME}_NIX_BIN \"$binEscaped\")/s;"
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?include/\\\''${_''${moduleNAME}_NIX_DEV}\/include/g;"
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?libexec/\\\''${_''${moduleNAME}_NIX_OUT}\/libexec/g;"
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?lib/\\\''${_''${moduleNAME}_NIX_OUT}\/lib/g;" # must come after libexec
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?plugins/\\\''${_''${moduleNAME}_NIX_BIN}\/lib\/qt-${version}\/plugins/g;"
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?bin/\\\''${_''${moduleNAME}_NIX_DEV}\/bin/g;" # qmake ...
    s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?mkspecs/\\\''${_''${moduleNAME}_NIX_DEV}\/mkspecs/g;"
    s+="s/set\(_IMPORT_PREFIX\)"
    s+="/set(_''${moduleNAME}_NIX_OUT)"
    s+="\nset(_''${moduleNAME}_NIX_DEV)"
    s+="\nset(_''${moduleNAME}_NIX_BIN)/g;"
    s+="s/\\\''${QtBase_SOURCE_DIR}\/libexec/\\\''${QtBase_BINARY_DIR}\/libexec/g;" # QtBase_SOURCE_DIR = qtbase/$dev

    s+="s/\\\''${QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX}\/\\\''${INSTALL_LIBEXECDIR}/$outEscaped\/libexec/g;"
    s+="s/\\\''${QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX}\/\\\''${INSTALL_BINDIR}/$devEscaped\/bin/g;"
    s+="s/\\\''${QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX}\/\\\''${INSTALL_DOCDIR}/$outEscaped\/share\/doc/g;"
    s+="s/\\\''${QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX}\/\\\''${INSTALL_LIBDIR}/$outEscaped\/lib/g;"
    s+="s/\\\''${QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX}\/\\\''${INSTALL_MKSPECSDIR}/$devEscaped\/mkspecs/g;"

    # lib/cmake/Qt6/QtBuild.cmake
    s+="s/\\\''${CMAKE_CURRENT_LIST_DIR}\/\.\.\/mkspecs/$devEscaped\/mkspecs/g;"
    # lib/cmake/Qt6/QtPriHelpers.cmake
    s+="s/\\\''${CMAKE_CURRENT_BINARY_DIR}\/mkspecs/$devEscaped\/mkspecs/g;"

    #s+="s/\\\''${QtBase_SOURCE_DIR}\/lib/\\\''${QtBase_BINARY_DIR}\/lib/g;" # TODO?
    perlRegex="$s"

    echo "debug: perlRegex = $perlRegex"
    find . -name '*.cmake' -exec perl -00 -p -i -e "$perlRegex" '{}' \;
    echo "rc of find = $?" # zero when perl returns nonzero?
    # FIXME catch errors from perl: find -> xargs
    echo "patching output paths in cmake files done"

    echo "verify that all _IMPORT_PREFIX are replaced ..."
    matches="$(find . -name '*.cmake' -exec grep -HnF _IMPORT_PREFIX '{}' \;)"
    if [ -n "$matches" ]; then
      echo "fatal: _IMPORT_PREFIX was not replaced in:"
      echo "$matches"
      exit 1
    fi
    echo "verify that all _IMPORT_PREFIX are replaced done"
    )

    echo "cached build: qtbaseDrv = ${qtbaseDrv}"

    echo "out = $out"
    echo "bin = $bin"
    echo "dev = $dev"
  '';

/*

latest output paths
cached build: qtbaseDrv = /nix/store/6kzvlblkjj8dii3yivdnsl21rrqxwj2c-qtbase-6.2.0
#out = /nix/store/al1dbwbprm5mrmpa9z8fbfkx9nshiah5-qtbase-6.2.0
 out = /nix/store/12h9m18mvzhvcsh57h58ysjayikis3yw-qtbase-6.2.0
 bin = /nix/store/v5l20vmiikp18asfs45bjxqnzaif0ygd-qtbase-6.2.0-bin
 dev = /nix/store/klkjkrq1livbw8yzfyy7blv4zcyfqrv0-qtbase-6.2.0-dev


nix-locate lib/libQt5Core.so.5.14.2
libsForQt514.qt5.qtbase.out                   5,877,576 x /nix/store/r9dhw881gg1ql16m90w8lad57wyvbqbw-qtbase-5.14.2/lib/libQt5Core.so.5.14.2
libsForQt514.full.out                                 0 s /nix/store/jxhqm8c8gbmn5rkx377vdvajq8xjg271-qt-full-5.14.2/lib/libQt5Core.so.5.14.2

nix-locate Qt5CoreConfig.cmake
libsForQt514.qt5.qtbase.dev                       8,126 r /nix/store/qhd5yxq9ll8nc92yfplgpnm1yqpj3pzn-qtbase-5.14.2-dev/lib/cmake/Qt5Core/Qt5CoreConfig.cmake

FIXME set _IMPORT_PREFIX in qtbase-6.2.0-dev/lib/cmake/Qt6Core/Qt6CoreTargets-release.cmake
old: $dev = /nix/store/g4pqvwxjq8yicd6irz9zg8d2fb3s1lrf-qtbase-6.2.0-dev
new: $out = /nix/store/12h9m18mvzhvcsh57h58ysjayikis3yw-qtbase-6.2.0

*/


/*
qt6 in gentoo https://github.com/gentoo/qt/pull/224

tests go to share/qt6/tests

	QT6_DATADIR=${QT6_PREFIX}/share/qt6
	QT6_DOCDIR=${QT6_PREFIX}/share/qt6-doc
	QT6_TRANSLATIONDIR=${QT6_DATADIR}/translations
	QT6_EXAMPLESDIR=${QT6_DATADIR}/examples
	QT6_TESTSDIR=${QT6_DATADIR}/tests
*/
})
