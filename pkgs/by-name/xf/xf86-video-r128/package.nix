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
  libpciaccess,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-r128";
  version = "6.13.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-r128";
    tag = "xf86-video-r128-${finalAttrs.version}";
    hash = "sha256-f75PQ3pmWtyqeEfrMQpO31U0QOydlmQ49gJuvneRoso=";
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
    libpciaccess
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-r128-(.*)" ]; };
  };

  meta = {
    description = "ATI Rage 128 video driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-r128";
    license = with lib.licenses; [
      mit
      hpndSellVariant
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
