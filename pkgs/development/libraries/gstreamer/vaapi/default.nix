{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gst-plugins-base
, bzip2
, libva
, wayland
, wayland-protocols
, libdrm
, udev
, xorg
, gstreamer
, gst-plugins-bad
, nasm
, libvpx
, python3
}:

stdenv.mkDerivation rec {
  pname = "gstreamer-vaapi";
  version = "1.20.3";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-bumesxar3emtNwApFb2MOGeRj2/cdLfPKsTBrg1pC0U=";
  };

  outputs = [
    "out"
    "dev"
    # "devdoc" # disabled until `hotdoc` is packaged in nixpkgs
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    bzip2

    # documentation
    # TODO add hotdoc here
  ];

  buildInputs = [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    libva
    libdrm
    udev
    nasm
    libvpx
    python3
  ] ++ lib.optionals gst-plugins-base.glEnabled [
    xorg.libX11 # required by EGL even with X11 support disabled
  ] ++ lib.optionals gst-plugins-base.waylandEnabled [
    wayland
    wayland-protocols
  ] ++ lib.optionals gst-plugins-base.x11Enabled [
    xorg.libXrandr
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
  ]
  ++ lib.optional (!gst-plugins-base.x11Enabled) "-Dwith_x11=no";

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with lib; {
    description = "Set of VAAPI GStreamer Plug-ins";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
