{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorg-server,
  xorgproto,
  libpciaccess,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-neomagic";
  version = "1.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-neomagic";
    tag = "xf86-video-neomagic-${finalAttrs.version}";
    hash = "sha256-j1zhKGYmKADZ/6WuCQTca7l+rTgqlLhGoQvYhWxWAAE=";
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
    libpciaccess
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-neomagic-(.*)" ]; };
  };

  meta = {
    description = "NeoMagic video driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-neomagic";
    license = with lib.licenses; [
      hpndSellVariant
      mit
      # the repo contains several copyright notices without a license
      unfree
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
