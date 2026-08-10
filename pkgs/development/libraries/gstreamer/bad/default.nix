{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  replaceVars,
  meson,
  ninja,
  gettext,
  pkg-config,
  python3,
  gst-plugins-base,
  orc,
  gstreamer,
  gobject-introspection,
  wayland-scanner,
  enableZbar ? false,
  faacSupport ? false,
  faac,
  opencvSupport ? false,
  opencv4,
  faad2,
  # Enabling lcevcdecoder currently causes issues when attempting to decode regular h264 data
  # warning: No decoder available for type 'video/x-h264, stream-format=(string)avc, [...], lcevc=(boolean)false, [...]
  lcevcdecSupport ? false,
  lcevcdec,
  ldacbtSupport ? lib.meta.availableOn stdenv.hostPlatform ldacbt,
  ldacbt,
  liblc3,
  libass,
  lrdf,
  ladspa-header,
  lcms2,
  libnice,
  webrtcAudioProcessingSupport ? lib.meta.availableOn stdenv.hostPlatform webrtc-audio-processing_1,
  webrtc-audio-processing_1,
  lilv,
  lv2,
  serd,
  sord,
  sratom,
  libbs2b,
  libmodplug,
  libmpeg2,
  libmicrodns,
  openjpeg,
  libopus,
  librsvg,
  bluez,
  chromaprint,
  curl,
  fdk_aac,
  flite,
  gsm,
  json-glib,
  ajaSupport ? lib.meta.availableOn stdenv.hostPlatform libajantv2,
  libajantv2,
  libaom,
  libdc1394,
  libde265,
  libdrm,
  libdvdnav,
  libdvdread,
  libgudev,
  qrencode,
  libsndfile,
  libusb1,
  neon,
  openal,
  openexr,
  openh264Support ? lib.meta.availableOn stdenv.hostPlatform openh264,
  openh264,
  libopenmpt,
  pango,
  rtmpdump,
  sbc,
  soundtouch,
  spandsp,
  srtp,
  zbar,
  wayland-protocols,
  wildmidi,
  svt-av1,
  fluidsynth,
  libva,
  wayland,
  libwebp,
  gnutls,
  mjpegtools,
  libGL,
  addDriverRunpath,
  gtk3,
  libintl,
  game-music-emu,
  openssl,
  x265,
  libxml2,
  srt,
  vo-aacenc,
  libfreeaptx,
  zxing-cpp,
  usrsctp,
  directoryListingUpdater,
  enableGplPlugins ? true,
  bluezSupport ? stdenv.hostPlatform.isLinux,
  # Causes every application using GstDeviceMonitor to send mDNS queries every 2 seconds
  microdnsSupport ? false,
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  hotdoc,
  # causes gtk4 to depend on gtk3 and makes little sense
  guiSupport ? false,
  gst-plugins-bad,
  apple-sdk_gstreamer,
  libexif,
  # disabled by default for now to reduce closure size
  vulkanSupport ? false && stdenv.hostPlatform.isLinux,
  vulkan-headers,
  vulkan-loader,
  shaderc,
  libxkbcommon,
}:

let
  vaSupport = gst-plugins-base.waylandEnabled && lib.meta.availableOn stdenv.hostPlatform libva;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gst-plugins-bad";
  version = "1.28.6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${finalAttrs.version}.tar.xz";
    hash = "sha256-Zjbywiic7aUsSrqXEzjIHitXgNM4G9NnPBwRbsh1h8M=";
  };

  patches = [
    # Add fallback paths for nvidia userspace libraries
    (replaceVars ./fix-paths.patch {
      inherit (addDriverRunpath) driverLink;
    })
  ];

  separateDebugInfo = true;

  __structuredAttrs = true;
  # Argument list too long
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    orc # for orcc
    python3
    gettext
    gstreamer # for gst-tester-1.0
    gobject-introspection
  ]
  ++ lib.optionals vulkanSupport [
    # alternative: glslang
    shaderc
  ]
  ++ lib.optionals enableDocumentation [
    hotdoc
  ]
  ++ lib.optionals (gst-plugins-base.waylandEnabled && stdenv.hostPlatform.isLinux) [
    wayland-scanner
  ];

  buildInputs = [
    gst-plugins-base
    orc
    json-glib
    lcms2
    liblc3
    libass
    libbs2b
    libmodplug
    openjpeg
    libopenmpt
    libopus
    librsvg
    curl.dev
    fdk_aac
    gsm
    libaom
    libdc1394
    libde265
    libdvdnav
    libdvdread
    libnice
    qrencode
    libsndfile
    libusb1
    neon
    openal
    openexr
    rtmpdump
    pango
    soundtouch
    srtp
    fluidsynth
    libwebp
    gnutls
    game-music-emu
    openssl
    libxml2
    libintl
    srt
    vo-aacenc
    libfreeaptx
    zxing-cpp
    usrsctp
    wildmidi
    svt-av1
  ]
  ++ lib.optionals vulkanSupport [
    vulkan-headers
    vulkan-loader
    libxkbcommon
  ]
  ++ lib.optionals opencvSupport [
    opencv4
  ]
  ++ lib.optionals enableZbar [
    zbar
  ]
  ++ lib.optionals faacSupport [
    faac
  ]
  ++ lib.optionals enableGplPlugins [
    libmpeg2
    mjpegtools
    faad2
    x265
  ]
  ++ lib.optionals bluezSupport [
    bluez
  ]
  ++ lib.optionals microdnsSupport [
    libmicrodns
  ]
  ++ lib.optionals openh264Support [
    openh264
  ]
  ++ lib.optionals ajaSupport [
    libajantv2
  ]
  ++ lib.optionals gst-plugins-base.waylandEnabled [
    wayland
    wayland-protocols
  ]
  ++ lib.optionals vaSupport [
    libva
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # TODO: mjpegtools uint64_t is not compatible with guint64 on Darwin
    mjpegtools

    chromaprint
    flite
    libdrm
    libgudev
    sbc
    spandsp

    # ladspa plug-in
    ladspa-header
    lrdf # TODO: make build on Darwin

    # lv2 plug-in
    lilv
    lv2
    serd
    sord
    sratom

    libGL
  ]
  ++ lib.optionals guiSupport [
    gtk3
  ]
  ++ lib.optionals lcevcdecSupport [
    lcevcdec
  ]
  ++ lib.optionals ldacbtSupport [
    ldacbt
  ]
  ++ lib.optionals webrtcAudioProcessingSupport [
    webrtc-audio-processing_1
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
  ];

  checkInputs = [
    # for jifmux test, optional
    libexif
  ];

  mesonFlags = [
    (lib.mesonBool "gst_play_tests" false)
  ]
  ++ lib.mapAttrsToList lib.mesonEnable {
    tests = finalAttrs.finalPackage.doCheck;
    tools = true;
    examples = false; # requires many dependencies and probably not useful for our users
    glib_debug = false; # cast checks should be disabled on stable releases

    # needs gstcuda to be enabled which is Linux-only
    doc = enableDocumentation && stdenv.hostPlatform.isLinux;

    # Windows-only
    amfcodec = false;
    directshow = false;
    qt6d3d11 = false;

    # Android-only
    androidmedia = false;
    avtp = false;

    cuda-nvmm = false;
    zbar = enableZbar;
    faac = faacSupport;
    magicleap = false; # required `ml_audio` library not packaged in nixpkgs as of writing
    msdk = false; # not packaged in nixpkgs as of writing / no Windows support
    nvcomp = false;
    nvdswrapper = false;
    openni2 = false; # not packaged in nixpkgs as of writing
    opensles = false; # not packaged in nixpkgs as of writing
    svthevcenc = false; # required `SvtHevcEnc` library not packaged in nixpkgs as of writing
    svtjpegxs = false; # not packaged in nixpkgs as of writing
    teletext = false;
    tinyalsa = false;
    voamrwbenc = false;
    vulkan = vulkanSupport;
    wasapi = false; # not packaged in nixpkgs as of writing / no Windows support
    wasapi2 = false; # not packaged in nixpkgs as of writing / no Windows support
    wpe = false; # required `wpe-webkit` library not packaged in nixpkgs as of writing
    wpe2 = false;
    gs = false; # depends on `google-cloud-cpp`
    onnx = false;
    openaptx = true; # since gstreamer-1.20.1 `libfreeaptx` is supported for circumventing the dubious license conflict with `libopenaptx`
    opencv = opencvSupport; # Reduces rebuild size when `config.cudaSupport = true`
    aja = ajaSupport;
    microdns = microdnsSupport;
    bluez = bluezSupport;
    openh264 = openh264Support;
    lcevcencoder = false; # not packaged in nixpkgs as of writing
    lcevcdecoder = lcevcdecSupport;
    ldac = ldacbtSupport;
    webrtc = true;
    webrtcdsp = webrtcAudioProcessingSupport;
    isac = webrtcAudioProcessingSupport;

    # As of writing, with `libmpcdec` in `buildInputs` we get
    #   "Could not find libmpcdec header files, but Musepack was enabled via options"
    # This is likely because nixpkgs has the header in libmpc/mpcdec.h
    # instead of mpc/mpcdec.h, like Arch does. The situation is not trivial.
    # There are apparently 2 things called `libmpcdec` from the same author:
    #   * http://svn.musepack.net/libmpcdec/trunk/src/
    #   * http://svn.musepack.net/libmpc/trunk/include/mpc/
    # Fixing it likely requires to first figure out with upstream which one
    # is needed, and then patching upstream to find it (though it probably
    # already works on Arch?).
    musepack = false;

    # directfb can't be added to buildInputs due to dependency cycle
    # gst-plugins-bad -> directfb -> sdl12-compat -> sdl2-compat -> sdl3 -> zenity -> gtk4 -> gst-plugins-bad
    directfb = false;

    mpeghdec = false; # mpeghdec not packaged
    tflite = false;

    # Linux (and Windows) x86 only, makes va required
    qsv =
      stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 && gst-plugins-base.waylandEnabled;

    gl = gst-plugins-base.glEnabled;
    # `applemedia/videotexturecache.h` requires `gst/gl/gl.h`,
    # but its meson build system does not declare the dependency.
    applemedia = gst-plugins-base.glEnabled;

    gtk3 = guiSupport;
    wayland = gst-plugins-base.waylandEnabled;

    # Linux-only, broken on non-x86
    nvcodec = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86;

    va = gst-plugins-base.waylandEnabled && lib.meta.availableOn stdenv.hostPlatform libva;

    gpl = enableGplPlugins;

    faad = enableGplPlugins;
    mpeg2enc = enableGplPlugins;
    mplex = enableGplPlugins;
    resindvd = enableGplPlugins;
    x265 = enableGplPlugins;

    # NOTE:
    # The following plugins are explicitly mentioned here for reference even though they are always disabled
    # because they would make the package (A)GPL if they ever get included in the future

    # required `libdca` library not packaged in nixpkgs as of writing
    dts = false;

    # required `dssim` library not packaging in nixpkgs as of writing,
    # also this is AGPL so update license when adding support
    iqa = false;
  }
  ++ lib.map (f: lib.mesonEnable f (!stdenv.hostPlatform.isDarwin)) [
    "chromaprint"
    "flite"
    "kms" # renders to libdrm output
    "lv2"
    "sbc"
    "spandsp"
    "dvb"
    "fbdev"
    "uvcgadget" # requires gudev
    "uvch264" # requires gudev
    "v4l2codecs" # requires gudev
    "ladspa" # requires lrdf
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py \
      ext/vulkan/shaders/bin2array.py
  '';

  # This package has some `_("string literal")` string formats
  # that trip up clang with format security enabled.
  hardeningDisable = [ "format" ];

  doCheck = false; # fails 20 out of 58 tests, expensive

  preFixup = ''
    moveToOutput "lib/gstreamer-1.0/pkgconfig" "$dev"
  '';

  passthru = {
    tests = {
      full = gst-plugins-bad.override {
        enableZbar = true;
        faacSupport = true;
        opencvSupport = true;
      };

      lgplOnly = gst-plugins-bad.override {
        enableGplPlugins = false;
      };
    };

    updateScript = directoryListingUpdater { odd-unstable = true; };
  };

  meta = {
    description = "GStreamer Bad Plugins";
    homepage = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that aren't up to par compared to the
      rest.  They might be close to being good quality, but they're missing
      something - be it a good code review, some documentation, a set of tests,
      a real live maintainer, or some actual wide use.
    '';
    license = if enableGplPlugins then lib.licenses.gpl2Plus else lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
