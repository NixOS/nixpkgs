{ lib
, stdenv
, fetchurl
, meson
, ninja
, gettext
, pkg-config
, python3
, gst-plugins-base
, orc
, gstreamer
, gobject-introspection
, enableZbar ? false
, faacSupport ? false
, faac
, faad2
, ldacbt
, libass
, libkate
, lrdf
, ladspaH
, libnice
, webrtc-audio-processing
, webrtc-audio-processing_1
, lilv
, lv2
, serd
, sord
, sratom
, libbs2b
, libmodplug
, libmpeg2
, libmicrodns
, openjpeg
, libopus
, librsvg
, bluez
, chromaprint
, curl
, directfb
, fdk_aac
, flite
, gsm
, json-glib
, libaom
, libdc1394
, libde265
, libdrm
, libdvdnav
, libdvdread
, libgudev
, qrencode
, libsndfile
, libusb1
, neon
, openal
, opencv4
, openexr
, openh264
, libopenmpt
, pango
, rtmpdump
, sbc
, soundtouch
, spandsp
, srtp
, zbar
, wayland-protocols
, wildmidi
, fluidsynth
, libva
, libvdpau
, wayland
, libwebp
, xvidcore
, gnutls
, mjpegtools
, libGLU
, libGL
, libintl
, libgme
, openssl
, x265
, libxml2
, srt
, vo-aacenc
, VideoToolbox
, AudioToolbox
, AVFoundation
, CoreMedia
, CoreVideo
, Foundation
, MediaToolbox
, enableGplPlugins ? true
}:

stdenv.mkDerivation rec {
  pname = "gst-plugins-bad";
  version = "1.20.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-AVuNTZo5Xr9ETUCHaGeiA03TMEs61IvDoN0MHucdwR0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    orc # for orcc
    python3
    gettext
    gstreamer # for gst-tester-1.0
    gobject-introspection
  ] ++ lib.optionals stdenv.isLinux [
    wayland # for wayland-scanner
  ];

  buildInputs = [
    gst-plugins-base
    orc
    # gobject-introspection has to be in both nativeBuildInputs and
    # buildInputs. The build tries to link against libgirepository-1.0.so
    gobject-introspection
    json-glib
    ldacbt
    libass
    libkate
    webrtc-audio-processing # required by webrtcdsp
    #webrtc-audio-processing_1 # required by isac
    libbs2b
    libmodplug
    libmicrodns
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
    qrencode
    libsndfile
    libusb1
    neon
    openal
    opencv4
    openexr
    openh264
    rtmpdump
    pango
    soundtouch
    srtp
    fluidsynth
    libvdpau
    libwebp
    xvidcore
    gnutls
    libGL
    libGLU
    libgme
    openssl
    libxml2
    libintl
    srt
    vo-aacenc
  ] ++ lib.optionals enableZbar [
    zbar
  ] ++ lib.optionals faacSupport [
    faac
  ] ++ lib.optionals enableGplPlugins [
    libmpeg2
    mjpegtools
    faad2
    x265
  ] ++ lib.optionals stdenv.isLinux [
    bluez
    libva # vaapi requires libva -> libdrm -> libpciaccess, which is Linux-only in nixpkgs
    wayland
    wayland-protocols
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # wildmidi requires apple's OpenAL
    # TODO: package apple's OpenAL, fix wildmidi, include on Darwin
    wildmidi
    # TODO: mjpegtools uint64_t is not compatible with guint64 on Darwin
    mjpegtools

    chromaprint
    directfb
    flite
    libdrm
    libgudev
    libnice
    sbc
    spandsp

    # ladspa plug-in
    ladspaH
    lrdf # TODO: make build on Darwin

    # lv2 plug-in
    lilv
    lv2
    serd
    sord
    sratom
  ] ++ lib.optionals stdenv.isDarwin [
    # For unknown reasons the order is important, e.g. if
    # VideoToolbox is last, we get:
    #     fatal error: 'VideoToolbox/VideoToolbox.h' file not found
    VideoToolbox
    AudioToolbox
    AVFoundation
    CoreMedia
    CoreVideo
    Foundation
    MediaToolbox
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
    "-Dglib-asserts=disabled" # asserts should be disabled on stable releases

    "-Davtp=disabled"
    "-Ddts=disabled" # required `libdca` library not packaged in nixpkgs as of writing, and marked as "BIG FAT WARNING: libdca is still in early development"
    "-Dzbar=${if enableZbar then "enabled" else "disabled"}"
    "-Dfaac=${if faacSupport then "enabled" else "disabled"}"
    "-Diqa=disabled" # required `dssim` library not packaging in nixpkgs as of writing, also this is AGPL so update license when adding support
    "-Dmagicleap=disabled" # required `ml_audio` library not packaged in nixpkgs as of writing
    "-Dmsdk=disabled" # not packaged in nixpkgs as of writing / no Windows support
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
    "-Dmusepack=disabled"
    "-Dopenni2=disabled" # not packaged in nixpkgs as of writing
    "-Dopensles=disabled" # not packaged in nixpkgs as of writing
    "-Dsctp=disabled" # required `usrsctp` library not packaged in nixpkgs as of writing
    "-Dsvthevcenc=disabled" # required `SvtHevcEnc` library not packaged in nixpkgs as of writing
    "-Dteletext=disabled" # required `zvbi` library not packaged in nixpkgs as of writing
    "-Dtinyalsa=disabled" # not packaged in nixpkgs as of writing
    "-Dvoamrwbenc=disabled" # required `vo-amrwbenc` library not packaged in nixpkgs as of writing
    "-Dvulkan=disabled" # Linux-only, and we haven't figured out yet which of the vulkan nixpkgs it needs
    "-Dwasapi=disabled" # not packaged in nixpkgs as of writing / no Windows support
    "-Dwasapi2=disabled" # not packaged in nixpkgs as of writing / no Windows support
    "-Dwpe=disabled" # required `wpe-webkit` library not packaged in nixpkgs as of writing
    "-Dzxing=disabled" # required `zxing-cpp` library not packaged in nixpkgs as of writing
    "-Disac=disabled" # depends on `webrtc-audio-coding-1` not compatible with 0.3
    "-Dgs=disabled" # depends on `google-cloud-cpp`
    "-Donnx=disabled" # depends on `libonnxruntime` not packaged in nixpkgs as of writing
    "-Dopenaptx=disabled" # depends on older version of `libopenaptx` due to licensing conflict https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/-/merge_requests/2235
  ]
  ++ lib.optionals (!stdenv.isLinux) [
    "-Dva=disabled" # see comment on `libva` in `buildInputs`
  ]
  ++ lib.optionals stdenv.isDarwin [
    "-Dbluez=disabled"
    "-Dchromaprint=disabled"
    "-Ddirectfb=disabled"
    "-Dflite=disabled"
    "-Dkms=disabled" # renders to libdrm output
    "-Dlv2=disabled"
    "-Dsbc=disabled"
    "-Dspandsp=disabled"
    "-Ddvb=disabled"
    "-Dfbdev=disabled"
    "-Duvch264=disabled" # requires gudev
    "-Dv4l2codecs=disabled" # requires gudev
    "-Dladspa=disabled" # requires lrdf
    "-Dwebrtc=disabled" # requires libnice, which as of writing doesn't work on Darwin in nixpkgs
    "-Dwildmidi=disabled" # see dependencies above
  ] ++ lib.optionals (!gst-plugins-base.glEnabled) [
    "-Dgl=disabled"
  ] ++ lib.optionals (!gst-plugins-base.waylandEnabled) [
    "-Dwayland=disabled"
  ] ++ lib.optionals (!gst-plugins-base.glEnabled) [
    # `applemedia/videotexturecache.h` requires `gst/gl/gl.h`,
    # but its meson build system does not declare the dependency.
    "-Dapplemedia=disabled"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dintrospection=disabled"
  ] ++ (if enableGplPlugins then [
    "-Dgpl=enabled"
  ] else [
    "-Ddts=disabled"
    "-Dfaad=disabled"
    "-Diqa=disabled"
    "-Dmpeg2enc=disabled"
    "-Dmplex=disabled"
    "-Dresindvd=disabled"
    "-Dx265=disabled"
  ]);

  # Argument list too long
  strictDeps = true;

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  # This package has some `_("string literal")` string formats
  # that trip up clang with format security enabled.
  hardeningDisable = [ "format" ];

  doCheck = false; # fails 20 out of 58 tests, expensive

  meta = with lib; {
    description = "GStreamer Bad Plugins";
    homepage = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that aren't up to par compared to the
      rest.  They might be close to being good quality, but they're missing
      something - be it a good code review, some documentation, a set of tests,
      a real live maintainer, or some actual wide use.
    '';
    license = if enableGplPlugins then licenses.gpl2Plus else licenses.lgpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
