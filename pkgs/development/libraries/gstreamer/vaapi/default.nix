{ stdenv, fetchurl, pkgconfig, gst-plugins-base, bzip2, libva, wayland
, libdrm, udev, xorg, libGLU_combined, yasm, gstreamer, gst-plugins-bad, nasm
, libvpx, python
}:

stdenv.mkDerivation rec {
  name = "gst-vaapi-${version}";
  version = "1.12.4";

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-vaapi/gstreamer-vaapi-${version}.tar.xz";
    sha256 = "1jg9nvc8000yi2bcl3wn2yh2hwl7yvlwldj6778w8c0z5qj7fb8w";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig bzip2 ];

  buildInputs = [
    gstreamer gst-plugins-base gst-plugins-bad libva wayland libdrm udev
    xorg.libX11 xorg.libXext xorg.libXv xorg.libXrandr xorg.libSM
    xorg.libICE libGLU_combined nasm libvpx python
  ];

  preConfigure = "
    export GST_PLUGIN_PATH_1_0=$out/lib/gstreamer-1.0
    mkdir -p $GST_PLUGIN_PATH_1_0
    ";
  configureFlags = "--disable-builtin-libvpx --with-gstreamer-api=1.0";

  meta = {
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
