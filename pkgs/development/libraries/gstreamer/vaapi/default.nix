{ stdenv, fetchurl, meson, ninja, pkgconfig, gst-plugins-base, bzip2, libva, wayland
, libdrm, udev, xorg, libGLU_combined, gstreamer, gst-plugins-bad, nasm
, libvpx, python
}:

stdenv.mkDerivation rec {
  pname = "gst-vaapi";
  version = "1.16.0";

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-vaapi/gstreamer-vaapi-${version}.tar.xz";
    sha256 = "07qpynamiz0lniqajcaijh3n7ixs4lfk9a5mfk50sng0dricwzsf";
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

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ];

  meta = {
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
