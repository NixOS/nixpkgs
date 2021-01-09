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
, python3
}:

stdenv.mkDerivation rec {
  pname = "gstreamer-vaapi";
  version = "1.18.2";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1h67n7wk1297rzynknbyv44gdacblvkcvb37x8yxi5d0zms2qywc";
  };

  outputs = [
    "out"
    "dev"
    # "devdoc" # disabled until `hotdoc` is packaged in nixpkgs
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    bzip2

    # documentation
    # TODO add hotdoc here
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
    python3
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with stdenv.lib; {
    description = "Set of VAAPI GStreamer Plug-ins";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
  };
}
