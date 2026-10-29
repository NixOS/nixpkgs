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
  udev,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-nouveau";
  version = "1.0.18";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-nouveau";
    tag = "xf86-video-nouveau-${finalAttrs.version}";
    hash = "sha256-gsrq32h0EKesivMoNbe1Thlc7FfubmS6zdwQmMxHsOk=";
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
    udev
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-nouveau-(.*)" ]; };
  };

  meta = {
    description = "Xorg X server driver for NVIDIA video cards";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-nouveau";
    license = with lib.licenses; [
      mit
      hpndSellVariant
      # possibly unfree code according to the manpage in the repo
      # https://gitlab.freedesktop.org/xorg/driver/xf86-video-nouveau/-/merge_requests/17
      # unfree
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
