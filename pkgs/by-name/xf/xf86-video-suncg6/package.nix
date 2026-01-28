{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorg-server,
  xorgproto,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-suncg6";
  version = "1.1.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-suncg6";
    tag = "xf86-video-suncg6-${finalAttrs.version}";
    hash = "sha256-M9O0BNrKAFdiEgpZstH8KHRVIMEy5dI3y8rP+MSzLCY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
    xorg-server # for some autoconf macros
  ];

  buildInputs = [
    xorg-server
    xorgproto
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-suncg6-(.*)" ]; };
  };

  meta = {
    description = "Sun GX/Turbo GX video driver for the Xorg X server";
    longDescription = ''
      This driver supports the Sun GX, GXplus, TurboGX, and TurboGXplus Color Frame Buffers. These
      Sbus cards were supported in the sun4c, sun4m, sun4d, and sun4u platforms.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-suncg6";
    license = lib.licenses.hpndSellVariant;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xf86-video-suncg6.x86_64-darwin
  };
})
