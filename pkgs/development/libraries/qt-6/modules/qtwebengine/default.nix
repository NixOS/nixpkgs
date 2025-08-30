{
  qtModule,
  qtdeclarative,
  qtwebchannel,
  qtpositioning,
  qtwebsockets,
  buildPackages,
  bison,
  coreutils,
  flex,
  gperf,
  ninja,
  pkg-config,
  python3,
  which,
  nodejs,
  xorg,
  libXcursor,
  libXScrnSaver,
  libXrandr,
  libXtst,
  libxshmfence,
  libXi,
  cups,
  fontconfig,
  freetype,
  harfbuzz,
  icu,
  dbus,
  libdrm,
  zlib,
  minizip,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  libopus,
  jsoncpp,
  protobuf,
  libvpx,
  srtp,
  snappy,
  nss,
  libevent,
  openssl,
  alsa-lib,
  pulseaudio,
  libcap,
  pciutils,
  systemd,
  pipewire,
  gn,
  ffmpeg,
  lib,
  stdenv,
  glib,
  libxml2,
  libxslt,
  lcms2,
  libkrb5,
  libgbm,
  enableProprietaryCodecs ? true,
  # darwin
  bootstrap_cmds,
  cctools,
  xcbuild,

  fetchpatch,
}:

qtModule {
  pname = "qtwebengine";
  nativeBuildInputs = [
    bison
    coreutils
    flex
    gperf
    ninja
    pkg-config
    (python3.withPackages (ps: with ps; [ html5lib ]))
    which
    gn
    nodejs
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    bootstrap_cmds
    cctools
    xcbuild
  ];
  doCheck = true;
  outputs = [
    "out"
    "dev"
  ];

  dontUseGnConfigure = true;

  # ninja builds some components with -Wno-format,
  # which cannot be set at the same time as -Wformat-security
  hardeningDisable = [ "format" ];

  patches = [
    # Don't assume /usr/share/X11, and also respect the XKB_CONFIG_ROOT
    # environment variable, since NixOS relies on it working.
    # See https://github.com/NixOS/nixpkgs/issues/226484 for more context.
    ./xkb-includes.patch

    ./link-pulseaudio.patch

    # Override locales install path so they go to QtWebEngine's $out
    ./locales-path.patch

    # Reproducibility QTBUG-136068
    ./gn-object-sorted.patch

    # Revert "Create EGLImage with eglCreateDRMImageMESA() for exporting dma_buf"
    # Mesa 25.2 dropped eglCreateDRMImageMESA, so this no longer works.
    # There are better ways to do this, but this is the easy fix for now.
    (fetchpatch {
      url = "https://invent.kde.org/qt/qt/qtwebengine/-/commit/ddcd30454aa6338d898c9d20c8feb48f36632e16.diff";
      revert = true;
      hash = "sha256-ht7C3GIEaPtmMGLzQKOtMqE9sLKdqqYCgi/W6b430YU=";
    })
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

    substituteInPlace configure.cmake src/gn/CMakeLists.txt \
      --replace "AppleClang" "Clang"

    # Disable metal shader compilation, Xcode only
    substituteInPlace src/3rdparty/chromium/third_party/angle/src/libANGLE/renderer/metal/metal_backend.gni \
      --replace-fail 'angle_has_build && !is_ios && target_os == host_os' "false"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${lib.getLib systemd}/lib/\1!' \
      src/3rdparty/chromium/device/udev_linux/udev?_loader.cc

    sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
      src/3rdparty/chromium/gpu/config/gpu_info_collector_linux.cc
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cmake/QtToolchainHelpers.cmake \
      --replace-fail "/usr/bin/xcrun" "${xcbuild}/bin/xcrun"
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
    "-DQT_FEATURE_webengine_system_libevent=ON"
    "-DQT_FEATURE_webengine_system_ffmpeg=ON"
    # android only. https://bugreports.qt.io/browse/QTBUG-100293
    # "-DQT_FEATURE_webengine_native_spellchecker=ON"
    "-DQT_FEATURE_webengine_sanitizer=ON"
    "-DQT_FEATURE_webengine_kerberos=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DQT_FEATURE_webengine_system_libxml=ON"
    "-DQT_FEATURE_webengine_webrtc_pipewire=ON"

    # Appears not to work on some platforms
    # https://github.com/Homebrew/homebrew-core/issues/104008
    "-DQT_FEATURE_webengine_system_icu=ON"
  ]
  ++ lib.optionals enableProprietaryCodecs [
    "-DQT_FEATURE_webengine_proprietary_codecs=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=11.0" # Per Qt 6’s deployment target (why doesn’t the hook work?)
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

    openssl
    glib
    libxslt
    lcms2

    libevent
    ffmpeg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    zlib
    minizip
    snappy
    nss
    protobuf
    jsoncpp

    icu
    libxml2

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
    libgbm
  ];

  buildInputs = [
    cups
  ];

  requiredSystemFeatures = [ "big-parallel" ];

  preConfigure = ''
    export NINJAFLAGS="-j$NIX_BUILD_CORES"
  '';

  # Debug info is too big to link with LTO.
  separateDebugInfo = false;

  meta = with lib; {
    description = "Web engine based on the Chromium web browser";
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
      "armv7a-linux"
      "armv7l-linux"
      "x86_64-linux"
    ];
    # This build takes a long time; particularly on slow architectures
    # 1 hour on 32x3.6GHz -> maybe 12 hours on 4x2.4GHz
    timeout = 24 * 3600;
  };
}
