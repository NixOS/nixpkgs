{ stdenv, fetchurl, pkgconfig, python, gst-plugins-base, orc
, faacSupport ? false, faac ? null
, faad2, libass, libkate, libmms
, libmodplug, mpeg2dec, mpg123
, openjpeg, libopus, librsvg
, wildmidi, fluidsynth, libvdpau, wayland
, libwebp, xvidcore, gnutls, mjpegtools
, mesa, libintlOrEmpty
}:

assert faacSupport -> faac != null;

let
  inherit (stdenv.lib) optional optionalString;
in
stdenv.mkDerivation rec {
  name = "gst-plugins-bad-1.8.2";

  meta = with stdenv.lib; {
    description = "Gstreamer Bad Plugins";
    homepage    = "http://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that aren't up to par compared to the
      rest.  They might be close to being good quality, but they're missing
      something - be it a good code review, some documentation, a set of tests,
      a real live maintainer, or some actual wide use.
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz";
    sha256 = "d7995317530c8773ec088f94d9320909d41da61996b801ebacce9a56af493f97";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    faad2 libass libkate libmms
    libmodplug mpeg2dec mpg123
    openjpeg libopus librsvg
    fluidsynth libvdpau
    libwebp xvidcore gnutls mesa
    mjpegtools
  ]
    ++ libintlOrEmpty
    ++ optional faacSupport faac
    ++ optional stdenv.isLinux wayland
    # wildmidi requires apple's OpenAL
    # TODO: package apple's OpenAL, fix wildmidi, include on Darwin
    ++ optional (!stdenv.isDarwin) wildmidi;

  LDFLAGS = optionalString stdenv.isDarwin "-lintl";
}
