{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  meson,
  nasm,
  ninja,
  pkg-config,
  python3,
  gst-plugins-base,
  orc,
  bzip2,
  gettext,
  libGL,
  libv4l,
  libdv,
  libvpx,
  libdrm,
  speex,
  opencore-amr,
  flac,
  taglib,
  libshout,
  cairo,
  gdk-pixbuf,
  aalib,
  libcaca,
  libsoup_3,
  libpulseaudio,
  libintl,
  libxml2,
  lame,
  mpg123,
  twolame,
  gtkSupport ? false,
  gtk3,
  qt5Support ? false,
  qt5,
  qt6Support ? false,
  qt6,
  raspiCameraSupport ? false,
  libraspberrypi,
  enableJack ? true,
  libjack2,
  enableX11 ? stdenv.hostPlatform.isLinux,
  libxtst,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  ncurses,
  enableFireWire ? stdenv.hostPlatform.isLinux,
  libavc1394,
  libiec61883,
  enableOSS ? stdenv.hostPlatform.isLinux,
  enableWayland ? stdenv.hostPlatform.isLinux,
  wayland,
  wayland-protocols,
  libgudev,
  wavpack,
  glib,
  openssl,
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  hotdoc,
  gst-plugins-good,
  directoryListingUpdater,
  apple-sdk_gstreamer,
}:

let
  # MMAL is not supported on aarch64, see:
  # https://github.com/raspberrypi/userland/issues/688
  hostSupportsRaspiCamera = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch32;
in

assert raspiCameraSupport -> hostSupportsRaspiCamera;

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-plugins-good";
  version = "1.28.6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${finalAttrs.version}.tar.xz";
    hash = "sha256-sMYgpLGLbukxtMQ7vxdg0whmbcN/cwp+fxrTJ+Wc4t8=";
  };

  patches = [
    # dlopen libsoup_3 with an absolute path
    (replaceVars ./souploader.diff {
      nixLibSoup3Path = "${lib.getLib libsoup_3}/lib";
    })
  ];

  separateDebugInfo = true;

  __structuredAttrs = true;
  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    pkg-config
    python3
    meson
    ninja
    gettext
    orc
    libshout
    glib
  ]
  # https://gitlab.freedesktop.org/gstreamer/gstreamer/-/blob/bb7069bd6fff80e8599d6e79f3f000b83dbce4d6/subprojects/gst-plugins-good/meson.build#L435-443
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    nasm
  ]
  ++ lib.optionals enableDocumentation [
    hotdoc
  ]
  ++ lib.optionals qt5Support (
    with qt5;
    [
      qtbase
      qttools
    ]
  )
  ++ lib.optionals qt6Support (
    with qt6;
    [
      qtbase
      qttools
    ]
  )
  ++ lib.optionals enableWayland [
    wayland-protocols
  ];

  buildInputs = [
    gst-plugins-base
    orc
    bzip2
    libdv
    libvpx
    speex
    opencore-amr
    flac
    taglib
    cairo
    gdk-pixbuf
    aalib
    libcaca
    libsoup_3
    libshout
    libxml2
    lame
    mpg123
    twolame
    libintl
    ncurses
    wavpack
    openssl
  ]
  ++ lib.optionals raspiCameraSupport [
    libraspberrypi
  ]
  ++ lib.optionals enableX11 [
    libxext
    libxfixes
    libxdamage
    libxtst
    libxi
  ]
  ++ lib.optionals gtkSupport [
    # for gtksink
    gtk3
  ]
  ++ lib.optionals qt5Support (
    with qt5;
    [
      qtbase
      qtdeclarative
      qtwayland
      qtx11extras
    ]
  )
  ++ lib.optionals qt6Support (
    with qt6;
    [
      qtbase
      qtdeclarative
      qtwayland
    ]
  )
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libdrm
    libGL
    libv4l
    libpulseaudio
    libgudev
  ]
  ++ lib.optionals enableFireWire [
    libavc1394
    libiec61883
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
  ]
  ++ lib.optionals enableWayland [
    wayland
  ]
  ++ lib.optionals enableJack [
    libjack2
  ];

  mesonFlags =
    lib.mapAttrsToList lib.mesonEnable {
      orc = true;
      orc-compiler = true;
      nls = true;

      tests = finalAttrs.finalPackage.doCheck;

      examples = false; # requires many dependencies and probably not useful for our users
      glib_debug = false; # cast checks should be disabled on stable releases
      doc = enableDocumentation;
      asm = true;
      qt5 = qt5Support;
      qt6 = qt6Support;
      gtk3 = gtkSupport;
      ximagesrc = enableX11; # Linux-only
      jack = enableJack;

      # Linux only
      dv1394 = enableFireWire;
      oss = enableOSS;
      oss4 = enableOSS;
      pulse = stdenv.hostPlatform.isLinux; # TODO check if we can keep this enabled
      v4l2 = stdenv.hostPlatform.isLinux;
      v4l2-gudev = stdenv.hostPlatform.isLinux;

      rpicamsrc = raspiCameraSupport;
    }
    ++ lib.optionals raspiCameraSupport [
      (lib.mesonOption "rpi-header-dir" "${lib.getDev libraspberrypi}/include")
      (lib.mesonOption "rpi-lib-dir" "${lib.getLib libraspberrypi}/lib")
    ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py \
      ext/qt6/qsb-wrapper.py
  '';

  env = {
    NIX_LDFLAGS =
      # linking error on Darwin
      # https://github.com/NixOS/nixpkgs/pull/70690#issuecomment-553694896
      lib.optionalString stdenv.hostPlatform.isDarwin "-lncurses";
  };

  # fails 1 tests with "Unexpected critical/warning: g_object_set_is_valid_property: object class 'GstRtpStorage' has no property named ''"
  doCheck = false;

  # must be explicitly set since 5590e365
  dontWrapQtApps = true;

  # Note: gst-plugins-good produces no pkg-config files unless building static libraries
  preFixup = ''
    moveToOutput "lib/gstreamer-1.0/pkgconfig" "$dev"
  '';

  passthru = {
    tests = {
      gtk = gst-plugins-good.override {
        gtkSupport = true;
      };
      qt5 = gst-plugins-good.override {
        qt5Support = true;
      };
      qt6 = gst-plugins-good.override {
        qt6Support = true;
      };
    }
    // lib.optionalAttrs hostSupportsRaspiCamera {
      raspiCamera = gst-plugins-good.override {
        raspiCameraSupport = true;
      };
    };

    updateScript = directoryListingUpdater { odd-unstable = true; };
  };

  meta = {
    description = "GStreamer Good Plugins";
    homepage = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that we consider to have good quality code,
      correct functionality, our preferred license (LGPL for the plug-in
      code, LGPL or LGPL-compatible for the supporting library).
    '';
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
