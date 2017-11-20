{ stdenv, fetchurl, pkgconfig, python, gst-plugins-base, orc
, faacSupport ? false, faac ? null
, gtkSupport ? false, gtk3 ? null
, faad2, libass, libkate, libmms
, libmodplug, mpeg2dec, mpg123
, openjpeg, libopus, librsvg
, wildmidi, fluidsynth, libvdpau, wayland
, libwebp, xvidcore, gnutls, mjpegtools
, mesa, libintlOrEmpty, libgme
, openssl, x265, libxml2
}:

assert faacSupport -> faac != null;
assert gtkSupport -> gtk3 != null;

let
  inherit (stdenv.lib) optional optionalString;

  # OpenJPEG version is hardcoded in package source
  openJpegVersion = with stdenv;
    lib.concatStringsSep "." (lib.lists.take 2
      (lib.splitString "." (lib.getVersion openjpeg)));

in
stdenv.mkDerivation rec {
  name = "gst-plugins-bad-1.10.4";

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

  patchPhase = ''
    sed -i 's/openjpeg-2.1/openjpeg-${openJpegVersion}/' ext/openjpeg/*
  '';

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz";
    sha256 = "0rk9rlzf2b0hjw5hwbadz53yh4ls7vm3w3cshsa3n8isdd8axp93";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    faad2 gtk3 libass libkate libmms
    libmodplug mpeg2dec mpg123
    openjpeg libopus librsvg
    fluidsynth libvdpau
    libwebp xvidcore gnutls mesa
    mjpegtools libgme openssl x265 libxml2
  ]
    ++ libintlOrEmpty
    ++ optional faacSupport faac
    # for gtksink
    ++ optional gtkSupport gtk3
    ++ optional stdenv.isLinux wayland
    # wildmidi requires apple's OpenAL
    # TODO: package apple's OpenAL, fix wildmidi, include on Darwin
    ++ optional (!stdenv.isDarwin) wildmidi;

  LDFLAGS = optionalString stdenv.isDarwin "-lintl";
}
