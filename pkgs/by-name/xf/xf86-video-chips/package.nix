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
  pname = "xf86-video-chips";
  version = "1.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-chips";
    tag = "xf86-video-chips-${finalAttrs.version}";
    hash = "sha256-MQ6aT+fWKFtpdzV40LzMrr046h0ZRmHi2sgWjuYUMq8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
    xorg-server # for some autoconf macros
  ];

  buildInputs = [
    xorgproto
    libpciaccess
    xorg-server
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-chips-(.*)" ]; };
  };

  meta = {
    description = "Chips & Technologies video driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-chips";
    license = with lib.licenses; [
      hpndSellVariant
      bsd3
      dec3Clause
      mit
      x11
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAarch64;
  };
})
