{ stdenv, fetchurl, pkgconfig, gst-plugins-base, bzip2, libva, wayland
, libdrm, udev, xorg, mesa, yasm, gstreamer, gst-plugins-bad, nasm
, libvpx, python
}:

stdenv.mkDerivation rec {
  name = "gst-vaapi-${version}";
  version = "1.10.4";

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-vaapi/gstreamer-vaapi-${version}.tar.xz";
    sha256 = "0xfyf1mgcxnwf380wxv20hakl2srp34dmiw6bm4zkncl2mi91rh3";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig bzip2 ];

  buildInputs = [
    gstreamer gst-plugins-base gst-plugins-bad libva wayland libdrm udev
    xorg.libX11 xorg.libXext xorg.libXv xorg.libXrandr xorg.libSM
    xorg.libICE mesa nasm libvpx python
  ];

  preConfigure = "
    export GST_PLUGIN_PATH_1_0=$out/lib/gstreamer-1.0
    mkdir -p $GST_PLUGIN_PATH_1_0
    ";
  configureFlags = "--disable-builtin-libvpx --with-gstreamer-api=1.0";

  meta = {
    homepage = http://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
