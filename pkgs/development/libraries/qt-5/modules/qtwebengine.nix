{ qtModule
, qtdeclarative, qtquickcontrols, qtlocation, qtwebchannel

, bison, coreutils, flex, git, gperf, ninja, pkgconfig, python2, which

, xorg, libXcursor, libXScrnSaver, libXrandr, libXtst
, fontconfig, freetype, harfbuzz, icu, dbus, libdrm
, zlib, minizip, libjpeg, libpng, libtiff, libwebp, libopus
, jsoncpp, protobuf, libvpx, srtp, snappy, nss, libevent
, alsaLib
, libcap
, pciutils
, systemd
, enableProprietaryCodecs ? true
, gn
, cups, darwin, openbsm, runCommand, xcbuild, writeScriptBin
, ffmpeg_3 ? null
, lib, stdenv, fetchpatch
}:

with stdenv.lib;

qtModule {
  name = "qtwebengine";
  qtInputs = [ qtdeclarative qtquickcontrols qtlocation qtwebchannel ];
  nativeBuildInputs = [
    bison coreutils flex git gperf ninja pkgconfig python2 which gn
  ] ++ optional stdenv.isDarwin xcbuild;
  doCheck = true;
  outputs = [ "bin" "dev" "out" ];

  enableParallelBuilding = true;

  # Don’t use the gn setup hook
  dontUseGnConfigure = true;

  # ninja builds some components with -Wno-format,
  # which cannot be set at the same time as -Wformat-security
  hardeningDisable = [ "format" ];

  postPatch =
    # Patch Chromium build tools
    ''
      ( cd src/3rdparty/chromium; patchShebangs . )
    ''
    # Prevent Chromium build script from making the path to `clang` relative to
    # the build directory.  `clang_base_path` is the value of `QMAKE_CLANG_DIR`
    # from `src/core/config/mac_osx.pri`.
    + optionalString stdenv.isDarwin ''
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
    + optionalString (!stdenv.isDarwin) ''
      sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${lib.getLib systemd}/lib/\1!' \
        src/3rdparty/chromium/device/udev_linux/udev?_loader.cc

      sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
        src/3rdparty/chromium/gpu/config/gpu_info_collector_linux.cc
    ''
    + optionalString stdenv.isDarwin (''
      substituteInPlace src/core/config/mac_osx.pri \
        --replace 'QMAKE_CLANG_DIR = "/usr"' 'QMAKE_CLANG_DIR = "${stdenv.cc}"'
    ''
     # Following is required to prevent a build error:
     # ninja: error: '/nix/store/z8z04p0ph48w22rqzx7ql67gy8cyvidi-SDKs/MacOSX10.12.sdk/usr/include/mach/exc.defs', needed by 'gen/third_party/crashpad/crashpad/util/mach/excUser.c', missing and no known rule to make it
    + ''
      substituteInPlace src/3rdparty/chromium/third_party/crashpad/crashpad/util/BUILD.gn \
        --replace '$sysroot/usr' "${darwin.xnu}"
    ''
    + ''
    # Apple has some secret stuff they don't share with OpenBSM
    substituteInPlace src/3rdparty/chromium/base/mac/mach_port_broker.mm \
      --replace "audit_token_to_pid(msg.trailer.msgh_audit)" "msg.trailer.msgh_audit.val[5]"

    substituteInPlace src/3rdparty/chromium/sandbox/mac/BUILD.gn \
      --replace 'libs = [ "sandbox" ]' 'libs = [ "/usr/lib/libsandbox.1.dylib" ]'
    '');

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [
    # with gcc8, -Wclass-memaccess became part of -Wall and this exceeds the logging limit
    "-Wno-class-memaccess"
  ] ++ lib.optionals (stdenv.hostPlatform.platform.gcc.arch or "" == "sandybridge") [
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
    export NINJAFLAGS=-j$NIX_BUILD_CORES

    if [ -d "$PWD/tools/qmake" ]; then
        QMAKEPATH="$PWD/tools/qmake''${QMAKEPATH:+:}$QMAKEPATH"
    fi
   '';

  qmakeFlags = if stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64
    then [ "--" "-system-ffmpeg" ] ++ optional enableProprietaryCodecs "-proprietary-codecs"
    else optional enableProprietaryCodecs "-- -proprietary-codecs";

  propagatedBuildInputs = [
    # Image formats
    libjpeg libpng libtiff libwebp

    # Video formats
    srtp libvpx

    # Audio formats
    libopus

    # Text rendering
    harfbuzz icu

    libevent
  ] ++ optionals (stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) [
    ffmpeg_3
  ] ++ optionals (!stdenv.isDarwin) [
    dbus zlib minizip snappy nss protobuf jsoncpp

    # Audio formats
    alsaLib

    # Text rendering
    fontconfig freetype

    libcap
    pciutils

    # X11 libs
    xorg.xrandr libXScrnSaver libXcursor libXrandr xorg.libpciaccess libXtst
    xorg.libXcomposite xorg.libXdamage libdrm
  ]

  # FIXME These dependencies shouldn't be needed but can't find a way
  # around it. Chromium pulls this in while bootstrapping GN.
  ++ lib.optionals stdenv.isDarwin (with darwin; with apple_sdk.frameworks; [
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
  ]);

  buildInputs = optionals stdenv.isDarwin (with darwin; [
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

    # For sandbox.h include
    (runCommand "MacOS_SDK_sandbox.h" {} ''
      install -Dm444 "${lib.getDev darwin.apple_sdk.sdk}"/include/sandbox.h "$out"/include/sandbox.h
    '')
  ]);

  __impureHostDeps = optional stdenv.isDarwin "/usr/lib/libsandbox.1.dylib";

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseXcbuild = true;

  postInstall = lib.optionalString stdenv.isLinux ''
    cat > $out/libexec/qt.conf <<EOF
    [Paths]
    Prefix = ..
    EOF
  '';

  meta = with lib; {
    description = "A web engine based on the Chromium web browser";
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.unix;
  };

}
