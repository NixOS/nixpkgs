{ stdenv, fetchurl, pkgconfig, python, gst-plugins-base, orc
, faacSupport ? false, faac ? null
, faad2, libass, libkate, libmms
, libmodplug, mpeg2dec, mpg123
, openjpeg, libopus, librsvg
, wildmidi, fluidsynth, libvdpau, wayland
, libwebp, xvidcore, gnutls
, mesa
}:

assert faacSupport -> faac != null;

stdenv.mkDerivation rec {
  name = "gst-plugins-bad-1.4.5";

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
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz";
    sha256 = "0g4q9yqq71z32pz7zj54wigkcf438a2mcv5kvvwp4gb8a1rasbqm";
  };

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    faad2 libass libkate libmms
    libmodplug mpeg2dec mpg123
    openjpeg libopus librsvg
    wildmidi fluidsynth libvdpau wayland
    libwebp xvidcore gnutls mesa
  ] ++ stdenv.lib.optional faacSupport faac;
}
