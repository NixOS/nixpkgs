{ stdenv, fetchurl, meson, ninja, pkgconfig, gst-plugins-base, bzip2, libva, wayland
, libdrm, udev, xorg, libGLU_combined, gstreamer, gst-plugins-bad, nasm
, libvpx, python, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "gst-vaapi";
  version = "1.16.0";

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-vaapi/gstreamer-vaapi-${version}.tar.xz";
    sha256 = "07qpynamiz0lniqajcaijh3n7ixs4lfk9a5mfk50sng0dricwzsf";
  };

  patches = [
    # See: https://mail.gnome.org/archives/distributor-list/2019-September/msg00000.html
    # Note that the patch has now been actually accepted upstream.
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi/commit/a90daabb84f983d2fa05ff3159f7ad59aa648b55.patch";
      sha256 = "0p2qygq6b5h6nxjdfnlzbsyih43hjq5c94ag8sbyyb8pmnids9rb";
    })
  ];

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
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ];

  meta = {
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
