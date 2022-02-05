{ qtModule
, qtdeclarative
, qtwebchannel
, qtpositioning
, qtwebsockets
, bison
, coreutils
, flex
, git
, gperf
, ninja
  # ninja is hard requirement for buildPhase
  # https://bugreports.qt.io/browse/QTBUG-96897
, pkg-config
, python2
, which
, nodejs
, qtbase
, perl
, xorg
, libXcursor
, libXScrnSaver
, libXrandr
, libXtst
, libxshmfence
, libXi
, xlibs
, fontconfig
, freetype
, harfbuzz
, icu
, dbus
, libdrm
, zlib
, minizip
, libjpeg
, libpng
, libtiff
, libwebp
, libopus
, jsoncpp
, protobuf
, libvpx
, srtp
, snappy
, nss
, libevent
, openssl
, alsa-lib
, pulseaudio
, libcap
, pciutils
, systemd
, pipewire
, enableProprietaryCodecs ? true
, gn
  # TODO(milahu) remove gn?
  # -- Could NOT find Gn: Found unsuitable version "1718 (fd3d768)", but required is exact version "6.2.2"
, cctools
, libobjc
, libunwind
, sandbox
, xnu
, ApplicationServices
, AVFoundation
, Foundation
, ForceFeedback
, GameController
, AppKit
, ImageCaptureCore
, CoreBluetooth
, IOBluetooth
, CoreWLAN
, Quartz
, Cocoa
, LocalAuthentication
, cups
, openbsm
, runCommand
, xcbuild
, writeScriptBin
, ffmpeg
, lib
, stdenv
, fetchpatch
, qtCompatVersion
, glib
, libxml2
, libxslt
, lcms2
, re2
, kerberos
}:

# TODO(milahu) add optional dependencies? Qt6QmlCompilerPlus Qt6Designer

qtModule rec {
  pname = "qtwebengine";
  qtInputs = [ qtdeclarative qtwebchannel qtwebsockets qtpositioning ];
  nativeBuildInputs = [
    bison
    coreutils
    flex
    git
    gperf
    ninja
    pkg-config
    python2 # not python3
    which
    gn
    nodejs
  ] ++ lib.optional stdenv.isDarwin xcbuild;
  doCheck = true;
  outputs = [ "out" "bin" "dev" ];

  enableParallelBuilding = true;

  # Don’t use the gn setup hook
  dontUseGnConfigure = true;

  # ninja builds some components with -Wno-format,
  # which cannot be set at the same time as -Wformat-security
  hardeningDisable = [ "format" ];

  # disable ninja line-clearing
  # TODO move to ninja setupHook
  preBuild = ''
    export TERM=dumb
  '';

  postPatch = ''
    # Patch Chromium build tools
    (
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
  '' + lib.optionalString stdenv.isDarwin (
    ''
      substituteInPlace src/buildtools/config/mac_osx.pri \
        --replace 'QMAKE_CLANG_DIR = "/usr"' 'QMAKE_CLANG_DIR = "${stdenv.cc}"'
    ''
    # Following is required to prevent a build error:
    # ninja: error: '/nix/store/z8z04p0ph48w22rqzx7ql67gy8cyvidi-SDKs/MacOSX10.12.sdk/usr/include/mach/exc.defs', needed by 'gen/third_party/crashpad/crashpad/util/mach/excUser.c', missing and no known rule to make it
    + ''
        substituteInPlace src/3rdparty/chromium/third_party/crashpad/crashpad/util/BUILD.gn \
          --replace '$sysroot/usr' "${xnu}"
      # Apple has some secret stuff they don't share with OpenBSM
      substituteInPlace src/3rdparty/chromium/base/mac/mach_port_rendezvous.cc \
        --replace "audit_token_to_pid(request.trailer.msgh_audit)" "request.trailer.msgh_audit.val[5]"
      substituteInPlace src/3rdparty/chromium/third_party/crashpad/crashpad/util/mach/mach_message.cc \
        --replace "audit_token_to_pid(audit_trailer->msgh_audit)" "audit_trailer->msgh_audit.val[5]"
    ''
  );

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [
    # with gcc8, -Wclass-memaccess became part of -Wall and this exceeds the logging limit
    "-Wno-class-memaccess"
  ] ++ lib.optionals (stdenv.hostPlatform.gcc.arch or "" == "sandybridge") [
    # it fails when compiled with -march=sandybridge https://github.com/NixOS/nixpkgs/pull/59148#discussion_r276696940
    # TODO: investigate and fix properly
    "-march=westmere"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_12"
    "-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_12"

    #
    # Prevent errors like
    # /nix/store/xxx-apple-framework-CoreData/Library/Frameworks/CoreData.framework/Headers/NSEntityDescription.h:51:7:
    # error: pointer to non-const type 'id' with no explicit ownership
    #     id** _kvcPropertyAccessors;
    #
    # TODO remove when new Apple SDK is in
    #
    "-fno-objc-arc"
  ];

  # FIXME set in hook: QT_ADDITIONAL_PACKAGES_PREFIX_PATH
  preConfigure = ''
    export QT_ADDITIONAL_PACKAGES_PREFIX_PATH="${qtdeclarative.dev}:${qtwebsockets.dev}:${qtwebchannel.dev}:${qtpositioning.dev}"

    export NINJAFLAGS=-j$NIX_BUILD_CORES

    if [ -d "$PWD/tools/qmake" ]; then
        QMAKEPATH="$PWD/tools/qmake''${QMAKEPATH:+:}$QMAKEPATH"
    fi
  '';

  cmakeFlags =
    [
      "-DQT_FEATURE_qtpdf_build=ON"
      "-DQT_FEATURE_qtpdf_widgets_build=ON"
      "-DQT_FEATURE_qtpdf_quick_build=ON"
      "-DQT_FEATURE_pdf_v8=ON"
      "-DQT_FEATURE_pdf_xfa=ON"
      "-DQT_FEATURE_pdf_xfa_bmp=ON"
      "-DQT_FEATURE_pdf_xfa_gif=ON"
      "-DQT_FEATURE_pdf_xfa_png=ON"
      "-DQT_FEATURE_pdf_xfa_tiff=ON"
      "-DQT_FEATURE_webengine_system_icu=ON"
      "-DQT_FEATURE_webengine_system_libevent=ON"
      "-DQT_FEATURE_webengine_system_libxml=ON"
      "-DQT_FEATURE_webengine_system_ffmpeg=ON"
      #"-DQT_FEATURE_webengine_native_spellchecker=ON" # android only. https://bugreports.qt.io/browse/QTBUG-100293
      "-DQT_FEATURE_webengine_kerberos=ON" # auth -> requires include/gssapi.h -> kerberos
      "-DQT_FEATURE_webengine_sanitizer=ON"
    ]
    ++ lib.optional stdenv.isLinux "-DQT_FEATURE_webengine_webrtc_pipewire=ON" # TODO(milahu) why linux only? (ported from qt5)
    ++ lib.optional enableProprietaryCodecs "-DQT_FEATURE_webengine_proprietary_codecs=ON"
  ;

  propagatedBuildInputs = [

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

    openssl
    glib
    libxml2
    libxslt
    lcms2
    re2

    libevent
    ffmpeg

    kerberos

  ] ++ lib.optionals (!stdenv.isDarwin) [
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
    libxshmfence
    libXi
    xlibs.libXext

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

    openbsm
    libunwind
  ];

  buildInputs = [
    cups
    cups.dev # cups-config is used in buildPhase # TODO propagatedBuildInputs?
  ] ++ lib.optionals stdenv.isDarwin [
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

  postInstall = lib.optionalString stdenv.isLinux ''
    cat > $out/libexec/qt.conf <<EOF
    [Paths]
    Prefix = ..
    EOF
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "A web engine based on the Chromium web browser";
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.unix;
    # This build takes a long time; particularly on slow architectures
    # 1 hour on 32x3.6GHz -> maybe 12 hours on 4x2.4GHz
    timeout = 24 * 3600;
  };
}
