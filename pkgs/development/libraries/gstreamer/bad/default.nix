{ stdenv, fetchurl, fetchpatch, meson, ninja, gettext
, config
, pkgconfig, python3, gst-plugins-base, orc
, gobject-introspection
, enableZbar ? true
, faacSupport ? false, faac ? null
, faad2, libass, libkate, libmms, librdf, ladspaH
, libnice, webrtc-audio-processing, lilv, lv2, serd, sord, sratom
, libbs2b, libmodplug, mpeg2dec
, openjpeg, libopus, librsvg
, bluez
, chromaprint
, curl
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
, opencv3
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
, wildmidi, fluidsynth, libvdpau, wayland
, libwebp, xvidcore, gnutls, mjpegtools
, libGLU_combined, libintl, libgme
, openssl, x265, libxml2
, srt
}:

assert faacSupport -> faac != null;

let
  inherit (stdenv.lib) optional optionals;
in
stdenv.mkDerivation rec {
  pname = "gst-plugins-bad";
  version = "1.16.0";

  meta = with stdenv.lib; {
    description = "Gstreamer Bad Plugins";
    homepage    = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that aren't up to par compared to the
      rest.  They might be close to being good quality, but they're missing
      something - be it a good code review, some documentation, a set of tests,
      a real live maintainer, or some actual wide use.
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };

  preConfigure = ''
    patchShebangs .
  '';

  patches = [
    ./fix_pkgconfig_includedir.patch
    # Remove when https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/merge_requests/312 is merged and available to us
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/commit/99790eaad9083cce5ab2b1646489e1a1c0faad1e.patch";
      sha256 = "11bqy4sl05qq5mj4bx5s09rq106s3j0vnpjl4np058im32j69lr3";
    })
    # Remove when https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/merge_requests/312 is merged and available to us
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/commit/1872da81c48d3a719bd39955fd97deac7d037d74.patch";
      sha256 = "11zwrr5ggflmvr0qfssj7dmhgd3ybiadmy79b4zh24022zgw3xpz";
    })
  ];

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-bad/${pname}-${version}.tar.xz";
    sha256 = "019b0yqjrcg6jmfd4cc336h1bz5p4wxl58yz1c4sdb96avirs4r2";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson ninja pkgconfig python3 gettext gobject-introspection
  ]
  ++ optionals stdenv.isLinux [
    wayland-protocols
  ];

  buildInputs = [
    gst-plugins-base orc
    faad2 libass libkate libmms
    libnice webrtc-audio-processing # webrtc
    libbs2b
    ladspaH librdf # ladspa plug-in
    lilv lv2 serd sord sratom # lv2 plug-in
    libmodplug mpeg2dec
    openjpeg libopus librsvg
    bluez
    chromaprint
    curl.dev
    directfb
    fdk_aac
    flite
    gsm
    libaom
    libdc1394
    libde265
    libdrm
    libdvdnav
    libdvdread
    libgudev
    libofa
    libsndfile
    libusb1
    neon
    openal
    opencv3
    openexr
    openh264
    rtmpdump
    pango
    sbc
    soundtouch
    spandsp
    srtp
    fluidsynth libvdpau
    libwebp xvidcore gnutls libGLU_combined
    libgme openssl x265 libxml2
    libintl
    srt
  ]
    ++ optional enableZbar zbar
    ++ optional faacSupport faac
    ++ optional stdenv.isLinux wayland
    # wildmidi requires apple's OpenAL
    # TODO: package apple's OpenAL, fix wildmidi, include on Darwin
    ++ optional (!stdenv.isDarwin) wildmidi
    # TODO: mjpegtools uint64_t is not compatible with guint64 on Darwin
    ++ optional (!stdenv.isDarwin) mjpegtools;

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"

    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users

    "-Ddts=disabled" # required `libdca` library not packaged in nixpkgs as of writing, and marked as "BIG FAT WARNING: libdca is still in early development"
    "-Dzbar=${if enableZbar then "enabled" else "disabled"}"
    "-Dfaac=${if faacSupport then "enabled" else "disabled"}"
    "-Diqa=disabled" # required `dssim` library not packaging in nixpkgs as of writing
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
    "-Dteletext=disabled" # required `zvbi` library not packaged in nixpkgs as of writing
    "-Dtinyalsa=disabled" # not packaged in nixpkgs as of writing
    "-Dvoaacenc=disabled" # required `vo-aacenc` library not packaged in nixpkgs as of writing
    "-Dvoamrwbenc=disabled" # required `vo-amrwbenc` library not packaged in nixpkgs as of writing
    "-Dvulkan=disabled" # Linux-only, and we haven't figured out yet which of the vulkan nixpkgs it needs
    "-Dwasapi=disabled" # not packaged in nixpkgs as of writing / no Windows support
    "-Dwpe=disabled" # required `wpe-webkit` library not packaged in nixpkgs as of writing

    # Requires CUDA and we haven't figured out how to make Meson find CUDA yet;
    # it probably searches via pkgconfig, for which we have no .pc files,
    # see https://github.com/NixOS/nixpkgs/issues/54395
    "-Dnvdec=disabled"
    "-Dnvenc=disabled"
  ];

  enableParallelBuilding = true;

  doCheck = false; # fails 20 out of 58 tests, expensive

}
