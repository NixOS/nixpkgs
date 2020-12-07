{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, gettext
, config
, pkgconfig
, python3
, gst-plugins-base
, orc
, gobject-introspection
, enableZbar ? false
, faacSupport ? false
, faac ? null
, faad2
, libass
, libkate
, libmms
, lrdf
, ladspaH
, libnice
, webrtc-audio-processing
, lilv
, lv2
, serd
, sord
, sratom
, libbs2b
, libmodplug
, mpeg2dec
, libmicrodns
, openjpeg
, libopus
, librsvg
, bluez
, chromaprint
, curl
, darwin
, directfb
, fdk_aac
, flite
, gsm
, libaom
, libdc1394
, libde265
, libdrm
, libdvdnav
, libdvdread
, libgudev
, libofa
, libsndfile
, libusb1
, neon
, openal
, opencv4
, openexr
, openh264
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
}:

assert faacSupport -> faac != null;

let
  inherit (stdenv.lib) optional optionals;
in stdenv.mkDerivation rec {
  pname = "gst-plugins-bad";
  version = "1.18.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "06ildd4rl6cynirv3p00d2ddf5is9svj4i7mkahldzhq24pq5mca";
  };

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    orc # for orcc
    python3
    gettext
    gobject-introspection
  ] ++ optionals stdenv.isLinux [
    wayland # for wayland-scanner
  ];

  buildInputs = [
    gst-plugins-base
    orc
    gobject-introspection
    faad2
    libass
    libkate
    libmms
    webrtc-audio-processing # webrtc
    libbs2b
    libmodplug
    mpeg2dec
    libmicrodns
    openjpeg
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
    libsndfile
    libusb1
    mjpegtools
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
    x265
    libxml2
    libintl
    srt
  ] ++ optionals enableZbar [
    zbar
  ] ++ optionals faacSupport [
    faac
  ] ++ optionals stdenv.isLinux [
    bluez
    libva # vaapi requires libva -> libdrm -> libpciaccess, which is Linux-only in nixpkgs
    wayland
    wayland-protocols
  ] ++ optionals (!stdenv.isDarwin) [
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
    libofa
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
  ] ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
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
  ]);

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing

    "-Davtp=disabled"
    "-Ddts=disabled" # required `libdca` library not packaged in nixpkgs as of writing, and marked as "BIG FAT WARNING: libdca is still in early development"
    "-Dzbar=${if enableZbar then "enabled" else "disabled"}"
    "-Dfaac=${if faacSupport then "enabled" else "disabled"}"
    "-Diqa=disabled" # required `dssim` library not packaging in nixpkgs as of writing
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
    "-Dopenmpt=disabled" # `libopenmpt` not packaged in nixpkgs as of writing
    "-Dopenni2=disabled" # not packaged in nixpkgs as of writing
    "-Dopensles=disabled" # not packaged in nixpkgs as of writing
    "-Dsctp=disabled" # required `usrsctp` library not packaged in nixpkgs as of writing
    "-Dsvthevcenc=disabled" # required `SvtHevcEnc` library not packaged in nixpkgs as of writing
    "-Dteletext=disabled" # required `zvbi` library not packaged in nixpkgs as of writing
    "-Dtinyalsa=disabled" # not packaged in nixpkgs as of writing
    "-Dvoaacenc=disabled" # required `vo-aacenc` library not packaged in nixpkgs as of writing
    "-Dvoamrwbenc=disabled" # required `vo-amrwbenc` library not packaged in nixpkgs as of writing
    "-Dvulkan=disabled" # Linux-only, and we haven't figured out yet which of the vulkan nixpkgs it needs
    "-Dwasapi=disabled" # not packaged in nixpkgs as of writing / no Windows support
    "-Dwasapi2=disabled" # not packaged in nixpkgs as of writing / no Windows support
    "-Dwpe=disabled" # required `wpe-webkit` library not packaged in nixpkgs as of writing
    "-Dzxing=disabled" # required `zxing-cpp` library not packaged in nixpkgs as of writing
  ]
  ++ optionals (!stdenv.isLinux) [
    "-Dva=disabled" # see comment on `libva` in `buildInputs`
  ]
  ++ optionals stdenv.isDarwin [
    "-Dbluez=disabled"
    "-Dchromaprint=disabled"
    "-Ddirectfb=disabled"
    "-Dflite=disabled"
    "-Dkms=disabled" # renders to libdrm output
    "-Dofa=disabled"
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
  ] ++ optionals (!gst-plugins-base.glEnabled) [
    "-Dgl=disabled"]
  ++ optionals (!gst-plugins-base.waylandEnabled) [
    "-Dwayland=disabled"
  ] ++ optionals (!gst-plugins-base.glEnabled) [
    # `applemedia/videotexturecache.h` requires `gst/gl/gl.h`,
    # but its meson build system does not declare the dependency.
    "-Dapplemedia=disabled"
  ];

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

  meta = with stdenv.lib; {
    description = "GStreamer Bad Plugins";
    homepage = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that aren't up to par compared to the
      rest.  They might be close to being good quality, but they're missing
      something - be it a good code review, some documentation, a set of tests,
      a real live maintainer, or some actual wide use.
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
