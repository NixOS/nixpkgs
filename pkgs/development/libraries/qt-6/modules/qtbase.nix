{ stdenv
, lib
, src
, patches ? [ ]
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
, xlibs
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
, vulkan-loader
, libthai
, libdrm
, libdatrie
, lttng-ust
, epoxy

  # darwin support
, libiconv
, libobjc
, xcbuild
, AGL
, AppKit
, ApplicationServices
, Carbon
, Cocoa
, CoreAudio
, CoreBluetooth
, CoreLocation
, CoreServices
, DiskArbitration
, Foundation
, OpenGL
, MetalKit
, IOKit

, dbus
, fontconfig
, freetype
, glib
, harfbuzz
, icu
, libX11
, libXcomposite
, libXcursor
, libXext
, libXi
, libXrender
, libinput
, libjpeg
, libpng
, libxcb
, libxkbcommon
, libxml2
, libxslt
, openssl
, pcre
, pcre2
, sqlite
, udev
, xcbutil
, xcbutilimage
, xcbutilkeysyms
, xcbutilrenderutil
, xcbutilwm
, zlib
, at-spi2-core
, unixODBC
, unixODBCDrivers

  # optional dependencies
, cups
, libmysqlclient
, postgresql
, withGtk3 ? false
, dconf
, gtk3

  # options
, libGLSupported ? !stdenv.isDarwin
, libGL
  # TODO libGL or libglvnd? libglvnd is "better"?

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

  splitBuildInstallEnabled = false; # debug post-build phases
  # use only when needed, to avoid rebuilds
  split-build-install-import-sh = if splitBuildInstallEnabled then ../split-build-install.import.sh else "";
  split-build-install-export-sh = if splitBuildInstallEnabled then ../split-build-install.export.sh else "";
  # TODO micro optimize: use only one regex in split-build-install.import.sh -> https://stackoverflow.com/a/29606752/10440128

  patch-cmake-files-sh = ../patch-cmake-files.sh;
  patch-cmake-files-regex-diff = ../patch-cmake-files.regex.diff;

drv1 =
stdenv.mkDerivation rec {

  # when splitting, disable all phases after buildPhase
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/setup.sh#L1305
  dontCheck = splitBuildInstallEnabled;
  dontInstall = splitBuildInstallEnabled;
  dontFixup = splitBuildInstallEnabled;
  dontInstallCheck = splitBuildInstallEnabled;
  dontDist = splitBuildInstallEnabled;
  postPhases = if splitBuildInstallEnabled then "splitBuildInstallLoad splitBuildInstallExport" else "";

  # TODO better? how to load "hooks" for mkDerivation?
  splitBuildInstallLoad = ''
    . ${split-build-install-export-sh}
  '';

  pname = "qtbase";

  inherit qtCompatVersion src version;

  debug = debugSymbols;

  propagatedBuildInputs = [
    libxml2
    libxslt
    openssl
    # TODO sqlite.all?
    sqlite
    sqlite.out
    sqlite.dev
    zlib
    unixODBC

    # Text rendering
    harfbuzz
    icu

    # Image formats
    libjpeg
    libpng
    pcre2
    pcre # for glib-2.0
    libproxy
    libproxy.dev # pulls kerberos
    xlibsWrapper
    xlibs.libXdmcp
    xlibs.libXtst
    xlibs.xcbutilcursor
    zstd
    double-conversion
    util-linux # mount for gio-2.0
    #journalctl
    systemd # pulls kerberos
    libb2
    md4c
    mtdev
    lksctp-tools
    libselinux
    libsepol

    lttng-ust # linux trace

    # TODO enable vulkan/openvg only when openGL is available
    vulkan-headers
    vulkan-loader

    libthai # for pango
    libdrm
    libdatrie # for libthai
    epoxy # for gdk-3.0
    #valgrind # for libdrm. TODO add? or is it bloat?
    #tslib # touchscreen
  ] ++ (with unixODBCDrivers; [
    psql
    sqlite
    mariadb
  ]) ++ (
    if stdenv.isDarwin then [
      # TODO: move to buildInputs, this should not be propagated.
      AGL
      AppKit
      ApplicationServices
      Carbon
      Cocoa
      CoreAudio
      CoreBluetooth
      CoreLocation
      CoreServices
      DiskArbitration
      Foundation
      OpenGL
      libobjc
      libiconv
      MetalKit
      IOKit
    ] else [
      dbus
      glib
      udev

      # Text rendering
      fontconfig
      freetype

      # X11 libs
      libX11
      libXcomposite
      libXext
      libXi
      libXrender
      libxcb
      libxkbcommon
      xcbutil
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      xcbutilwm
    ] ++ lib.optional libGLSupported libGL
  );

  buildInputs = [
    python3
    at-spi2-core
    patch-cmake-files-sh
    patch-cmake-files-regex-diff
  ]
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

  nativeBuildInputs = [ bison flex gperf lndir perl pkg-config which cmake xmlstarlet ]
    ++ lib.optionals (!splitBuildInstallEnabled) [ ninja ]
    ++ lib.optionals stdenv.isDarwin [ xcbuild ]
  ;

  propagatedNativeBuildInputs = [ lndir ];

  enableParallelBuilding = true;

  inherit patches;

  # also used in setupHook
  fix_qt_builtin_paths = ../hooks/fix-qt-builtin-paths.sh;
  fix_qt_module_paths = ../hooks/fix-qt-module-paths.sh;

  preHook = ''
    . "$fix_qt_builtin_paths"
    . "$fix_qt_module_paths"
    . ${../hooks/move-qt-dev-tools.sh}
    . ${../hooks/fix-qmake-libtool.sh}
  '';

  # TODO substituteInPlace -> https://bugreports.qt.io/browse/QTBUG-97568
  postPatch = ''
    for prf in qml_plugin.prf qt_plugin.prf qt_docs.prf qml_module.prf create_cmake.prf; do
      substituteInPlace "mkspecs/features/$prf" \
        --subst-var qtPluginPrefix \
        --subst-var qtQmlPrefix \
        --subst-var qtDocPrefix
    done

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

  configureFlags = [
    "-make libs"
    "-make tools"
    "-make examples"
  ]
  ++ lib.optional buildTests [
    "-make tests" # TODO install where?
    "-make benchmarks"
    #"-make manual-tests"
    #"-make minimal-static-tests"
  ]
  # FIXME these have no effect. maybe we must set cmakeFlags?
  ++ lib.optional buildExamples [ "-make examples" ] # TODO install where?
  ++ lib.optional developerBuild [ "-developer-build" ]
  ++ lib.optional debug [ "-debug" ]
  ;

  cmakeFlags = [
    #"--trace-expand" # debug cmake
    "-DQT_FEATURE_journald=ON"
    "-DQT_FEATURE_sctp=ON"
    "-DQT_FEATURE_libproxy=ON"
    "-DQT_FEATURE_system_sqlite=ON"
    "-DQT_FEATURE_vulkan=ON"

    #"-DQT_FEATURE_ltcg=ON" # default off

    # trying to fix strawberry TLS errors
    "-DQT_FEATURE_openssl_linked=ON" # TODO? "Qt directly linked to OpenSSL"
    "-DQT_FEATURE_dtls=ON" # TLS for UDP # is this default on?
  ];

  outputs = [ "out" "bin" "dev" ];

  postInstall = ''
    mkdir -p $dev $(dirname $bin/${qtPluginPrefix})
    mv $out/plugins $bin/${qtPluginPrefix}
    mv $out/mkspecs $out/bin $dev/
  '';
  # postFixup: ln -v -s $out/libexec $dev/
  # cannot move libexec, dep cycle
  # cmake files require libexec/moc from both $out and $dev
  # TODO patch cmake files to use only $dev

  # TODO refactor. same code in qtbase.nix and qtModule.nix
  postFixup = ''
    sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri
    fixQtModulePaths "''${!outputDev}/mkspecs/modules"
    fixQtBuiltinPaths "''${!outputDev}" '*.pr?'

    ln -v -s $out/libexec $dev/

    echo "patching output paths in $dev/lib/cmake ..."
    find $dev/lib/cmake -name '*.cmake' -print0 \
      | xargs -0 ${patch-cmake-files-sh} \
      qtCompatVersion=${qtCompatVersion} \
      QT_MODULE_NAME=${lib.toUpper pname} \
      NIX_OUT_PATH=$out \
      NIX_DEV_PATH=$dev \
      NIX_BIN_PATH=$bin \
      REGEX_FILE=${patch-cmake-files-regex-diff} --
    echo "patching output paths in $dev/lib/cmake done"

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

    echo "verify that all _IMPORT_PREFIX are replaced in $dev/lib/cmake"
    (
      cd $dev/lib/cmake
      matches="$(find . -name '*.cmake' -print0 | xargs -0 grep -HnF _IMPORT_PREFIX || true)"
      if [ -n "$matches" ]; then
        echo "fatal: _IMPORT_PREFIX was not replaced in:"
        echo "$matches"
        exit 1
      fi
    )
    echo "verify that all _IMPORT_PREFIX are replaced done"
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
;

in
if (!splitBuildInstallEnabled) then drv1
else
let
  pname = drv1.pname;
  qtPluginPrefix = drv1.qtPluginPrefix;
  qtDocPrefix = drv1.qtDocPrefix;
in
stdenv.mkDerivation (drv1.drvAttrs // {
  src = drv1.out;
  prePhases = "splitBuildInstallLoad splitBuildInstallImport";
  postPhases = "";

  # TODO better? how to load "hooks" for mkDerivation?
  # separate script for import, to avoid rebuilds
  splitBuildInstallLoad = ''
    . ${split-build-install-import-sh}
  '';

  # when splitting, disable all phases before buildPhase
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/setup.sh#L1305
  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  # enable all install phases
  dontCheck = false;
  dontInstall = false;
  dontFixup = false;
  dontInstallCheck = false;
  dontDist = false;

  # avoid rebuild
  installPhase = ''
    runHook preInstall
    cd /build/$sourceRoot/build
    cmake -P cmake_install.cmake
    runHook postInstall
  '';

})
