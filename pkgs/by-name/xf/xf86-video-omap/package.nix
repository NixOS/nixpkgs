{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorg-server,
  xorgproto,
  libdrm,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-omap";
  version = "0.4.5";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-omap";
    tag = "xf86-video-omap-${finalAttrs.version}";
    hash = "sha256-5IffoBuSqSs0bQVCJHva/465KK0njrJyvG51dZX/rnM=";
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
    libdrm
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=format-overflow" ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-omap-(.*)" ]; };
  };

  meta = {
    description = "Open-source X.org graphics driver for TI OMAP graphics";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-omap";
    license = lib.licenses.mit;
    maintainers = [ ];
    # libdrm_omap is only available on linux
    platforms = lib.platforms.linux;
  };
})
