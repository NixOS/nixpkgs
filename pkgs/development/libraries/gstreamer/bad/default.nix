{ stdenv, fetchurl, pkgconfig, python, gst-plugins-base, orc
, faacSupport ? false, faac ? null
, gtkSupport ? false, gtk3 ? null
, faad2, libass, libkate, libmms
, libmodplug, mpeg2dec, mpg123
, openjpeg, libopus, librsvg
, wildmidi, fluidsynth, libvdpau, wayland
, libwebp, xvidcore, gnutls, mjpegtools
, libGLU_combined, libintl, libgme
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
  name = "gst-plugins-bad-1.12.3";

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
  };

  # TODO: Fix Cocoa build. The problem was ARC, which might be related to too
  #       old version of Apple SDK's.
  configureFlags = optional stdenv.isDarwin "--disable-cocoa";

  patchPhase = ''
    sed -i 's/openjpeg-2.2/openjpeg-${openJpegVersion}/' ext/openjpeg/*
  '';

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz";
    sha256 = "1v5z3i5ha20gmbb3r9dwsaaspv5fm1jfzlzwlzqx1gjj31v5kl1n";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    faad2 gtk3 libass libkate libmms
    libmodplug mpeg2dec mpg123
    openjpeg libopus librsvg
    fluidsynth libvdpau
    libwebp xvidcore gnutls libGLU_combined
    libgme openssl x265 libxml2
    libintl
  ]
    ++ optional faacSupport faac
    # for gtksink
    ++ optional gtkSupport gtk3
    ++ optional stdenv.isLinux wayland
    # wildmidi requires apple's OpenAL
    # TODO: package apple's OpenAL, fix wildmidi, include on Darwin
    ++ optional (!stdenv.isDarwin) wildmidi
    # TODO: mjpegtools uint64_t is not compatible with guint64 on Darwin
    ++ optional (!stdenv.isDarwin) mjpegtools;

  enableParallelBuilding = true;
}
