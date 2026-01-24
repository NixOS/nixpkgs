{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorgproto,
  xorg-server,
  libpciaccess,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-nv";
  version = "2.1.23";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-nv";
    tag = "xf86-video-nv-${finalAttrs.version}";
    hash = "sha256-8I7PnxOPXrUv0Ezj1H2qgUQdRDE99znSqUaieP6Pu8s=";
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
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-nv-(.*)" ]; };
  };

  meta = {
    description = "Minimal NVIDIA video driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-nv";
    license = with lib.licenses; [
      mit
      hpndSellVariant
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
