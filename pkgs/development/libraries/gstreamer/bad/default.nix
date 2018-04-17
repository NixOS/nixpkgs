{ stdenv, fetchurl, fetchpatch, meson, ninja, gettext
, pkgconfig, python, gst-plugins-base, orc
, faacSupport ? false, faac ? null
, faad2, libass, libkate, libmms
, libmodplug, mpeg2dec
, openjpeg, libopus, librsvg
, wildmidi, fluidsynth, libvdpau, wayland
, libwebp, xvidcore, gnutls, mjpegtools
, libGLU_combined, libintl, libgme
, openssl, x265, libxml2
}:

assert faacSupport -> faac != null;

let
  inherit (stdenv.lib) optional optionalString;

  # OpenJPEG version is hardcoded in package source
  openJpegVersion = with stdenv;
    lib.concatStringsSep "." (lib.lists.take 2
      (lib.splitString "." (lib.getVersion openjpeg)));

in
stdenv.mkDerivation rec {
  name = "gst-plugins-bad-1.14.0";

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

  preConfigure = ''
    patchShebangs .
  '';

  patches = [
    (fetchpatch {
        url = "https://bug794856.bugzilla-attachments.gnome.org/attachment.cgi?id=370409";
        sha256 = "0hy0rcn35alq65yqwri4fqjz2hf3nyyg5c7rnndk51msmqjxpprk";
    })
    ./fix_pkgconfig_includedir.patch
  ];

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz";
    sha256 = "17sgzgx1c54k5rzz7ljyz3is0n7yj56k74vv05h8z1gjnsnjnppd";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig python gettext ];

  buildInputs = [
    gst-plugins-base orc
    faad2 libass libkate libmms
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
}
