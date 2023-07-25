{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, python3
, gstreamer
, gst-plugins-base
, gettext
, libav
# Checks meson.is_cross_build(), so even canExecute isn't enough.
, enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform, hotdoc
}:

# Note that since gst-libav-1.6, libav is actually ffmpeg. See
# https://gstreamer.freedesktop.org/releases/1.6/ for more info.

stdenv.mkDerivation rec {
  pname = "gst-libav";
  version = "1.22.4";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-mnUbx0Dedo55HDepXwqSTGpB0S/X839UzmpOg0vhItM=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    python3
  ] ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  buildInputs = [
    gstreamer
    gst-plugins-base
    libav
  ];

  mesonFlags = [
    (lib.mesonEnable "doc" enableDocumentation)
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
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}
