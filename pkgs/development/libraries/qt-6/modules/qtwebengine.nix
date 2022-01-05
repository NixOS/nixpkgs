# FIXME configureFlags are ignored

/*

Configure summary:

WebEngine Repository Build Options:
  Build Ninja ............................ no
  Build Gn ............................... yes
  Jumbo Build ............................ yes
  Developer build ........................ no
  Build QtWebEngine Modules:
    Build QtWebEngineCore ................ yes
    Build QtWebEngineWidgets ............. yes
    Build QtWebEngineQuick ............... yes
  Build QtPdf Modules:
    Build QtPdfWidgets ................... no
    Build QtPdfQuick ..................... no
  Optional system libraries:
    re2 .................................. yes
    icu .................................. no
    libwebp, libwebpmux and libwebpdemux . yes
    opus ................................. yes
    ffmpeg ............................... no
    libvpx ............................... yes
    snappy ............................... yes
    glib ................................. yes
    zlib ................................. yes
    minizip .............................. yes
    libevent ............................. no
    libxml2 and libxslt .................. no
    lcms2 ................................ yes
    png .................................. yes
    jpeg ................................. yes
    harfbuzz ............................. yes
    freetype ............................. yes
    libpci ............................... yes
Qt WebEngineCore:
  Embedded build ......................... no
  Full debug information ................. no
  Sanitizer support ...................... no
  Pepper Plugins ......................... yes
  Printing and PDF ....................... yes
  Proprietary Codecs ..................... no
  Spellchecker ........................... yes
  Native Spellchecker .................... no
  WebRTC ................................. yes
  PipeWire over GIO ...................... no
  Geolocation ............................ yes
  WebChannel support ..................... yes
  Kerberos Authentication ................ no
  Extensions ............................. yes
  Support GLX on qpa-xcb ................. yes
  Use ALSA ............................... yes
  Use PulseAudio ......................... yes
Qt WebEngineQuick:
  UI Delegates ........................... yes

*/

{ qtModule
, qtdeclarative, qtwebchannel
, qtpositioning, qtwebsockets

, bison, coreutils, flex, git, gperf, ninja, pkg-config, python2, which
, nodejs, qtbase, perl

, xorg, libXcursor, libXScrnSaver, libXrandr, libXtst
, libxshmfence, libXi
, fontconfig, freetype, harfbuzz, icu, dbus, libdrm
, zlib, minizip, libjpeg, libpng, libtiff, libwebp, libopus
, jsoncpp, protobuf, libvpx, srtp, snappy, nss, libevent
, openssl
, alsa-lib
, pulseaudio
, libcap
, pciutils
, systemd
, pipewire_0_2
, enableProprietaryCodecs ? true
, gn
, cctools, libobjc, libunwind, sandbox, xnu
, ApplicationServices, AVFoundation, Foundation, ForceFeedback, GameController, AppKit
, ImageCaptureCore, CoreBluetooth, IOBluetooth, CoreWLAN, Quartz, Cocoa, LocalAuthentication
, cups, openbsm, runCommand, xcbuild, writeScriptBin
, ffmpeg
, lib, stdenv, fetchpatch
, version ? null
, qtCompatVersion
, glib
, libxml2
, libxslt
, lcms2
, re2

, libglvnd, libxkbcommon, vulkan-headers, libX11, libXcomposite
}:

qtModule rec {
  pname = "qtwebengine";
  qtInputs = [ qtdeclarative qtwebchannel qtwebsockets qtpositioning ];
  nativeBuildInputs = [
    bison coreutils flex git gperf ninja pkg-config python2 which gn nodejs
  ] ++ lib.optional stdenv.isDarwin xcbuild;
  doCheck = true;
  outputs = [ "bin" "dev" "out" ];

  enableParallelBuilding = true;

  /* breaks with ninja
  # debug: install is failing
  # splitBuildInstall requires cmake, not ninja
  splitBuildInstall =
  let
    # workaround for splitBuildInstall
    pname = "qtwebengine";
    version = "6.2.2";
    self = { inherit qtbase; };
    args = { postFixup = ""; };
  in
  {
    # needed to disable rebuild
    installPhase = ''
      runHook preInstall
      cd /build/$sourceRoot/build
      cmake -P cmake_install.cmake
      runHook postInstall
    '';
  };
  */

  # Don’t use the gn setup hook
  dontUseGnConfigure = true;

  # ninja builds some components with -Wno-format,
  # which cannot be set at the same time as -Wformat-security
  hardeningDisable = [ "format" ];

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
  '');

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

  preConfigure = ''
    # FIXME qt6: set this automatically
    export QT_ADDITIONAL_PACKAGES_PREFIX_PATH="${qtdeclarative.dev}:${qtwebsockets.dev}:${qtwebchannel.dev}:${qtpositioning.dev}"

    export NINJAFLAGS=-j$NIX_BUILD_CORES

    if [ -d "$PWD/tools/qmake" ]; then
        QMAKEPATH="$PWD/tools/qmake''${QMAKEPATH:+:}$QMAKEPATH"
    fi
  '';

  # FIXME flags are ignored
  configureFlags = [ "-system-ffmpeg" ]
    ++ lib.optional stdenv.isLinux "-webengine-webrtc-pipewire"
    ++ lib.optional enableProprietaryCodecs "-proprietary-codecs";
  qmakeFlags = [ "--" ] ++ configureFlags;

  propagatedBuildInputs = [

    # Image formats
    libjpeg libpng libtiff libwebp

    # Video formats
    srtp libvpx

    # Audio formats
    libopus

    # Text rendering
    harfbuzz icu

    openssl
    glib
    libxml2
    libxslt
    lcms2
    re2

    libevent
    ffmpeg

    # FIXME should be propagated by qtbase
    libglvnd libxkbcommon vulkan-headers libX11 libXcomposite

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
    libxshmfence libXi

    # Pipewire
    pipewire_0_2
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

  buildInputs = lib.optionals stdenv.isDarwin [
    cups
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
    timeout = 24 * 3600;
  };
}
