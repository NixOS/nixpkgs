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
  version = "1.16.3";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1glyzgqyaw9pb1rpbj4fx7swywsqc5759dfyhzcprs9z30y0n83p";
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
