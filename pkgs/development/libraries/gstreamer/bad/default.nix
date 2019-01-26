{ stdenv, fetchurl, fetchpatch, meson, ninja, gettext
, pkgconfig, python3, gst-plugins-base, orc
, faacSupport ? false, faac ? null
, faad2, libass, libkate, libmms, librdf, ladspaH
, libnice, webrtc-audio-processing, lilv, lv2, serd, sord, sratom
, libbs2b, libmodplug, mpeg2dec
, openjpeg, libopus, librsvg
, wildmidi, fluidsynth, libvdpau, wayland
, libwebp, xvidcore, gnutls, mjpegtools
, libGLU_combined, libintl, libgme
, openssl, x265, libxml2
}:

assert faacSupport -> faac != null;

let
  inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = "gst-plugins-bad-${version}";
  version = "1.14.4";

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
    (fetchpatch {
        url = "https://bug794856.bugzilla-attachments.gnome.org/attachment.cgi?id=370409";
        sha256 = "0hy0rcn35alq65yqwri4fqjz2hf3nyyg5c7rnndk51msmqjxpprk";
    })
    ./fix_pkgconfig_includedir.patch
    # Enable bs2b compilation
    # https://bugzilla.gnome.org/show_bug.cgi?id=794346
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=369724;
      sha256 = "1716mp0h2866ab33w607isvfhv1zwyj71qb4jrkx5v0h276v1pwr";
    })
  ];

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz";
    sha256 = "1r8dma3x127rbx42yab7kwq7q1bhkmvz2ykn0rnqnzl95q74w2wi";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig python3 gettext ];

  buildInputs = [
    gst-plugins-base orc
    faad2 libass libkate libmms
    libnice webrtc-audio-processing # webrtc
    libbs2b
    ladspaH librdf # ladspa plug-in
    lilv lv2 serd sord sratom # lv2 plug-in
    libmodplug mpeg2dec
    openjpeg libopus librsvg
    fluidsynth libvdpau
    libwebp xvidcore gnutls libGLU_combined
    libgme openssl x265 libxml2
    libintl
  ]
    ++ optional faacSupport faac
    ++ optional stdenv.isLinux wayland
    # wildmidi requires apple's OpenAL
    # TODO: package apple's OpenAL, fix wildmidi, include on Darwin
    ++ optional (!stdenv.isDarwin) wildmidi
    # TODO: mjpegtools uint64_t is not compatible with guint64 on Darwin
    ++ optional (!stdenv.isDarwin) mjpegtools;

  enableParallelBuilding = true;

  doCheck = false; # fails 20 out of 58 tests, expensive

}
