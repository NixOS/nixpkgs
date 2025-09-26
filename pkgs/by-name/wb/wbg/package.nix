{
  stdenv,
  lib,
  fetchFromGitea,
  pkg-config,
  meson,
  ninja,
  pixman,
  tllist,
  wayland,
  wayland-scanner,
  wayland-protocols,
  libjxl,
  enablePNG ? true,
  enableJPEG ? true,
  enableWebp ? true,
  # Optional dependencies
  libpng,
  libjpeg,
  libwebp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wbg";
  version = "1.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "wbg";
    tag = finalAttrs.version;
    hash = "sha256-qEdl3dKeAfWWZ7+8MF59fAvtoELLA+C4680yFNsHhrY=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];

  buildInputs = [
    libjxl
    pixman
    tllist
    wayland
    wayland-protocols
  ]
  ++ lib.optional enablePNG libpng
  ++ lib.optional enableJPEG libjpeg
  ++ lib.optional enableWebp libwebp;

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonEnable "png" enablePNG)
    (lib.mesonEnable "jpeg" enableJPEG)
    (lib.mesonEnable "webp" enableWebp)
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=maybe-uninitialized"
  ];

  meta = {
    description = "Wallpaper application for Wayland compositors";
    homepage = "https://codeberg.org/dnkl/wbg";
    changelog = "https://codeberg.org/dnkl/wbg/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
    mainProgram = "wbg";
  };
})
