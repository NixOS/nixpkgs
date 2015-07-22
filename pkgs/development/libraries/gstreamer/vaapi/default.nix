{ stdenv, fetchurl, pkgconfig, gst-plugins-base, bzip2, libva
, libdrm, udev, xorg, mesa, yasm, gstreamer, gst-plugins-bad, nasm
, libvpx
}:

stdenv.mkDerivation rec {
  name = "gst-vaapi-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "${meta.homepage}/software/vaapi/releases/gstreamer-vaapi/gstreamer-vaapi-${version}.tar.bz2";
    sha256 = "1f3ji0h0x49w4wpqc0widraa9kvq0b47idrdxq4znjb8c1bwd97n";
  };

  nativeBuildInputs = with stdenv.lib; [ pkgconfig bzip2 ];

  buildInputs = with stdenv.lib; [ gstreamer gst-plugins-base gst-plugins-bad libva libdrm udev
    xorg.libX11 xorg.libXext xorg.libXv xorg.libXrandr xorg.libSM xorg.libICE mesa nasm libvpx ];

  preConfigure = "
    export GST_PLUGIN_PATH_1_0=$out/lib/gstreamer-1.0
    mkdir -p $GST_PLUGIN_PATH_1_0
    ";
  configureFlags = "--disable-builtin-libvpx --with-gstreamer-api=1.0";

  meta = {
    homepage = "http://www.freedesktop.org";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
