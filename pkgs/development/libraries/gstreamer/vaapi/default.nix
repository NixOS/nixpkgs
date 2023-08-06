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
, libGLU
, libGL
, gstreamer
, gst-plugins-bad
, nasm
, libvpx
, python3
# Checks meson.is_cross_build(), so even canExecute isn't enough.
, enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform, hotdoc
}:

stdenv.mkDerivation rec {
  pname = "gstreamer-vaapi";
  version = "1.22.4";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-lnuONT2C0AgaaNxTY5sl2ftMqJv6HgYUA+DNfSNYW6Y=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    bzip2
    wayland
  ] ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  buildInputs = [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    libva
    wayland
    wayland-protocols
    libdrm
    udev
    xorg.libX11
    xorg.libXext
    xorg.libXv
    xorg.libXrandr
    xorg.libSM
    xorg.libICE
    nasm
    libvpx
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libGL
    libGLU
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    (lib.mesonEnable "doc" enableDocumentation)
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with lib; {
    description = "Set of VAAPI GStreamer Plug-ins";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}
