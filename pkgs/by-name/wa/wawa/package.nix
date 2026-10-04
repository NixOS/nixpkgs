{
  stdenv,
  fetchFromCodeberg,
  lib,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wawa";
  version = "0.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "sewn";
    repo = "wawa";
    rev = finalAttrs.version;
    hash = "sha256-F7nPXi1zBnfNKSeZ2oQnGlfoJmKeSictPylpDBJtSRw=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
  ];

  env.NIX_CFLAGS_COMPILE = "-O3 -Wno-error=incompatible-pointer-types";

  makeFlags = [
    "PREFIX=$(out)"
    "WAYLAND_SCANNER=wayland-scanner"
  ];

  meta = {
    description = "Distinctive simpler wlroots wallpaper setter";
    longDescription = ''
      A simple, hackable, and distinctive Wayland wallpaper setter utilizing stb_image that targets wlr-layer-shell supported compositors, featuring tiling, spreading across monitors, along with fill, fit and stretching the wallpaper, with less SLOC than your average wallpaper setter.
    '';
    homepage = "https://codeberg.org/sewn/wawa";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ vavakado ];
    mainProgram = "wawa";
  };
})
