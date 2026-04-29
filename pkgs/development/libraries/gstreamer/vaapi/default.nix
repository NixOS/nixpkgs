{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gst-plugins-base,
  bzip2,
  libva,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libdrm,
  udev,
  libxv,
  libxrandr,
  libxext,
  libx11,
  libsm,
  libice,
  libxcb,
  libGLU,
  libGL,
  gstreamer,
  gst-plugins-bad,
  nasm,
  libvpx,
  python3,
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  hotdoc,
  directoryListingUpdater,
  apple-sdk_gstreamer,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gstreamer-vaapi";
  version = "1.26.11";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-${finalAttrs.version}.tar.xz";
    hash = "sha256-8S+TAnPHodPg1/hblP+dE3nRYqzMky6Mo9OJk+0n/Kw=";
  };

  separateDebugInfo = true;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    bzip2
    wayland-scanner
  ]
  ++ lib.optionals enableDocumentation [
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
    libx11
    libxcb
    libxext
    libxv
    libxrandr
    libsm
    libice
    nasm
    libvpx
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    libGLU
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    (lib.mesonEnable "doc" enableDocumentation)
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  preFixup = ''
    moveToOutput "lib/gstreamer-1.0/pkgconfig" "$dev"
  '';

  passthru = {
    updateScript = directoryListingUpdater { odd-unstable = true; };
  };

  meta = {
    description = "Set of VAAPI GStreamer Plug-ins";
    homepage = "https://gstreamer.freedesktop.org";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
