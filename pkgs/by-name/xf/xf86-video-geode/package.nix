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
  pname = "xf86-video-geode";
  version = "2.18.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-geode";
    tag = "xf86-video-geode-${finalAttrs.version}";
    hash = "sha256-G0w6Ft172ar5dwR3NAu+8vuvJqWKaknmpbdThpPR+kY=";
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
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-geode-(.*)" ]; };
  };

  meta = {
    description = "AMD Geode GX and LX graphics driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-geode";
    license = with lib.licenses; [
      x11
      x11BsdClause
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.aarch64;
  };
})
