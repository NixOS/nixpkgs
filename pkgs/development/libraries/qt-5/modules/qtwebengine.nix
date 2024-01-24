{ qtModule
, qtdeclarative, qtquickcontrols, qtlocation, qtwebchannel
, srcs

, bison, flex, git, gperf, ninja, pkg-config, python, which
, nodejs, qtbase, perl
, buildPackages

, xorg, libXcursor, libXScrnSaver, libXrandr, libXtst
, fontconfig, freetype, harfbuzz, icu, dbus, libdrm
, zlib, minizip, libjpeg, libpng, libtiff, libwebp, libopus
, libvpx, srtp, snappy, nss, libevent
, lcms2, libxml2, libxslt
, alsa-lib
, pulseaudio
, libcap
, pciutils
, systemd
, enableProprietaryCodecs ? true
, cctools, libobjc, libpm, libunwind, sandbox, xnu
, ApplicationServices, AVFoundation, Foundation, ForceFeedback, GameController, AppKit
, ImageCaptureCore, CoreBluetooth, IOBluetooth, CoreWLAN, Quartz, Cocoa, LocalAuthentication
, MediaPlayer, MediaAccessibility, SecurityInterface, Vision, CoreML, OpenDirectory, Accelerate
, cups, openbsm, runCommand, xcbuild, writeScriptBin
, ffmpeg_4 ? null
, lib, stdenv
, version ? null
, qtCompatVersion
, pipewireSupport ? stdenv.isLinux
, pipewire_0_2
, postPatch ? ""
, dbusSupport ? !stdenv.isDarwin, expat
}:

let
  isCrossBuild = stdenv.buildPlatform != stdenv.hostPlatform;

  # qtwebengine requires its own very particular specially patched for qt version of gn
  gnQtWebengine = with srcs.qtwebengine; buildPackages.gn.overrideAttrs {
    pname = "gn-qtwebengine";
    inherit src version;
    sourceRoot = "${src.name}/src/3rdparty/gn";
    buildPhase = ''
      # using $CXX as ld because the script uses --gc-sections, and ld doesn't recognize it.
      # on a related note, here we can see as QT developers intentionally de-standardize build tools:
      # https://github.com/qt/qtwebengine-chromium/commit/0e7e61966f9215babb0d4b32d97b9c0b73db1ca9
      python build/gen.py --no-last-commit-position --cc $CC --cxx $CXX --ld $CXX --ar $AR
      ninja -j $NIX_BUILD_CORES -C out gn
    '';
  };

  # Overriding stdenv seems to be a common thing for qt5 scope, so I'm using the
  # "__spliced or" construction here instead of pkgsBuildBuild.
  # FIXME: on Darwin stdenv is always overriden in a way that prevents its splicing
  # even on a cross system, so we'll need to figure out a way to get a BuildBuild
  # version of it here.
  stdenvForBuildPlatform = stdenv.__spliced.buildBuild or stdenv;

  cflagsForPlatform = stdenv:
    toString (
      [ "-w "
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
in

qtModule ({
  pname = "qtwebengine";
  nativeBuildInputs = [
    bison flex git gperf ninja pkg-config python which nodejs gnQtWebengine
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild cctools

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
  depsBuildBuild = [ stdenvForBuildPlatform.cc pkg-config zlib nss icu
    # apparently chromium doesn't care if these deps are non-functional on the buildPlatform
    # but build fails if pkg-config can't find them
    libjpeg libpng libwebp freetype harfbuzz
  ];
  strictDeps = true;
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
      # Force configure to accept qtwebengine's own version of gn when passed from outside
      substituteInPlace configure.pri --replace 'qtLog("Gn version too old")' 'return(true)'

      cd src/3rdparty/chromium;

      # Manually fix unsupported shebangs
      substituteInPlace third_party/harfbuzz-ng/src/src/update-unicode-tables.make \
        --replace "/usr/bin/env -S make -f" "/usr/bin/make -f" || true

      # TODO: be more precise
      patchShebangs .

      # Fix compatibility with python3.11
      substituteInPlace tools/metrics/ukm/ukm_model.py \
        --replace "r'^(?i)(|true|false)$'" "r'(?i)^(|true|false)$'"
      substituteInPlace tools/grit/grit/util.py \
        --replace "mode = 'rU'" "mode = 'r'"
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
    NIX_CFLAGS_COMPILE = cflagsForPlatform stdenv;
    NIX_CFLAGS_COMPILE_FOR_BUILD = cflagsForPlatform stdenvForBuildPlatform;
  };

  preConfigure = ''
    export NINJAFLAGS=-j$NIX_BUILD_CORES
  '';

  qmakeFlags = [ "--" "-feature-webengine-system-gn" "-webengine-icu" ]
    # webengine-embedded-build disables WebRTC, "Printing and PDF" and breaks PyQtWebEngine build.
    # It is automatically switched on for cross compilation. We probably always want it disabled.
    ++ lib.optional stdenv.isLinux "-no-webengine-embedded-build"
    ++ lib.optional (ffmpeg_4 != null) "-webengine-ffmpeg"
    ++ lib.optional (pipewireSupport && !isCrossBuild) "-webengine-webrtc-pipewire"
    ++ lib.optional enableProprietaryCodecs "-proprietary-codecs";

  propagatedBuildInputs = [ qtdeclarative qtquickcontrols qtlocation qtwebchannel ];

  # Optional dependency on system-provided re2 library is not used here because it activates
  # some broken code paths in chromium.
  buildInputs = [
    # Image formats
    libjpeg libpng libtiff libwebp

    # Video formats
    srtp libvpx

    # Audio formats
    libopus

    # Text rendering
    harfbuzz icu freetype

    libevent
    ffmpeg_4

    lcms2

    snappy minizip zlib

  ] ++ lib.optionals (!stdenv.isDarwin) [
    dbus nss

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
    libxslt (libxml2.override { icuSupport=true; })

    # X11 libs
    xorg.xrandr libXScrnSaver libXcursor libXrandr xorg.libpciaccess libXtst
    xorg.libXcomposite xorg.libXdamage libdrm xorg.libxkbfile

  ] ++ lib.optionals (pipewireSupport && !isCrossBuild) [
    # Pipewire
    pipewire_0_2
  ]

  # FIXME These dependencies shouldn't be needed but can't find a way
  # around it. Chromium pulls this in while bootstrapping GN.
  ++ lib.optionals stdenv.isDarwin [
    libobjc

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

    cups
    libpm
    sandbox
  ];

  # to get progress output in `nix-build` and `nix build -L`
  preBuild = ''
    export TERM=dumb
  '';

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  postInstall = lib.optionalString isCrossBuild ''
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
    description = "A web engine based on the Chromium web browser";
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

} // lib.optionalAttrs isCrossBuild {
  configurePlatforms = [ ];
})
