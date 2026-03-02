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
  pname = "xf86-video-sunffb";
  version = "1.2.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-sunffb";
    tag = "xf86-video-sunffb-${finalAttrs.version}";
    hash = "sha256-wuzODH7iRBxWHzVE8v/npy1/BwS3r08GduMEDdtJd9E=";
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
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-sunffb-(.*)" ]; };
  };

  meta = {
    description = "Sun FFB video driver for the Xorg X server";
    longDescription = ''
      This driver supports Sun Creator, Creator 3D and Elite 3D video cards, which are UPA bus
      devices for UltraSPARC workstations.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-sunffb";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xf86-video-sunffb.x86_64-darwin
  };
})
