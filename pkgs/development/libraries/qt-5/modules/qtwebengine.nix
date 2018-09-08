{ qtModule, qtCompatVersion,
  qtdeclarative, qtquickcontrols, qtlocation, qtwebchannel

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
, gn, darwin, openbsm
, ffmpeg ? null
, lib, stdenv # lib.optional, needsPax
}:

with stdenv.lib;

let qt56 = qtCompatVersion == "5.6"; in

qtModule {
  name = "qtwebengine";
  qtInputs = [ qtdeclarative qtquickcontrols qtlocation qtwebchannel ];
  nativeBuildInputs = [
    bison coreutils flex git gperf ninja pkgconfig python2 which gn
  ];
  doCheck = true;
  outputs = [ "bin" "dev" "out" ];

  enableParallelBuilding = true;

  # ninja builds some components with -Wno-format,
  # which cannot be set at the same time as -Wformat-security
  hardeningDisable = [ "format" ];

  postPatch =
    # Patch Chromium build tools
    ''
      ( cd src/3rdparty/chromium; patchShebangs . )
    ''
    # Patch Chromium build files
    + ''
      substituteInPlace ./src/3rdparty/chromium/build/common.gypi \
        --replace /bin/echo ${coreutils}/bin/echo
      substituteInPlace ./src/3rdparty/chromium/v8/${if qt56 then "build" else "gypfiles"}/toolchain.gypi \
        --replace /bin/echo ${coreutils}/bin/echo
      substituteInPlace ./src/3rdparty/chromium/v8/${if qt56 then "build" else "gypfiles"}/standalone.gypi \
        --replace /bin/echo ${coreutils}/bin/echo
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
      sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${systemd.lib}/lib/\1!' \
        src/3rdparty/chromium/device/udev_linux/udev?_loader.cc

      sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
        src/3rdparty/chromium/gpu/config/gpu_info_collector_linux.cc
    ''
    + optionalString stdenv.isDarwin ''
      # Remove annoying xcode check
      substituteInPlace mkspecs/features/platform.prf \
        --replace "lessThan(QMAKE_XCODE_VERSION, 7.3)" false
      substituteInPlace src/core/config/mac_osx.pri \
        --replace /usr ${stdenv.cc} \
        --replace "isEmpty(QMAKE_MAC_SDK_VERSION)" false

    # FIXME Needed with old Apple SDKs
    # Abandon all hope ye who try to make sense of this.
    substituteInPlace src/3rdparty/chromium/base/mac/foundation_util.mm \
      --replace "NSArray<NSString*>*" "NSArray*"
    substituteInPlace src/3rdparty/chromium/base/mac/sdk_forward_declarations.h \
      --replace "NSDictionary<VNImageOption, id>*" "NSDictionary*" \
      --replace "NSArray<VNRequest*>*" "NSArray*" \
      --replace "typedef NSString* VNImageOption NS_STRING_ENUM" "typedef NSString* VNImageOption"

    cat <<EOF > src/3rdparty/chromium/build/mac/find_sdk.py
#!/usr/bin/env python
print("10.10.0")
print("")
EOF

    cat <<EOF > src/3rdparty/chromium/build/config/mac/sdk_info.py
#!/usr/bin/env python
print('xcode_version="9.1"')
print('xcode_version_int=9')
print('xcode_build="9B55"')
print('machine_os_build="17E199"')
print('sdk_path=""')
print('sdk_version="10.10"')
print('sdk_platform_path=""')
print('sdk_build="17B41"')
EOF

    # Apple has some secret stuff they don't share with OpenBSM
    substituteInPlace src/3rdparty/chromium/base/mac/mach_port_broker.mm \
      --replace "audit_token_to_pid(msg.trailer.msgh_audit)" "msg.trailer.msgh_audit.val[5]"
    '';

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_10 -DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_10";

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
    ffmpeg
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
    Foundation
    AppKit
    ImageCaptureCore
    CoreBluetooth
    IOBluetooth
    CoreWLAN
    Quartz
    Cocoa

    openbsm
    libunwind
  ]);

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  postInstall = lib.optionalString stdenv.isLinux ''
    cat > $out/libexec/qt.conf <<EOF
    [Paths]
    Prefix = ..
    EOF
    paxmark m $out/libexec/QtWebEngineProcess
  '';

  meta = with lib; {
    description = "A web engine based on the Chromium web browser";
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.unix;
  };

}
