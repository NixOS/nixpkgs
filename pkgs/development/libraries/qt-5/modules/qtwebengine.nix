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
, gn
, cups, darwin, openbsm, runCommand, xcbuild
, ffmpeg ? null
, lib, stdenv
}:

with stdenv.lib;

let qt56 = qtCompatVersion == "5.6"; in

qtModule {
  name = "qtwebengine";
  qtInputs = [ qtdeclarative qtquickcontrols qtlocation qtwebchannel ];
  nativeBuildInputs = [
    bison coreutils flex git gperf ninja pkgconfig python2 which gn
  ] ++ optional stdenv.isDarwin xcbuild;
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
    + optionalString (lib.versionOlder qtCompatVersion "5.12") ''
      substituteInPlace ./src/3rdparty/chromium/build/common.gypi --replace /bin/echo ${coreutils}/bin/echo
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
    + optionalString stdenv.isDarwin (''
      substituteInPlace src/core/config/mac_osx.pri \
        --replace /usr ${stdenv.cc}
    ''
    + (optionalString (lib.versionAtLeast qtCompatVersion "5.11") ''
      substituteInPlace src/3rdparty/chromium/third_party/crashpad/crashpad/util/BUILD.gn \
        --replace '$sysroot/usr' "${darwin.xnu}"
    '')
    + ''

    cat <<EOF > src/3rdparty/chromium/build/mac/find_sdk.py
#!/usr/bin/env python
print("${darwin.apple_sdk.sdk}")
print("10.12.0")
EOF

    cat <<EOF > src/3rdparty/chromium/build/config/mac/sdk_info.py
#!/usr/bin/env python
print('xcode_version="0910"')
print('xcode_version_int=910')
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

    substituteInPlace src/3rdparty/chromium/sandbox/mac/BUILD.gn \
      --replace 'libs = [ "sandbox" ]' 'libs = [ "/usr/lib/libsandbox.1.dylib" ]'
    '');

  NIX_CFLAGS_COMPILE =
  # it fails when compiled with -march=sandybridge https://github.com/NixOS/nixpkgs/pull/59148#discussion_r276696940
  # TODO: investigate and fix properly
    lib.optionals (stdenv.hostPlatform.platform.gcc.arch or "" == "sandybridge") [ "-march=westmere" ] ++
    lib.optionals stdenv.isDarwin [
      "-DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_10"
      "-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_10"

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

    openbsm
    libunwind
  ]);

  buildInputs = optionals stdenv.isDarwin (with darwin; [
    cups

    # For sandbox.h include
    (runCommand "MacOS_SDK_sandbox.h" {} ''
      install -Dm444 "${lib.getDev darwin.apple_sdk.sdk}"/include/sandbox.h "$out"/include/sandbox.h
    '')

    # For:
    # _NSDefaultRunLoopMode
    # _OBJC_CLASS_$_NSDate
    # _OBJC_CLASS_$_NSDictionary
    # _OBJC_CLASS_$_NSRunLoop
    # _OBJC_CLASS_$_NSURL
    darwin.cf-private
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
    broken = qt56; # 2018-09-13, no successful build since 2018-04-25
  };

}
