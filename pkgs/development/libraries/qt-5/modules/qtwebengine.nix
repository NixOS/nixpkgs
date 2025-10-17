{
  qtModule,
  qtdeclarative,
  qtquickcontrols,
  qtlocation,
  qtwebchannel,
  fetchpatch,
  fetchpatch2,

  bison,
  flex,
  gperf,
  ninja,
  pkg-config,
  python,
  which,
  nodejs,
  perl,
  buildPackages,
  pkgsBuildTarget,
  pkgsBuildBuild,

  xorg,
  libXcursor,
  libXScrnSaver,
  libXrandr,
  libXtst,
  fontconfig,
  freetype,
  harfbuzz,
  icu,
  dbus,
  libdrm,
  zlib,
  minizip,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  libopus,
  jsoncpp,
  protobuf,
  libvpx,
  srtp,
  snappy,
  nss,
  libevent,
  alsa-lib,
  pulseaudio,
  libcap,
  pciutils,
  systemd,
  enableProprietaryCodecs ? true,
  gn,
  cctools,
  cups,
  bootstrap_cmds,
  xcbuild,
  writeScriptBin,
  ffmpeg ? null,
  lib,
  stdenv,
  version ? null,
  qtCompatVersion,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  pipewire,
  postPatch ? "",
  nspr,
  lndir,
}:

let
  # qtwebengine expects to find an executable in $PATH which runs on
  # the build platform yet knows about the host `.pc` files.  Most
  # configury allows setting $PKG_CONFIG to point to an
  # arbitrarily-named script which serves this purpose; however QT
  # insists that it is named `pkg-config` with no target prefix.  So
  # we re-wrap the host platform's pkg-config.
  pkg-config-wrapped-without-prefix = stdenv.mkDerivation {
    name = "pkg-config-wrapper-without-target-prefix";
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      ln -s '${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config' $out/bin/pkg-config
    '';
  };

in

qtModule (
  {
    pname = "qtwebengine";
    nativeBuildInputs = [
      bison
      flex
      gperf
      ninja
      pkg-config
      (python.withPackages (ps: [ ps.html5lib ]))
      which
      gn
      nodejs
    ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      perl
      lndir
      (lib.getDev pkgsBuildTarget.targetPackages.qt5.qtbase)
      pkgsBuildBuild.pkg-config
      (lib.getDev pkgsBuildTarget.targetPackages.qt5.qtquickcontrols)
      pkg-config-wrapped-without-prefix
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [
      bootstrap_cmds
      xcbuild
    ];
    doCheck = true;
    outputs = [
      "bin"
      "dev"
      "out"
    ];

    enableParallelBuilding = true;

    # Don’t use the gn setup hook
    dontUseGnConfigure = true;

    # ninja builds some components with -Wno-format,
    # which cannot be set at the same time as -Wformat-security
    hardeningDisable = [ "format" ];

    patches = [
      # Support FFmpeg 5
      (fetchpatch2 {
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/qt5-webengine/-/raw/14074e4d789167bd776939037fe6df8d4d7dc0b3/qt5-webengine-ffmpeg5.patch";
        hash = "sha256-jTbJFXBPwRMzr8IeTxrv9dtS+/xDS/zR4dysV/bRg3I=";
        stripLen = 1;
        extraPrefix = "src/3rdparty/";
      })

      # Support FFmpeg 7
      (fetchpatch2 {
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/qt5-webengine/-/raw/e8fb4f86104243b90966b69cdfaa967273d834b6/qt5-webengine-ffmpeg7.patch";
        hash = "sha256-YNeHmOVp0M5HB+b91AOxxJxl+ktBtLYVdHlq13F7xtY=";
        stripLen = 1;
        extraPrefix = "src/3rdparty/chromium/";
      })

      # Support PipeWire ≥ 0.3
      (fetchpatch2 {
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/qt5-webengine/-/raw/c9db2cd9e144bd7a5e9246f5f7a01fe52fd089ba/qt5-webengine-pipewire-0.3.patch";
        hash = "sha256-mGexRfVDF3yjNzSi9BjavhzPtsXI0BooSr/rZ1z/BDo=";
        stripLen = 1;
        extraPrefix = "src/3rdparty/";
      })

      # Fix race condition exposed by missing dependency
      # https://bugs.gentoo.org/933368
      ./qtwebengine-fix_build_pdf_extension_util.patch

      # The latest version of Clang changed what macros it predefines on Apple
      # targets, causing errors about predefined macros in zlib.
      (fetchpatch2 {
        url = "https://github.com/chromium/chromium/commit/2f39ac8d0a414dd65c0e1d5aae38c8f97aa06ae9.patch";
        hash = "sha256-3kA2os0IntxIiJwzS5nPd7QWYlOWOpoLKYsOQFYv0Sk=";
        stripLen = 1;
        extraPrefix = "src/3rdparty/chromium/";
      })

      # The latest version of Clang changed what macros it predefines on Apple
      # targets, causing errors about predefined macros in libpng.
      (fetchpatch2 {
        url = "https://github.com/chromium/chromium/commit/66defc14abe47c0494da9faebebfa0a5b6efcf38.patch";
        hash = "sha256-ErS5Eycls5+xQLGYKz1r/tQC6IcRJWb/WoGsUyzO9WY=";
        stripLen = 1;
        extraPrefix = "src/3rdparty/chromium/";
      })

      # https://trac.macports.org/ticket/71563
      # src/3rdparty/chromium/third_party/freetype/src/src/gzip/ftzconf.h:228:12: error: unknown type name 'Byte'
      (fetchpatch2 {
        url = "https://github.com/macports/macports-ports/raw/f9a4136c48020b01ecc6dffa99b88333c360f056/aqua/qt5/files/patch-qtwebengine-chromium-freetype-gzip.diff";
        hash = "sha256-NeLmMfYMo80u3h+5GTenMANWfWLPeS35cKg+h3vzW4g=";
        extraPrefix = "";
      })

      # src/3rdparty/chromium/base/process/process_metrics_mac.cc:303:17: error: static assertion expression is not an integral constant expression
      (fetchpatch2 {
        url = "https://github.com/macports/macports-ports/raw/f9a4136c48020b01ecc6dffa99b88333c360f056/aqua/qt5/files/patch-qtwebengine_chromium_static_page_size.diff";
        hash = "sha256-8TFN5XU0SUvPJCFU6wvcKP5a8HCd0ygUnLT8BF4MZ/E=";
        extraPrefix = "";
      })

      # Add "-target-feature +aes" to the arm crc32c build flags
      (fetchpatch2 {
        url = "https://github.com/chromium/chromium/commit/9f43d823b6b4cdea62f0cc7563ff01f9239b8970.patch";
        hash = "sha256-2WCx+ZOWA8ZyV2yiSQLx9uFZOoeWQHxLqwLEZsV41QU=";
        stripLen = 1;
        extraPrefix = "src/3rdparty/chromium/";
      })

      # Fix build with clang and libc++ 19
      # https://github.com/freebsd/freebsd-ports/commit/0ddd6468fb3cb9ba390973520517cb1ca2cd690d
      (fetchpatch2 {
        url = "https://github.com/freebsd/freebsd-ports/raw/0ddd6468fb3cb9ba390973520517cb1ca2cd690d/www/qt5-webengine/files/patch-libc++19";
        hash = "sha256-pSVPnuEpjFHW60dbId5sZ3zHP709EWG4LSWoS+TkgcQ=";
        extraPrefix = "";
      })
      (fetchpatch2 {
        url = "https://github.com/freebsd/freebsd-ports/raw/0ddd6468fb3cb9ba390973520517cb1ca2cd690d/www/qt5-webengine/files/patch-src_3rdparty_chromium_third__party_blink_renderer_platform_wtf_hash__table.h";
        hash = "sha256-+vyWC7Indd1oBhvL5fMTlIH4mM4INgISZFAbHsq32Lg=";
        extraPrefix = "";
      })
      (fetchpatch2 {
        url = "https://github.com/freebsd/freebsd-ports/raw/0ddd6468fb3cb9ba390973520517cb1ca2cd690d/www/qt5-webengine/files/patch-src_3rdparty_chromium_third__party_perfetto_include_perfetto_tracing_internal_track__event__data__source.h";
        hash = "sha256-DcAYOV9b30ogPCiedvQimEmiZpUJquk5j6WLjJxR54U=";
        extraPrefix = "";
      })

      # Fix the build with gperf ≥ 3.2 and Clang 19.
      ./qtwebengine-gperf-3.2.patch
    ];

    postPatch = ''
      # Patch Chromium build tools
      (
        cd src/3rdparty/chromium;

        patch -p1 < ${
          (fetchpatch {
            # support for building with python 3.12
            name = "python312-six.patch";
            url = "https://gitlab.archlinux.org/archlinux/packaging/packages/qt5-webengine/-/raw/6b0c0e76e0934db2f84be40cb5978cee47266e78/python3.12-six.patch";
            hash = "sha256-YgP9Sq5+zTC+U7+0hQjZokwb+fytk0UEIJztUXFhTkI=";
          })
        }

        # Manually fix unsupported shebangs
        substituteInPlace third_party/harfbuzz-ng/src/src/update-unicode-tables.make \
          --replace "/usr/bin/env -S make -f" "/usr/bin/make -f" || true

        # TODO: be more precise
        patchShebangs .
      )
    ''
    # Prevent Chromium build script from making the path to `clang` relative to
    # the build directory.  `clang_base_path` is the value of `QMAKE_CLANG_DIR`
    # from `src/core/config/mac_osx.pri`.
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace ./src/3rdparty/chromium/build/toolchain/mac/BUILD.gn \
        --replace 'prefix = rebase_path("$clang_base_path/bin/", root_build_dir)' 'prefix = "$clang_base_path/bin/"'
    ''
    # Patch library paths in Qt sources
    + ''
      sed -i \
        -e "s,QLibraryInfo::location(QLibraryInfo::DataPath),QLatin1String(\"$out\"),g" \
        -e "s,QLibraryInfo::location(QLibraryInfo::TranslationsPath),QLatin1String(\"$out/translations\"),g" \
        -e "s,QLibraryInfo::location(QLibraryInfo::LibraryExecutablesPath),QLatin1String(\"$out/libexec\"),g" \
        src/core/web_engine_library_info.cpp
    ''
    # Patch library paths in Chromium sources
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${lib.getLib systemd}/lib/\1!' \
        src/3rdparty/chromium/device/udev_linux/udev?_loader.cc

      sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
        src/3rdparty/chromium/gpu/config/gpu_info_collector_linux.cc
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace src/buildtools/config/mac_osx.pri \
        --replace 'QMAKE_CLANG_DIR = "/usr"' 'QMAKE_CLANG_DIR = "${stdenv.cc}"'

      # Use system ffmpeg
      echo "gn_args += use_system_ffmpeg=true" >> src/core/config/mac_osx.pri
      echo "LIBS += -lavformat -lavcodec -lavutil" >> src/core/core_common.pri
    ''
    + postPatch;

    env = {
      NIX_CFLAGS_COMPILE = toString (
        lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
          "-w "
        ]
        ++ lib.optionals stdenv.cc.isGNU [
          # with gcc8, -Wclass-memaccess became part of -Wall and this exceeds the logging limit
          "-Wno-class-memaccess"
        ]
        ++ lib.optionals (stdenv.hostPlatform.gcc.arch or "" == "sandybridge") [
          # it fails when compiled with -march=sandybridge https://github.com/NixOS/nixpkgs/pull/59148#discussion_r276696940
          # TODO: investigate and fix properly
          "-march=westmere"
        ]
        ++ lib.optionals stdenv.cc.isClang [
          "-Wno-elaborated-enum-base"
          # 5.15.17: need to silence these two warnings
          # https://trac.macports.org/ticket/70850
          "-Wno-enum-constexpr-conversion"
          "-Wno-unused-but-set-variable"
          # Clang 19
          "-Wno-error=missing-template-arg-list-after-template-kw"
        ]
      );
    }
    // lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
      NIX_CFLAGS_LINK = "-Wl,--no-warn-search-mismatch";
      "NIX_CFLAGS_LINK_${buildPackages.stdenv.cc.suffixSalt}" = "-Wl,--no-warn-search-mismatch";
    };

    preConfigure = ''
      export NINJAFLAGS=-j$NIX_BUILD_CORES

      if [ -d "$PWD/tools/qmake" ]; then
          QMAKEPATH="$PWD/tools/qmake''${QMAKEPATH:+:}$QMAKEPATH"
      fi
    ''
    + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      export QMAKE_CC=$CC
      export QMAKE_CXX=$CXX
      export QMAKE_LINK=$CXX
      export QMAKE_AR=$AR
    '';

    qmakeFlags = [
      "--"
      "-system-ffmpeg"
    ]
    ++ lib.optional (
      pipewireSupport && stdenv.buildPlatform == stdenv.hostPlatform
    ) "-webengine-webrtc-pipewire"
    ++ lib.optional enableProprietaryCodecs "-proprietary-codecs";

    propagatedBuildInputs = [
      qtdeclarative
      qtquickcontrols
      qtlocation
      qtwebchannel

      # Image formats
      libjpeg
      libpng
      libtiff
      libwebp

      # Video formats
      srtp
      libvpx

      # Audio formats
      libopus

      # Text rendering
      harfbuzz
      icu

      libevent
      ffmpeg
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      dbus
      zlib
      minizip
      snappy
      nss
      protobuf
      jsoncpp

      # Audio formats
      alsa-lib
      pulseaudio

      # Text rendering
      fontconfig
      freetype

      libcap
      pciutils

      # X11 libs
      xorg.xrandr
      libXScrnSaver
      libXcursor
      libXrandr
      xorg.libpciaccess
      libXtst
      xorg.libXcomposite
      xorg.libXdamage
      libdrm
      xorg.libxkbfile

    ]
    ++ lib.optionals pipewireSupport [
      # Pipewire
      pipewire
    ]

    # FIXME These dependencies shouldn't be needed but can't find a way
    # around it. Chromium pulls this in while bootstrapping GN.
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools.libtool ];

    buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
      cups

      # `sw_vers` is used by `src/3rdparty/chromium/build/config/mac/sdk_info.py`
      # to get some information about the host platform.
      (writeScriptBin "sw_vers" ''
        #!${stdenv.shell}

        while [ $# -gt 0 ]; do
          case "$1" in
            -buildVersion) echo "17E199";;
          *) break ;;

          esac
          shift
        done
      '')
    ];

    dontUseNinjaBuild = true;
    dontUseNinjaInstall = true;

    postInstall =
      lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
        mkdir -p $out/libexec
      ''
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        cat > $out/libexec/qt.conf <<EOF
        [Paths]
        Prefix = ..
        EOF

      ''
      + ''
        # Fix for out-of-sync QtWebEngine and Qt releases (since 5.15.3)
        sed 's/${lib.head (lib.splitString "-" version)} /${qtCompatVersion} /' -i "$out"/lib/cmake/*/*Config.cmake
      '';

    requiredSystemFeatures = [ "big-parallel" ];

    meta = with lib; {
      description = "Web engine based on the Chromium web browser";
      mainProgram = "qwebengine_convert_dict";
      maintainers = with maintainers; [ matthewbauer ];

      # qtwebengine-5.15.8: "QtWebEngine can only be built for x86,
      # x86-64, ARM, Aarch64, and MIPSel architectures."
      platforms =
        with lib.systems.inspect.patterns;
        let
          inherit (lib.systems.inspect) patternLogicalAnd;
        in
        concatMap (patternLogicalAnd isUnix) (
          lib.concatMap lib.toList [
            isx86_32
            isx86_64
            isAarch32
            isAarch64
            (patternLogicalAnd isMips isLittleEndian)
          ]
        );

      # This build takes a long time; particularly on slow architectures
      timeout = 24 * 3600;

      knownVulnerabilities = [
        ''
          qt5 qtwebengine is unmaintained upstream since april 2025.
          It is based on chromium 87.0.4280.144, and supposedly patched up to 135.0.7049.95 which is outdated.

          Security issues are frequently discovered in chromium.
          The following list of CVEs was fixed in the life cycle of chromium 138 and likely also affects qtwebengine:
          - CVE-2025-8879
          - CVE-2025-8880
          - CVE-2025-8901
          - CVE-2025-8881
          - CVE-2025-8882
          - CVE-2025-8576
          - CVE-2025-8577
          - CVE-2025-8578
          - CVE-2025-8579
          - CVE-2025-8580
          - CVE-2025-8581
          - CVE-2025-8582
          - CVE-2025-8583
          - CVE-2025-8292
          - CVE-2025-8010
          - CVE-2025-8011
          - CVE-2025-7656
          - CVE-2025-6558 (known to be exploited in the wild)
          - CVE-2025-7657
          - CVE-2025-6554
          - CVE-2025-6555
          - CVE-2025-6556
          - CVE-2025-6557

          The actual list of CVEs affecting qtwebengine is likely much longer,
          as this list is missing issues fixed in chromium 136/137 and even more
          issues are continuously discovered and lack upstream fixes in qtwebengine.
        ''
      ];
    };

  }
  // lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
    configurePlatforms = [ ];
    # to get progress output in `nix-build` and `nix build -L`
    preBuild = ''
      export TERM=dumb
    '';
    depsBuildBuild = [
      pkgsBuildBuild.stdenv
      zlib
      nss
      nspr
    ];

  }
)
