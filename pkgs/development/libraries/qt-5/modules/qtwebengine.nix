{ qtModule
, qtdeclarative, qtquickcontrols, qtlocation, qtwebchannel

, bison, flex, git, gperf, ninja, pkg-config, python, which
, nodejs, qtbase, perl

, xorg, libXcursor, libXScrnSaver, libXrandr, libXtst
, fontconfig, freetype, harfbuzz, icu, dbus, libdrm
, zlib, minizip, libjpeg, libpng, libtiff, libwebp, libopus
, jsoncpp, protobuf, libvpx, srtp, snappy, nss, libevent
, alsa-lib
, libcap
, pciutils
, systemd
, enableProprietaryCodecs ? true
, gn
, cctools, libobjc, libpm, libunwind, sandbox, xnu
, ApplicationServices, AVFoundation, Foundation, ForceFeedback, GameController, AppKit
, ImageCaptureCore, CoreBluetooth, IOBluetooth, CoreWLAN, Quartz, Cocoa, LocalAuthentication
, MediaPlayer, MediaAccessibility, SecurityInterface, Vision, CoreML, OpenDirectory, Accelerate
, cups, openbsm, runCommand, xcbuild, writeScriptBin
, ffmpeg_4 ? null
, lib, stdenv, fetchpatch
, version ? null
, qtCompatVersion
, pipewireSupport ? stdenv.isLinux
, pipewire_0_2
, postPatch ? ""
}:

qtModule {
  pname = "qtwebengine";
  qtInputs = [ qtdeclarative qtquickcontrols qtlocation qtwebchannel ];
  nativeBuildInputs = [
    bison flex git gperf ninja pkg-config python which gn nodejs
  ] ++ lib.optional stdenv.isDarwin xcbuild;
  doCheck = true;
  outputs = [ "bin" "dev" "out" ];

  enableParallelBuilding = true;

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

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isGNU [
    # with gcc8, -Wclass-memaccess became part of -Wall and this exceeds the logging limit
    "-Wno-class-memaccess"
  ] ++ lib.optionals (stdenv.hostPlatform.gcc.arch or "" == "sandybridge") [
    # it fails when compiled with -march=sandybridge https://github.com/NixOS/nixpkgs/pull/59148#discussion_r276696940
    # TODO: investigate and fix properly
    "-march=westmere"
  ] ++ lib.optionals stdenv.cc.isClang [
    "-Wno-elaborated-enum-base"
  ]);

  preConfigure = ''
    export NINJAFLAGS=-j$NIX_BUILD_CORES

    if [ -d "$PWD/tools/qmake" ]; then
        QMAKEPATH="$PWD/tools/qmake''${QMAKEPATH:+:}$QMAKEPATH"
    fi
  '';

  qmakeFlags = [ "--" "-system-ffmpeg" ]
    ++ lib.optional pipewireSupport "-webengine-webrtc-pipewire"
    ++ lib.optional enableProprietaryCodecs "-proprietary-codecs";

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
    ffmpeg_4
  ] ++ lib.optionals (!stdenv.isDarwin) [
    dbus zlib minizip snappy nss protobuf jsoncpp

    # Audio formats
    alsa-lib

    # Text rendering
    fontconfig freetype

    libcap
    pciutils

    # X11 libs
    xorg.xrandr libXScrnSaver libXcursor libXrandr xorg.libpciaccess libXtst
    xorg.libXcomposite xorg.libXdamage libdrm xorg.libxkbfile

  ] ++ lib.optionals pipewireSupport [
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

  postInstall = lib.optionalString stdenv.isLinux ''
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
    description = "A web engine based on the Chromium web browser";
    maintainers = with maintainers; [ matthewbauer ];

    # qtwebengine-5.15.8: "QtWebEngine can only be built for x86,
    # x86-64, ARM, Aarch64, and MIPSel architectures."
    platforms =
      lib.trivial.pipe lib.systems.doubles.all [
        (map (double: lib.systems.elaborate { system = double; }))
        (lib.lists.filter (parsedPlatform: with parsedPlatform;
          isUnix &&
          (isx86_32  ||
           isx86_64  ||
           isAarch32 ||
           isAarch64 ||
           (isMips && isLittleEndian))))
        (map (plat: plat.system))
      ];
    broken = stdenv.isDarwin && stdenv.isx86_64;

    # This build takes a long time; particularly on slow architectures
    timeout = 24 * 3600;
  };
}
