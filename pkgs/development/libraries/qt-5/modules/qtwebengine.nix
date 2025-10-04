{
  qtModule,
  qtdeclarative,
  qtquickcontrols,
  qtlocation,
  qtwebchannel,
  fetchpatch,
  fetchpatch2,
  srcs,

  bison,
  flex,
  gperf,
  ninja,
  pkg-config,
  which,
  nodejs,
  perl,
  buildPackages,

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
  openjpeg,
  libpng,
  libtiff,
  libwebp,
  libopus,
  libvpx,
  srtp,
  snappy,
  nss,
  libevent,
  lcms2,
  libxml2,
  libxslt,
  alsa-lib,
  pulseaudio,
  libcap,
  pciutils,
  systemd,
  enableProprietaryCodecs ? true,
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
}:

let
  isCrossBuild = stdenv.buildPlatform != stdenv.hostPlatform;

  # qtwebengine requires its own very particular specially patched for qt version of gn
  gnQtWebengine =
    with srcs.qtwebengine;
    buildPackages.gn.overrideAttrs {
      pname = "gn-qtwebengine";
      inherit src version;
      sourceRoot = "${src.name}/src/3rdparty/gn";
      configurePhase = ''
        # using $CXX as ld because the script uses --gc-sections, and ld doesn't recognize it.
        # on a related note, here we can see as QT developers intentionally de-standardize build tools:
        # https://github.com/qt/qtwebengine-chromium/commit/0e7e61966f9215babb0d4b32d97b9c0b73db1ca9
        python build/gen.py --no-last-commit-position --cc $CC --cxx $CXX --ld $CXX --ar $AR
      '';
      buildPhase = ''
        ninja -j $NIX_BUILD_CORES -C out gn
      '';
    };

  # Overriding stdenv seems to be a common thing for qt5 scope, so I'm using the
  # "__spliced or" construction here instead of pkgsBuildBuild.
  stdenvForBuildPlatform = stdenv.__spliced.buildBuild or stdenv;

  cflagsForPlatform =
    stdenv:
    toString (
      [ "-w " ]
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
      (buildPackages.python3.withPackages (ps: [ ps.html5lib ]))
      which
      gnQtWebengine
      nodejs
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [
      bootstrap_cmds
      xcbuild

      # FIXME These dependencies shouldn't be needed but can't find a way
      # around it. Chromium pulls this in while bootstrapping GN.
      cctools.libtool

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

    # For "host" builds in chromium. Only cc in depsBuildBuild will produce
    # _FOR_BUILD env variables that are used in qtwebengine-cross-build.patch.
    depsBuildBuild = [
      stdenvForBuildPlatform.cc
      pkg-config
      zlib
      nss
      icu
      # apparently chromium doesn't care if these deps are non-functional on the buildPlatform
      # but build fails if pkg-config can't find them
      libjpeg
      libpng
      libwebp
      freetype
      harfbuzz
    ];
    strictDeps = true;
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

      # support for building with python 3.12
      (fetchpatch2 {
        url = "https://salsa.debian.org/qt-kde-team/qt/qtwebengine/-/raw/313423e0178cee6eb9419c5803b982df2a71d689/debian/patches/python3.12-six.patch";
        hash = "sha256-gjc9sOPbcyHtJWnSHpkpupY6dIAODO20tiaTEtAfFr0=";
      })

      # Build with C++17, which is required by ICU 75
      (fetchpatch2 {
        url = "https://salsa.debian.org/qt-kde-team/qt/qtwebengine/-/raw/313423e0178cee6eb9419c5803b982df2a71d689/debian/patches/build-with-c++17.patch";
        hash = "sha256-1fhkj50radAc3uG386UnS735+LRe0Xs8jQOJtMqE7hQ=";
      })

      # Use system openjpeg
      (fetchpatch2 {
        url = "https://salsa.debian.org/qt-kde-team/qt/qtwebengine/-/raw/313423e0178cee6eb9419c5803b982df2a71d689/debian/patches/system-openjpeg2.patch";
        hash = "sha256-H3WwC40t0FRMGf1K2aXucrQjynMU/U/14goB4HK9/KM=";
      })

      # Use system lcms2
      (fetchpatch2 {
        url = "https://salsa.debian.org/qt-kde-team/qt/qtwebengine/-/raw/313423e0178cee6eb9419c5803b982df2a71d689/debian/patches/system-lcms2.patch";
        hash = "sha256-ccEbt5T54uXTV1pJnHI12NfYJ+QdUSUJFj0xcKcmtIA=";
      })
    ];

    postPatch = ''
      # Patch Chromium build tools
      (
        # Force configure to accept qtwebengine's own version of gn when passed from outside
        substituteInPlace configure.pri --replace 'qtLog("Gn version too old")' 'return(true)'

        cd src/3rdparty/chromium;

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
    + lib.optionalString stdenv.hostPlatform.isDarwin (''
      substituteInPlace src/buildtools/config/mac_osx.pri \
        --replace 'QMAKE_CLANG_DIR = "/usr"' 'QMAKE_CLANG_DIR = "${stdenv.cc}"'

      # Use system ffmpeg
      echo "gn_args += use_system_ffmpeg=true" >> src/core/config/mac_osx.pri
      echo "LIBS += -lavformat -lavcodec -lavutil" >> src/core/core_common.pri
    '')
    + postPatch;

    env = {
      NIX_CFLAGS_COMPILE = cflagsForPlatform stdenv;
      NIX_CFLAGS_COMPILE_FOR_BUILD = cflagsForPlatform stdenvForBuildPlatform;
    };

    preConfigure = ''
      export NINJAFLAGS=-j$NIX_BUILD_CORES
    '';

    qmakeFlags = [
      "--"
      "-feature-webengine-system-gn"
      "-webengine-icu"
    ]
    # webengine-embedded-build disables WebRTC, "Printing and PDF" and breaks PyQtWebEngine build.
    # It is automatically switched on for cross compilation. We probably always want it disabled.
    ++ lib.optional stdenv.hostPlatform.isLinux "-no-webengine-embedded-build"
    ++ lib.optional (ffmpeg != null) "-webengine-ffmpeg"
    ++ lib.optional (pipewireSupport && !isCrossBuild) "-webengine-webrtc-pipewire"
    ++ lib.optional enableProprietaryCodecs "-proprietary-codecs";

    propagatedBuildInputs = [
      qtdeclarative
      qtquickcontrols
      qtlocation
      qtwebchannel
    ];

    # Optional dependency on system-provided re2 library is not used here because it activates
    # some broken code paths in chromium.
    buildInputs = [
      # Image formats
      libjpeg
      openjpeg
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
      freetype

      libevent
      ffmpeg

      lcms2

      snappy
      minizip
      zlib
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      dbus
      nss

      # Audio formats
      alsa-lib
      pulseaudio

      # Text rendering
      fontconfig

      libcap
      pciutils

      # there's an explicit check for LIBXML_ICU_ENABLED at configuraion time
      # FIXME: still doesn't work because of the propagation of non-icu libxml2
      # from qtbase. Not sure what is the right move here.
      # FIXME: those could also be used on Darwin if we fix https://github.com/NixOS/nixpkgs/issues/272383
      (libxml2.override { icuSupport = true; })
      libxslt

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
    ++ lib.optionals (pipewireSupport && !isCrossBuild) [
      # Pipewire
      pipewire
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cups
    ];

    # to get progress output in `nix-build` and `nix build -L`
    preBuild = ''
      export TERM=dumb
    '';

    dontUseNinjaBuild = true;
    dontUseNinjaInstall = true;

    postInstall =
      lib.optionalString isCrossBuild ''
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
  // lib.optionalAttrs isCrossBuild {
    configurePlatforms = [ ];
  }
)
