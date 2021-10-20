{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, python3
, gst-plugins-base
, gettext
, libav
}:

# Note that since gst-libav-1.6, libav is actually ffmpeg. See
# https://gstreamer.freedesktop.org/releases/1.6/ for more info.

stdenv.mkDerivation rec {
  pname = "gst-libav";
  version = "1.18.4";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "15n3x3vhshqa3icw93g4vqmqd46122anzqvfxwn6q8famlxlcjil";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    python3
  ];

  buildInputs = [
    gst-plugins-base
    libav
  ];

  mesonFlags = [
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with lib; {
    description = "FFmpeg/libav plugin for GStreamer";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
