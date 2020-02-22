{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gst-plugins-base
, bzip2
, libva
, wayland
, libdrm
, udev
, xorg
, libGLU
, libGL
, gstreamer
, gst-plugins-bad
, nasm
, libvpx
, python
}:

stdenv.mkDerivation rec {
  pname = "gstreamer-vaapi";
  version = "1.16.2";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "00f6sx700qm1ximi1ag2c27m35dywwhhg6awhz85va34mfqff78r";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    bzip2
  ];

  buildInputs = [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    libva
    wayland
    libdrm
    udev
    xorg.libX11
    xorg.libXext
    xorg.libXv
    xorg.libXrandr
    xorg.libSM
    xorg.libICE
    libGL
    libGLU
    nasm
    libvpx
    python
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ];

  meta = with stdenv.lib; {
    description = "Set of VAAPI GStreamer Plug-ins";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
  };
}
