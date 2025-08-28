{
  stdenv,
  lib,
  src,
  patches,
  version,
  qtCompatVersion,

  coreutils,
  bison,
  flex,
  gdb,
  gperf,
  perl,
  pkg-config,
  python3,
  which,
  distccMasquerade,
  qtbase-bootstrap,
  # darwin support
  apple-sdk_14,
  xcbuild,

  dbus,
  fontconfig,
  freetype,
  glib,
  harfbuzz,
  icu,
  libdrm,
  libX11,
  libXcomposite,
  libXcursor,
  libXext,
  libXi,
  libXrender,
  libjpeg,
  libpng,
  libxcb,
  libxkbcommon,
  libxml2,
  libxslt,
  openssl,
  pcre2,
  sqlite,
  udev,
  xcbutil,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  xcbutilwm,
  zlib,
  at-spi2-core,

  # optional dependencies
  cups ? null,
  libpq ? null,
  withGtk3 ? false,
  dconf,
  gtk3,
  qttranslations ? null,
  withLibinput ? false,
  libinput,

  # options
  libGLSupported ? !stdenv.hostPlatform.isDarwin,
  libGL,
  mysqlSupport ? true,
  libmysqlclient,
  buildExamples ? false,
  buildTests ? false,
  debug ? false,
  developerBuild ? false,
  bootstrapBuild ? false,
  decryptSslTraffic ? false,
  testers,
}:

let
  debugSymbols = debug || developerBuild;
  isCrossBuild = stdenv.buildPlatform != stdenv.hostPlatform;

  qtPlatformCross =
    with stdenv.hostPlatform;
    if isLinux then
      "devices/linux-generic-g++"
    else if isDarwin then
      # the logic from the configure script
      if isAarch64 then "macx-clang-arm64" else "macx-clang-x64"
    else if isCrossBuild then
      throw "Please add a qtPlatformCross entry for ${config}"
    else
      null;

  # We need to keep the original mkspec name in the string for pyqt-builder to determine
  # the target platform.
  nixCrossConf = builtins.baseNameOf qtPlatformCross + "-nix-cross";

  postFixupPatch = ../${lib.versions.majorMinor version}/qtbase.patch.d/0016-qtbase-cross-build-postFixup.patch;

  # Per https://doc.qt.io/qt-5/macos.html#supported-versions: build SDK = 13.x or 14.x.
  darwinVersionInputs = [
    apple-sdk_14
  ];
in

stdenv.mkDerivation (
  finalAttrs:
  (
    {
      pname = "qtbase";
      inherit qtCompatVersion src version;
      debug = debugSymbols;

      propagatedBuildInputs = [
        libxml2
        libxslt
        openssl
        sqlite
        zlib

        # Text rendering
        freetype
        harfbuzz
        icu

        # Image formats
        libjpeg
        libpng
        pcre2
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) (
        [
          dbus
          glib
          udev

          # Text rendering
          fontconfig

          libdrm

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
        ]
        ++ lib.optional libGLSupported libGL
      );

      buildInputs = [
        # We need python3 for hostPlatform to properly patch the shebang of the
        # mkspecs/features/uikit/devices.py script that we're publishing.
        python3
        # We need perl for hostPlatform to properly patch shebangs of the
        # fixqt4headers.pl and syncqt.pl scripts that we're publishing.
        perl
        at-spi2-core
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) (
        lib.optional withLibinput libinput ++ lib.optional withGtk3 gtk3
      )
      ++ lib.optional stdenv.hostPlatform.isDarwin darwinVersionInputs
      ++ lib.optional developerBuild gdb
      ++ lib.optional (cups != null) cups
      ++ lib.optional (mysqlSupport) libmysqlclient
      ++ lib.optional (libpq != null) libpq;

      nativeBuildInputs = [
        bison
        flex
        gperf
        perl
        pkg-config
        which
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ]
      ++ lib.optionals isCrossBuild [
        # `qtbase` expects to find `cc` (with no prefix) in the `$PATH` for qmake and host_build marked projects.
        # And we need those to be built for the hostPlatform. So instead of patching configure and mkspeks even
        # more I'm just masqurading the prefixed tools.
        # I probably should be using the distccMasquerade._spliced.buildHost here, but it works as it is. It's magic!
        # Pure wall-of-bash-code-directly-in-derivation-attribute magic!
        (distccMasquerade.override {
          gccRaw = stdenv.cc;
          binutils = stdenv.cc.bintools;
        })
      ];

      # qtbase needs a runnable qmake and the accompanying tools to build itself, and there are also packages
      # out there that use cmake as their main configurator (i.e. don't depend on qmake-the-package) but
      # still need qmake&co to be available at build time. In fact, cmake scripts provided by qtbase.dev
      # itself look for those tools.
      propagatedNativeBuildInputs = lib.optional isCrossBuild qtbase-bootstrap.qmake;

      strictDeps = true;

      # libQt5Core links calls CoreFoundation APIs that call into the system ICU. Binaries linked
      # against it will crash during build unless they can access `/usr/share/icu/icudtXXl.dat`.
      propagatedSandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
        (allow file-read* (subpath "/usr/share/icu"))
      '';

      enableParallelBuilding = true;

      outputs = [
        "bin"
        "dev"
        "out"
        "qmake"
      ];

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

        # Always build uic and qvkgen for qtbase-bootstrap
        sed -i '/^TOOLS =/ s/$/ src_tools_qvkgen src_tools_uic/' src/src.pro
        sed -i '/^SUBDIRS += src_corelib/ s/$/ src_tools_qvkgen src_tools_uic/' src/src.pro

        # https://bugs.gentoo.org/803470
        sed -i 's/-lpthread/-pthread/' mkspecs/common/linux.conf src/corelib/configure.json

        patchShebangs ./bin
      ''
      + (
        if stdenv.hostPlatform.isDarwin then
          ''
            for file in \
              configure \
              mkspecs/features/mac/asset_catalogs.prf \
              mkspecs/features/mac/default_pre.prf \
              mkspecs/features/mac/sdk.mk \
              mkspecs/features/mac/sdk.prf
            do
              substituteInPlace "$file" \
                --replace-quiet /usr/bin/xcode-select '${lib.getExe' xcbuild "xcode-select"}' \
                --replace-quiet /usr/bin/xcrun '${lib.getExe' xcbuild "xcrun"}' \
                --replace-quiet /usr/libexec/PlistBuddy '${lib.getExe' xcbuild "PlistBuddy"}'
            done

            substituteInPlace configure \
              --replace-fail /System/Library/Frameworks/Cocoa.framework "$SDKROOT/System/Library/Frameworks/Cocoa.framework"

            substituteInPlace mkspecs/common/macx.conf \
              --replace-fail 'CONFIG += ' 'CONFIG += no_default_rpath ' \
              --replace-fail \
                'QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.13' \
                "QMAKE_MACOSX_DEPLOYMENT_TARGET = $MACOSX_DEPLOYMENT_TARGET"
          ''
        else
          lib.optionalString libGLSupported ''
            sed -i mkspecs/common/linux.conf \
                -e "/^QMAKE_INCDIR_OPENGL/ s|$|${lib.getDev libGL}/include|" \
                -e "/^QMAKE_LIBDIR_OPENGL/ s|$|${lib.getLib libGL}/lib|"
          ''
          + lib.optionalString (stdenv.hostPlatform.isx86_32 && stdenv.cc.isGNU) ''
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

        NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QT_PLUGIN_PREFIX=\"$qtPluginPrefix\""

        # paralellize compilation of qtmake, which happens within ./configure
        export MAKEFLAGS+=" -j$NIX_BUILD_CORES"

        ./bin/syncqt.pl -version $version

      ''
      # generate a cross compilation config even for native builds so we can pass a natively-built qtbase
      # as a build dependency for a cross build and to avoid specifying CROSS_COMPILE prefix for qmake later
      + lib.optionalString (qtPlatformCross != null) ''
        mkdir mkspecs/${nixCrossConf}
        echo 'CROSS_COMPILE=${stdenv.hostPlatform.config + "-"}' > mkspecs/${nixCrossConf}/qmake.conf
        echo 'QMAKE_PKG_CONFIG=''$''$(PKG_CONFIG)' >> mkspecs/${nixCrossConf}/qmake.conf
        echo 'include(../${qtPlatformCross}/qmake.conf)' >> mkspecs/${nixCrossConf}/qmake.conf
        echo '#include "../${qtPlatformCross}/qplatformdefs.h"' > mkspecs/${nixCrossConf}/qplatformdefs.h

      ''
      # QT's configure script will refuse to use pkg-config unless these two environment variables are set
      + lib.optionalString isCrossBuild ''
        export PKG_CONFIG_SYSROOT_DIR=/
        export PKG_CONFIG_LIBDIR=${lib.getLib pkg-config}/lib
      '';

      postConfigure = ''
        qmakeCacheInjectNixOutputs() {
            local cache="$1/.qmake.stash"
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

      env = {
        NIX_CFLAGS_COMPILE = toString (
          [
            "-Wno-error=sign-compare" # freetype-2.5.4 changed signedness of some struct fields
            "-Wno-warn=free-nonheap-object"
            "-Wno-free-nonheap-object"
            "-w"
          ]
          ++ [
            ''-DNIXPKGS_QTCOMPOSE="${libX11.out}/share/X11/locale"''
            ''-DLIBRESOLV_SO="${stdenv.cc.libc.out}/lib/libresolv"''
            ''-DNIXPKGS_LIBXCURSOR="${libXcursor.out}/lib/libXcursor"''
          ]
          ++ lib.optional libGLSupported ''-DNIXPKGS_MESA_GL="${libGL.out}/lib/libGL"''
          ++ lib.optional stdenv.hostPlatform.isLinux "-DUSE_X11"
          ++ lib.optionals withGtk3 [
            ''-DNIXPKGS_QGTK3_XDG_DATA_DIRS="${gtk3}/share/gsettings-schemas/${gtk3.name}"''
            ''-DNIXPKGS_QGTK3_GIO_EXTRA_MODULES="${dconf.lib}/lib/gio/modules"''
          ]
          ++ lib.optional decryptSslTraffic "-DQT_DECRYPT_SSL_TRAFFIC"
        );
      };

      prefixKey = "-prefix ";

      # PostgreSQL autodetection fails sporadically because Qt omits the "-lpq" flag
      # if dependency paths contain the string "pq", which can occur in the hash.
      # To prevent these failures, we need to override PostgreSQL detection.
      PSQL_LIBS = lib.optionalString (libpq != null) "-L${libpq}/lib -lpq";

    }
    // lib.optionalAttrs isCrossBuild {
      configurePlatforms = [ ];
    }
    // {
      # TODO Remove obsolete and useless flags once the build will be totally mastered
      configureFlags = [
        # common options for all types of builds
        "-verbose"
        "-confirm-license"
        "-opensource"

        "-release"
        "-shared"
        # for separateDebugInfo
        "-no-strip"
        "-pkg-config"

        "-make tools"
        ''-${lib.optionalString (!buildExamples || bootstrapBuild) "no"}make examples''
        ''-${lib.optionalString (!buildTests) "no"}make tests''

        "-icu"
        "-L"
        "${icu.out}/lib"
        "-I"
        "${icu.dev}/include"
        "-pch"
        "-system-zlib"
        "-L"
        "${zlib.out}/lib"
        "-I"
        "${zlib.dev}/include"

      ]
      ++ (
        if stdenv.hostPlatform.isDarwin then
          [
            "-no-fontconfig"
            "-no-framework"
            "-no-rpath"
          ]
        else
          [
            "-rpath"
          ]
      )
      # a bare bones build only to get build tools and mkspecs
      ++ (
        if bootstrapBuild then
          [
            # We probably can go slimmer than this with some patching and/or selective run of Makefiles
            # but this is already good enough.
            "-no-gui"
            "-no-widgets"
            "-no-feature-sqlmodel"
            "-no-sql-sqlite"
            "-no-feature-bearermanagement"
            "-no-feature-netlistmgr"
            "-no-feature-networkdiskcache"
            "-no-feature-networkinterface"
            "-no-feature-networkproxy"
            "-no-feature-concurrent"
            "-no-feature-dnslookup"
            "-no-feature-dtls"
            "-no-feature-ftp"
            "-no-feature-http"
            "-no-feature-gssapi"
            "-no-feature-localserver"
            "-no-feature-ocsp"
            "-no-feature-socks5"
            "-no-feature-sspi"
            "-no-feature-udpsocket"
          ]
        else
          (
            # regular build, platform-independent options
            [
              "-gui"
              "-widgets"
              "-opengl desktop"
              "-accessibility"
              "-system-proxies"
              "-make libs"

              "-plugindir $(out)/$(qtPluginPrefix)"
              "-qmldir $(out)/$(qtQmlPrefix)"
              "-docdir $(out)/$(qtDocPrefix)"

              "-system-libjpeg"
              "-L"
              "${libjpeg.out}/lib"
              "-I"
              "${libjpeg.dev}/include"
              "-system-harfbuzz"
              "-L"
              "${harfbuzz.out}/lib"
              "-I"
              "${harfbuzz.dev}/include"
              "-system-pcre"
              "-openssl-linked"
              "-L"
              "${lib.getLib openssl}/lib"
              "-I"
              "${openssl.dev}/include"
              "-system-sqlite"
              ''-${if mysqlSupport then "plugin" else "no"}-sql-mysql''
              ''-${if libpq != null then "plugin" else "no"}-sql-psql''
              "-system-libpng"

            ]
            ++ lib.optional (qttranslations != null) [
              "-translationdir"
              "${qttranslations}/translations"
            ]
            ++ (
              # regular build, Darwin options
              # regular build, other Unixes options
              [
                "-xcb"
                "-qpa xcb"
                "-L"
                "${libX11.out}/lib"
                "-I"
                "${libX11.out}/include"
                "-L"
                "${libXext.out}/lib"
                "-I"
                "${libXext.out}/include"
                "-L"
                "${libXrender.out}/lib"
                "-I"
                "${libXrender.out}/include"

                ''-${lib.optionalString (cups == null) "no-"}cups''
                "-dbus-linked"
                "-glib"
              ]
              ++ lib.optional withGtk3 "-gtk"
              ++ lib.optional withLibinput "-libinput"
              ++ [
                "-inotify"
              ]
              ++ lib.optionals (cups != null) [
                "-L"
                "${cups.lib}/lib"
                "-I"
                "${cups.dev}/include"
              ]
              ++ lib.optionals (mysqlSupport) [
                "-L"
                "${libmysqlclient}/lib/mysql"
                "-I"
                "${libmysqlclient}/include/mysql"
              ]

            )
          )
      )

      # cross compilation options
      ++ lib.optionals isCrossBuild [
        "-xplatform ${nixCrossConf}"
        "-external-hostbindir ${qtbase-bootstrap.qmake}/bin"
      ]

      # debugging options
      ++ lib.optional debugSymbols "-debug"
      ++ lib.optionals developerBuild [
        "-developer-build"
        "-no-warnings-are-errors"
      ]

      # CPU features support
      ++ (
        if (!stdenv.hostPlatform.isx86_64) then
          [
            "-no-sse2"
          ]
        else
          [
            "-sse2"
            "${lib.optionalString (!stdenv.hostPlatform.sse3Support) "-no"}-sse3"
            "${lib.optionalString (!stdenv.hostPlatform.ssse3Support) "-no"}-ssse3"
            "${lib.optionalString (!stdenv.hostPlatform.sse4_1Support) "-no"}-sse4.1"
            "${lib.optionalString (!stdenv.hostPlatform.sse4_2Support) "-no"}-sse4.2"
            "${lib.optionalString (!stdenv.hostPlatform.avxSupport) "-no"}-avx"
            "${lib.optionalString (!stdenv.hostPlatform.avx2Support) "-no"}-avx2"
          ]
      )
      ++ [
        "-no-mips_dsp"
        "-no-mips_dspr2"
      ];

      # Move selected outputs.
      # I don't want to patch moveQtDevTools to support qmake output, so here's a bit of moving binaries around
      postInstall = ''
        moveToOutput "mkspecs" "$dev"

        # Move development tools to $dev and update paths to them in mkspecs
        moveQtDevTools

        # Move all binaries to $qmake
        mkdir -p "$qmake/bin"
        mv "$dev"/bin/* "$qmake/bin/"
        moveToOutput "bin" "$qmake"
        patchShebangs --host --update "$qmake"

        patchShebangs --host --update "$dev"

        # Symlinks from $dev to $qmake for backward compatibility
        mkdir -p "$dev/bin"
        lndir "$qmake/bin" "$dev/bin"
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

        # Don't propagate nativeBuildInputs
        sed '/HOST_QT_TOOLS/ d' -i $dev/mkspecs/qmodule.pri
        sed '/PKG_CONFIG_LIBDIR/ d' -i $dev/mkspecs/qconfig.pri

        # Dynamically detect cross-compilation. This patch breaks the build of qtbase itself, so we need to appy it late.
        patch -p1 -d $dev < ${postFixupPatch}

        fixQtModulePaths "''${!outputDev}/mkspecs/modules"
        fixQtBuiltinPaths "''${!outputDev}" '*.pr?'

        # fixup .pc file (where to find 'moc' etc.)
        sed -i "$dev/lib/pkgconfig/Qt5Core.pc" \
          -e "/^host_bins=/ c host_bins=$dev/bin"
      '';

      dontStrip = debugSymbols;

      setupHook = ../hooks/qtbase-setup-hook.sh;

      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

      meta = with lib; {
        homepage = "https://www.qt.io/";
        description = "Cross-platform application framework for C++";
        license = with licenses; [
          fdl13Plus
          gpl2Plus
          lgpl21Plus
          lgpl3Plus
        ];
        maintainers = with maintainers; [
          qknight
          ttuegel
          periklis
          bkchr
        ];
        pkgConfigModules = [
          "Qt5Concurrent"
          "Qt5Core"
          "Qt5DBus"
          "Qt5Gui"
          "Qt5Network"
          "Qt5OpenGL"
          "Qt5OpenGLExtensions"
          "Qt5PrintSupport"
          #"Qt5Qml"
          #"Qt5QmlModels"
          #"Qt5Quick"
          #"Qt5QuickTest"
          #"Qt5QuickWidgets"
          "Qt5Sql"
          "Qt5Test"
          "Qt5Widgets"
          "Qt5Xml"
        ];
        platforms = platforms.unix;
      };

    }
  )
)
