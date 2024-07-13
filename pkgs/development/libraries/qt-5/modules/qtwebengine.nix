{ qtModule
, qtdeclarative, qtquickcontrols, qtlocation, qtwebchannel
, fetchpatch
, fetchpatch2

, bison, flex, git, gperf, ninja, pkg-config, python, which
, nodejs, perl
, buildPackages
, pkgsBuildTarget
, pkgsBuildBuild

, xorg, libXcursor, libXScrnSaver, libXrandr, libXtst
, fontconfig, freetype, harfbuzz, icu, dbus, libdrm
, zlib, minizip, libjpeg, libpng, libtiff, libwebp, libopus
, jsoncpp, protobuf, libvpx, srtp, snappy, nss, libevent
, alsa-lib
, pulseaudio
, libcap
, pciutils
, systemd
, enableProprietaryCodecs ? true
, gn
, cctools, libobjc, libpm, libunwind, sandbox, xnu
, ApplicationServices, AVFoundation, Foundation, ForceFeedback, GameController, AppKit
, ImageCaptureCore, CoreBluetooth, IOBluetooth, CoreWLAN, Quartz, Cocoa, LocalAuthentication
, MediaPlayer, MediaAccessibility, SecurityInterface, Vision, CoreML, OpenDirectory, Accelerate
, cups, openbsm, xcbuild, writeScriptBin
, ffmpeg_7 ? null
, lib, stdenv
, version ? null
, qtCompatVersion
, pipewireSupport ? stdenv.isLinux
, pipewire
, postPatch ? ""
, nspr
, lndir
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

qtModule ({
  pname = "qtwebengine";
  nativeBuildInputs = [
    bison flex git gperf ninja pkg-config (python.withPackages(ps: [ ps.html5lib ])) which gn nodejs
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    perl
    lndir (lib.getDev pkgsBuildTarget.targetPackages.qt5.qtbase)
    pkgsBuildBuild.pkg-config
    (lib.getDev pkgsBuildTarget.targetPackages.qt5.qtquickcontrols)
    pkg-config-wrapped-without-prefix
  ] ++ lib.optional stdenv.isDarwin xcbuild;
  doCheck = true;
  outputs = [ "bin" "dev" "out" ];

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
  ];

  postPatch = ''
    # Patch Chromium build tools
    (
      cd src/3rdparty/chromium;

      patch -p2 < ${
        (fetchpatch { # support for building with python 3.12
          name = "python312-imp.patch";
          url = "https://codereview.qt-project.org/gitweb?p=qt/qtwebengine-chromium.git;a=patch;h=3664134f749f4851a14ab1953a9ee460a1fe0b68";
          hash = "sha256-XY0dEdeuOTRMR7onmuNg1Axld8+pquKAzOfDAGSIzI4=";
        })
      }
      patch -p1 < ${
        (fetchpatch { # support for building with python 3.12
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
  + lib.optionalString stdenv.isDarwin ''
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
  + lib.optionalString (!stdenv.isDarwin) ''
    sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${lib.getLib systemd}/lib/\1!' \
      src/3rdparty/chromium/device/udev_linux/udev?_loader.cc

    sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
      src/3rdparty/chromium/gpu/config/gpu_info_collector_linux.cc
  '' + lib.optionalString stdenv.isDarwin (''
    substituteInPlace src/buildtools/config/mac_osx.pri \
      --replace 'QMAKE_CLANG_DIR = "/usr"' 'QMAKE_CLANG_DIR = "${stdenv.cc}"'

    # Following is required to prevent a build error:
    # ninja: error: '/nix/store/z8z04p0ph48w22rqzx7ql67gy8cyvidi-SDKs/MacOSX10.12.sdk/usr/include/mach/exc.defs', needed by 'gen/third_party/crashpad/crashpad/util/mach/excUser.c', missing and no known rule to make it
    substituteInPlace src/3rdparty/chromium/third_party/crashpad/crashpad/util/BUILD.gn \
      --replace '$sysroot/usr' "${xnu}"

    # Apple has some secret stuff they don't share with OpenBSM
    substituteInPlace src/3rdparty/chromium/base/mac/mach_port_rendezvous.cc \
      --replace "audit_token_to_pid(request.trailer.msgh_audit)" "request.trailer.msgh_audit.val[5]"
    substituteInPlace src/3rdparty/chromium/third_party/crashpad/crashpad/util/mach/mach_message.cc \
      --replace "audit_token_to_pid(audit_trailer->msgh_audit)" "audit_trailer->msgh_audit.val[5]"

    # ld: warning: directory not found for option '-L/nix/store/...-xcodebuild-0.1.2-pre/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk/usr/lib'
    # ld: fatal warning(s) induced error (-fatal_warnings)
    substituteInPlace src/3rdparty/chromium/build/config/compiler/BUILD.gn \
      --replace "-Wl,-fatal_warnings" ""
  '') + postPatch;

  env = {
    NIX_CFLAGS_COMPILE =
      toString (
        lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
          "-w "
        ] ++ lib.optionals stdenv.cc.isGNU [
          # with gcc8, -Wclass-memaccess became part of -Wall and this exceeds the logging limit
          "-Wno-class-memaccess"
        ] ++ lib.optionals (stdenv.hostPlatform.gcc.arch or "" == "sandybridge") [
          # it fails when compiled with -march=sandybridge https://github.com/NixOS/nixpkgs/pull/59148#discussion_r276696940
          # TODO: investigate and fix properly
          "-march=westmere"
        ] ++ lib.optionals stdenv.cc.isClang [
          "-Wno-elaborated-enum-base"
        ]);
  } // lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
    NIX_CFLAGS_LINK = "-Wl,--no-warn-search-mismatch";
    "NIX_CFLAGS_LINK_${buildPackages.stdenv.cc.suffixSalt}" = "-Wl,--no-warn-search-mismatch";
  };

  preConfigure = ''
    export NINJAFLAGS=-j$NIX_BUILD_CORES

    if [ -d "$PWD/tools/qmake" ]; then
        QMAKEPATH="$PWD/tools/qmake''${QMAKEPATH:+:}$QMAKEPATH"
    fi
  '' + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    export QMAKE_CC=$CC
    export QMAKE_CXX=$CXX
    export QMAKE_LINK=$CXX
    export QMAKE_AR=$AR
  '';

  qmakeFlags = [ "--" "-system-ffmpeg" ]
    ++ lib.optional (pipewireSupport && stdenv.buildPlatform == stdenv.hostPlatform) "-webengine-webrtc-pipewire"
    ++ lib.optional enableProprietaryCodecs "-proprietary-codecs";

  propagatedBuildInputs = [
    qtdeclarative qtquickcontrols qtlocation qtwebchannel

    # Image formats
    libjpeg libpng libtiff libwebp

    # Video formats
    srtp libvpx

    # Audio formats
    libopus

    # Text rendering
    harfbuzz icu

    libevent
    ffmpeg_7
  ] ++ lib.optionals (!stdenv.isDarwin) [
    dbus zlib minizip snappy nss protobuf jsoncpp

    # Audio formats
    alsa-lib
    pulseaudio

    # Text rendering
    fontconfig freetype

    libcap
    pciutils

    # X11 libs
    xorg.xrandr libXScrnSaver libXcursor libXrandr xorg.libpciaccess libXtst
    xorg.libXcomposite xorg.libXdamage libdrm xorg.libxkbfile

  ] ++ lib.optionals pipewireSupport [
    # Pipewire
    pipewire
  ]

  # FIXME These dependencies shouldn't be needed but can't find a way
  # around it. Chromium pulls this in while bootstrapping GN.
  ++ lib.optionals stdenv.isDarwin [
    libobjc
    cctools

    # frameworks
    ApplicationServices
    AVFoundation
    Foundation
    ForceFeedback
    GameController
    AppKit
    ImageCaptureCore
    CoreBluetooth
    IOBluetooth
    CoreWLAN
    Quartz
    Cocoa
    LocalAuthentication
    MediaPlayer
    MediaAccessibility
    SecurityInterface
    Vision
    CoreML
    OpenDirectory
    Accelerate

    openbsm
    libunwind
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    cups
    libpm
    sandbox

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

  postInstall = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    mkdir -p $out/libexec
  '' + lib.optionalString stdenv.isLinux ''
    cat > $out/libexec/qt.conf <<EOF
    [Paths]
    Prefix = ..
    EOF

  '' + ''
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
    platforms = with lib.systems.inspect.patterns;
      let inherit (lib.systems.inspect) patternLogicalAnd;
      in concatMap (patternLogicalAnd isUnix) (lib.concatMap lib.toList [
        isx86_32
        isx86_64
        isAarch32
        isAarch64
        (patternLogicalAnd isMips isLittleEndian)
      ]);

    # This build takes a long time; particularly on slow architectures
    timeout = 24 * 3600;
  };

} // lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
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

})
