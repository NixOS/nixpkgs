{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkgconfig
, python3
, gst-plugins-base
, gettext
, libav
}:

# Note that since gst-libav-1.6, libav is actually ffmpeg. See
# https://gstreamer.freedesktop.org/releases/1.6/ for more info.

stdenv.mkDerivation rec {
  pname = "gst-libav";
  version = "1.16.3";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1v1q2n1rn5scag2dwp0rd399jvmacg35c2awr2bxx48al2qmw36i";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkgconfig
    python3
  ];

  buildInputs = [
    gst-plugins-base
    libav
  ];

  meta = with lib; {
    description = "FFmpeg/libav plugin for GStreamer";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
