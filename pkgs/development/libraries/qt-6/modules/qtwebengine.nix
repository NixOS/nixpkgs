{ qtModule
, qtdeclarative
, qtwebchannel
, qtpositioning
, qtwebsockets
, buildPackages
, bison
, coreutils
, flex
, git
, gperf
, ninja
, pkg-config
, python3
, which
, nodejs
, xorg
, libXcursor
, libXScrnSaver
, libXrandr
, libXtst
, libxshmfence
, libXi
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
, gn
, ffmpeg_4
, lib
, stdenv
, glib
, libxml2
, libxslt
, lcms2
, libkrb5
, mesa
, enableProprietaryCodecs ? true
  # darwin
, bootstrap_cmds
, cctools
, xcbuild
, AGL
, AVFoundation
, Accelerate
, Cocoa
, CoreLocation
, CoreML
, ForceFeedback
, GameController
, ImageCaptureCore
, LocalAuthentication
, MediaAccessibility
, MediaPlayer
, MetalKit
, Network
, OpenDirectory
, Quartz
, ReplayKit
, SecurityInterface
, Vision
, openbsm
, libunwind
, cups
, libpm
, sandbox
, xnu
}:

qtModule {
  pname = "qtwebengine";
  nativeBuildInputs = [
    bison
    coreutils
    flex
    git
    gperf
    ninja
    pkg-config
    (python3.withPackages (ps: with ps; [ html5lib ]))
    which
    gn
    nodejs
  ] ++ lib.optionals stdenv.isDarwin [
    bootstrap_cmds
    cctools
    xcbuild
  ];
  doCheck = true;
  outputs = [ "out" "dev" ];

  dontUseGnConfigure = true;

  # ninja builds some components with -Wno-format,
  # which cannot be set at the same time as -Wformat-security
  hardeningDisable = [ "format" ];

  patches = [
    # removes macOS 12+ dependencies
    ../patches/qtwebengine-darwin-no-low-latency-flag.patch
    ../patches/qtwebengine-darwin-no-copy-certificate-chain.patch
    # Don't assume /usr/share/X11, and also respect the XKB_CONFIG_ROOT
    # environment variable, since NixOS relies on it working.
    # See https://github.com/NixOS/nixpkgs/issues/226484 for more context.
    ../patches/qtwebengine-xkb-includes.patch

    ../patches/qtwebengine-link-pulseaudio.patch

    # Override locales install path so they go to QtWebEngine's $out
    ../patches/qtwebengine-locales-path.patch
  ];

  postPatch = ''
    # Patch Chromium build tools
    (
      cd src/3rdparty/chromium;

      # Manually fix unsupported shebangs
      substituteInPlace third_party/harfbuzz-ng/src/src/update-unicode-tables.make \
        --replace "/usr/bin/env -S make -f" "/usr/bin/make -f" || true
      substituteInPlace third_party/webgpu-cts/src/tools/run_deno \
        --replace "/usr/bin/env -S deno" "/usr/bin/deno" || true
      patchShebangs .
    )

    substituteInPlace cmake/Functions.cmake \
      --replace "/bin/bash" "${buildPackages.bash}/bin/bash"

    # Patch library paths in sources
    substituteInPlace src/core/web_engine_library_info.cpp \
      --replace "QLibraryInfo::path(QLibraryInfo::DataPath)" "\"$out\"" \
      --replace "QLibraryInfo::path(QLibraryInfo::TranslationsPath)" "\"$out/translations\"" \
      --replace "QLibraryInfo::path(QLibraryInfo::LibraryExecutablesPath)" "\"$out/libexec\""
  ''
  + lib.optionalString stdenv.isLinux ''
    sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${lib.getLib systemd}/lib/\1!' \
      src/3rdparty/chromium/device/udev_linux/udev?_loader.cc

    sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
      src/3rdparty/chromium/gpu/config/gpu_info_collector_linux.cc
  ''
  + lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure.cmake src/gn/CMakeLists.txt \
      --replace "AppleClang" "Clang"
    substituteInPlace cmake/Functions.cmake \
      --replace "/usr/bin/xcrun" "${xcbuild}/bin/xcrun"
    substituteInPlace src/3rdparty/chromium/third_party/crashpad/crashpad/util/BUILD.gn \
      --replace "\$sysroot/usr" "${xnu}"
  '';

  cmakeFlags = [
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
    # android only. https://bugreports.qt.io/browse/QTBUG-100293
    # "-DQT_FEATURE_webengine_native_spellchecker=ON"
    "-DQT_FEATURE_webengine_sanitizer=ON"
    "-DQT_FEATURE_webengine_kerberos=ON"
  ] ++ lib.optionals stdenv.isLinux [
    "-DQT_FEATURE_webengine_webrtc_pipewire=ON"
  ] ++ lib.optionals enableProprietaryCodecs [
    "-DQT_FEATURE_webengine_proprietary_codecs=ON"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.targetPlatform.darwinSdkVersion}"
  ];

  propagatedBuildInputs = [
    qtdeclarative
    qtwebchannel
    qtwebsockets
    qtpositioning

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

    libevent
    ffmpeg_4
  ] ++ lib.optionals stdenv.isLinux [
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
    xorg.libXext

    # Pipewire
    pipewire

    libkrb5
    mesa
  ] ++ lib.optionals stdenv.isDarwin [
    AGL
    AVFoundation
    Accelerate
    Cocoa
    CoreLocation
    CoreML
    ForceFeedback
    GameController
    ImageCaptureCore
    LocalAuthentication
    MediaAccessibility
    MediaPlayer
    MetalKit
    Network
    OpenDirectory
    Quartz
    ReplayKit
    SecurityInterface
    Vision

    openbsm
    libunwind
  ];

  buildInputs = [
    cups
  ] ++ lib.optionals stdenv.isDarwin [
    libpm
    sandbox
  ];

  requiredSystemFeatures = [ "big-parallel" ];

  preConfigure = ''
    export NINJAFLAGS="-j$NIX_BUILD_CORES"
  '';

  meta = with lib; {
    description = "A web engine based on the Chromium web browser";
    platforms = [ "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7a-linux" "armv7l-linux" "x86_64-linux" ];
    # This build takes a long time; particularly on slow architectures
    # 1 hour on 32x3.6GHz -> maybe 12 hours on 4x2.4GHz
    timeout = 24 * 3600;
  };
}
