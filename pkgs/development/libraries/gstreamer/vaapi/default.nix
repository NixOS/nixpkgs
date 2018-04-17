{ stdenv, fetchurl, meson, ninja, pkgconfig, gst-plugins-base, bzip2, libva, wayland
, libdrm, udev, xorg, libGLU_combined, yasm, gstreamer, gst-plugins-bad, nasm
, libvpx, python
}:

stdenv.mkDerivation rec {
  name = "gst-vaapi-${version}";
  version = "1.14.0";

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-vaapi/gstreamer-vaapi-${version}.tar.xz";
    sha256 = "1whxk428badv8ibji00sn6hj17cp8l9n93rr948bz2gjbq41zqz4";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig bzip2 ];

  buildInputs = [
    gstreamer gst-plugins-base gst-plugins-bad libva wayland libdrm udev
    xorg.libX11 xorg.libXext xorg.libXv xorg.libXrandr xorg.libSM
    xorg.libICE libGLU_combined nasm libvpx python
  ];

  preConfigure = ''
    export GST_PLUGIN_PATH_1_0=$out/lib/gstreamer-1.0
    mkdir -p $GST_PLUGIN_PATH_1_0
  '';

  meta = {
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
