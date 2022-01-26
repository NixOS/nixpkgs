{ stdenv
, lib
, src
, patches ? []
, version
, qtCompatVersion
, coreutils
, bison
, flex
, gdb
, gperf
, lndir
, perl
, pkg-config
, python3
, which
, cmake # used in configure
, ninja # used in build
, ccache
, xmlstarlet
, libproxy
, xlibsWrapper
, zstd
, double-conversion
, util-linux
# FIXME checking Nixpkgs on aarch64-darwin: called without required argument 'utillinux'
#, journalctl
, systemd
, libb2
, md4c
, mtdev
, lksctp-tools
, libselinux
, libsepol
, vulkan-headers
, libthai
, libdrm
, libdatrie
, lttng-ust
, epoxy

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
# TODO libGL or libglvnd? libglvnd is "better"?

# TODO implement: buildExamples buildTests
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
in

stdenv.mkDerivation rec {

  pname = "qtbase";

  inherit qtCompatVersion src version;

  debug = debugSymbols;

  propagatedBuildInputs = [
    libxml2
    libxslt
    openssl
    sqlite sqlite.out sqlite.dev
    zlib
    unixODBC

    # Text rendering
    harfbuzz icu

    # Image formats
    libjpeg libpng
    pcre2
    pcre # for glib-2.0
    libproxy libproxy.dev
    xlibsWrapper
    zstd
    double-conversion
    util-linux # mount for gio-2.0
    #journalctl
    systemd
    libb2
    md4c
    mtdev
    lksctp-tools
    libselinux
    libsepol

    lttng-ust # linux trace

    # TODO enable vulkan/openvg only when openGL is available
    vulkan-headers

    libthai # for pango
    libdrm
    libdatrie # for libthai
    epoxy # for gdk-3.0
    #valgrind # for libdrm (optional, bloat)
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
    ++ lib.optional (postgresql != null) postgresql
  ;

  nativeBuildInputs = [ bison flex gperf lndir perl pkg-config which cmake ninja xmlstarlet ]
    ++ lib.optionals stdenv.isDarwin [ xcbuild ]
  ;

  propagatedNativeBuildInputs = [ lndir ];

  enableParallelBuilding = true;

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
  # FIXME qtDocPrefix is not used, docs are installed to share/doc/{config,global}

  # debug ninja: ninjaFlags = [ "-d" "explain" ];

  # TODO what is setOutputFlags?
  setOutputFlags = false;

  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/build/lib:$PWD/build/plugins/platforms''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QT_PLUGIN_PREFIX=\"$qtPluginPrefix\""

    t1_configurePhase=$(date +%s)
  ''
  ;

  postConfigure = ''
    dt_configurePhase=$(($(date +%s) - $t1_configurePhase))
    echo "qtbase configurePhase done after $dt_configurePhase seconds"

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

  cmakeFlags = [
    #"--trace-expand" # debug cmake
    "-DQT_FEATURE_journald=ON"
    "-DQT_FEATURE_sctp=ON"
    "-DQT_FEATURE_libproxy=ON"
    "-DQT_FEATURE_system_sqlite=ON"
  ];

  outputs = [ "out" "bin" "dev" ];

  # Move selected outputs.
  # TODO(milahu) cleanup
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
  # TODO(milahu) cleanup
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

  # TODO(milahu) bin/ or build/bin/ ?
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

  # TODO(milahu) cleanup
  postFixup = ''
    # copy-paste from the build derivation
    # TODO move this back as soon as it works

    #PS4='+ Line $(expr $LINENO + 550): '; set -o xtrace # debug

    echo postFixup 1
    # Don't retain build-time dependencies like gdb.

    # noisy: echo "find $dev"; find $dev

    #echo "find $bin"; find $bin
    # FIXME qtbase-6.2.0-bin: No such file or directory

    if true; then
    echo "searching mkspecs/qconfig.pri ..."
    find $dev -path '*/mkspecs/qconfig.pri'
    find $out -path '*/mkspecs/qconfig.pri'
    echo "searching mkspecs/qconfig.pri done"
    # -> $out/mkspecs/qconfig.pri
    fi

    # FIXME why is this not in $dev?
    sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri
    #sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $out/mkspecs/qconfig.pri # FIXME no such file qtbase-6.2.2/mkspecs/qconfig.pri

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

    # TODO where are mkspecs?
    #echo "moving mkspecs to $dev"
    #mv $out/mkspecs $dev/
    if true; then
      echo "searching mkspecs ..."
      find $dev -name 'mkspecs'
      find $out -name 'mkspecs'
      echo "searching mkspecs done"
    fi

    echo "pwd = $(pwd)"
    echo "ls:"; ls; echo ":ls"
    echo "running tests ..."
    cd $NIX_BUILD_TOP/$sourceRoot/build
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

    # TODO generate qt.conf from buildInputs -> qmake -qtconf /path/to/qt.conf
    # Qml2Imports is provided by qtdeclarative
    echo "writing $dev/bin/qt.conf"
    cat >$dev/bin/qt.conf <<EOF
    ; https://doc.qt.io/qt-6/qt-conf.html
    ; https://wiki.qt.io/Qmake_properties
    [Paths]
    ; must set Prefix to set other paths
    Prefix = $out
    HostPrefix = $out
    Libraries = $out/lib
    LibraryExecutables = $out/libexec
    ; fix qmake error: Could not find feature thread
    ; Data has mkspecs
    Data = $dev
    HostData = $dev
    ArchData = $dev
    Binaries = $dev/bin
    Headers = $dev/include
    Plugins = $bin/${qtPluginPrefix}
    Documentation = $out/${qtDocPrefix}
    ; Qml2Imports = (provided by qtdeclarative)
    EOF

    echo "moving docs to $out/${qtDocPrefix}"
    mkdir $out/${qtDocPrefix}
    mv $out/share/doc/* $out/${qtDocPrefix} || true
  '';

  dontStrip = debugSymbols;

  setupHook = ../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ qknight ttuegel periklis bkchr milahu ];
    platforms = platforms.unix;
  };
}
