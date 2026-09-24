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
  libgbm,
  libGL,
  libpciaccess,
  udev,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-ati";
  version = "22.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-ati";
    tag = "xf86-video-ati-${finalAttrs.version}";
    hash = "sha256-q8+lMYS9tfO64xT7t6PYIqsARX8Dv/8uMTMeP1JCt08=";
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
    libgbm
    libGL
    libpciaccess
    udev
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-ati-(.*)" ]; };
  };

  meta = {
    description = "ATI/AMD Radeon video driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-ati";
    license = with lib.licenses; [
      mit
      x11
      hpndSellVariant
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAarch64;
  };
})
