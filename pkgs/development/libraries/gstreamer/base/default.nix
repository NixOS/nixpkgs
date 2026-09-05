{
  stdenv,
  fetchurl,
  lib,
  pkg-config,
  meson,
  ninja,
  gettext,
  python3,
  gstreamer,
  graphene,
  orc,
  pango,
  libtheora,
  libintl,
  libopus,
  isocodes,
  libjpeg,
  libpng,
  libvorbis,
  libGL,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  enableX11 ? stdenv.hostPlatform.isLinux,
  libxext,
  libxi,
  libxv,
  libdrm,
  enableWayland ? stdenv.hostPlatform.isLinux,
  wayland-scanner,
  wayland,
  wayland-protocols,
  enableAlsa ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  enableCocoa ? stdenv.hostPlatform.isDarwin,
  enableGl ? (enableX11 || enableWayland || enableCocoa),
  enableCdparanoia ? (!stdenv.hostPlatform.isDarwin),
  cdparanoia,
  glib,
  testers,
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  hotdoc,
  directoryListingUpdater,
  apple-sdk_gstreamer,

  # shared GStreamer meta.identifiers.cpeParts
  gstreamerCpeParts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-plugins-base";
  version = "1.28.6";

  outputs = [
    "out"
    "dev"
  ];

  separateDebugInfo = true;

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${finalAttrs.version}.tar.xz";
    hash = "sha256-C6aZx8bGb0umQL54yziiRxWt2Wg/PjoZn1Np3FpPBKw=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    gettext
    orc
    glib
    gstreamer
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ]
  ++ lib.optionals enableDocumentation [
    hotdoc
  ]
  ++ lib.optionals enableWayland [
    wayland-scanner
  ];

  buildInputs = [
    graphene
    orc
    libtheora
    libintl
    libopus
    isocodes
    libpng
    libjpeg
    libvorbis
    pango
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libdrm
    libGL
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
  ]
  ++ lib.optionals enableAlsa [
    alsa-lib
  ]
  ++ lib.optionals enableX11 [
    libxext
    libxi
    libxv
  ]
  ++ lib.optionals enableWayland [
    wayland
    wayland-protocols
  ]
  ++ lib.optional enableCdparanoia cdparanoia;

  propagatedBuildInputs = [
    gstreamer
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libdrm
  ];

  mesonFlags =
    let
      # For a list of choices, see
      # https://gitlab.freedesktop.org/gstreamer/gstreamer/-/blob/d529453528a5dd11c15eab788cce6676141134b7/subprojects/gst-plugins-base/meson.options#L14-1
      # unsupported platforms: win32, winrt, android
      # deprecated/ancient platforms: dispmanx, eagl
      # TODO: should we add egl, surfaceless, viv-fb, gbm?
      # (on Linux, autodiscovery would automatically add egl and surfaceless)
      # 'egl', 'surfaceless', 'viv-fb', 'gbm',
      enabledGlWinSys =
        lib.optional enableX11 "x11"
        ++ lib.optional enableWayland "wayland"
        ++ lib.optional enableCocoa "cocoa";
    in
    lib.mapAttrsToList lib.mesonEnable {
      orc = true;
      orc-compiler = true;
      nls = true;

      glib_debug = false; # cast checks should be disabled on stable releases
      examples = false; # requires many dependencies and probably not useful for our users
      introspection = withIntrospection;
      doc = enableDocumentation;

      tests = finalAttrs.finalPackage.doCheck;

      libvisual = false;
      tremor = false; # unmaintained in nixpkgs, just use regular libvorbis instead
      vorbis = true;

      x11 = enableX11;
      xi = enableX11;
      xshm = enableX11;
      xvideo = enableX11;

      # TODO How to disable Wayland?
      gl = enableGl;
      alsa = enableAlsa;
      cdparanoia = enableCdparanoia;
      drm = !stdenv.hostPlatform.isDarwin;
    }
    ++ [ (lib.mesonOption "gl_winsys" (lib.concatStringsSep "," enabledGlWinSys)) ];

  postPatch = ''
    patchShebangs \
      scripts/meson-pkg-config-file-fixup.py \
      scripts/extract-release-date-from-doap-file.py
  '';

  # This package has some `_("string literal")` string formats
  # that trip up clang with format security enabled.
  hardeningDisable = [ "format" ];

  doCheck = false; # fails, wants DRI access for OpenGL

  preFixup = ''
    moveToOutput "lib/gstreamer-1.0/pkgconfig" "$dev"
  '';

  passthru = {
    # Downstream `gst-*` packages depending on `gst-plugins-base`
    # have meson build options like 'gl' etc. that depend
    # on these features being built in `-base`.
    # If they are not built here, then the downstream builds
    # will fail, as they, too, use `-Dauto_features=enabled`
    # which would enable these options unconditionally.
    # That means we must communicate to these downstream packages
    # if the `-base` enabled these options or not, so that
    # the can enable/disable those features accordingly.
    # The naming `*Enabled` vs `enable*` is intentional to
    # distinguish inputs from outputs (what is to be built
    # vs what was built) and to make them easier to search for.
    glEnabled = enableGl;
    waylandEnabled = enableWayland;

    updateScript = directoryListingUpdater { odd-unstable = true; };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
  };

  meta = {
    description = "Base GStreamer plug-ins and helper libraries";
    homepage = "https://gstreamer.freedesktop.org";
    license = lib.licenses.lgpl2Plus;
    pkgConfigModules = lib.map (m: "gstreamer-${m}-1.0") (
      [
        "allocators"
        "app"
        "audio"
        "fft"
        "pbutils"
        "plugins-base"
        "riff"
        "rtp"
        "rtsp"
        "sdp"
        "tag"
      ]
      ++ lib.optionals enableGl [
        "gl"
        "gl-egl"
        "gl-prototypes"
      ]
      ++ lib.optional (enableGl && enableWayland) "gl-wayland"
      ++ lib.optional (enableGl && enableX11) "gl-x11"
    );
    identifiers.cpeParts = gstreamerCpeParts finalAttrs.version;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
