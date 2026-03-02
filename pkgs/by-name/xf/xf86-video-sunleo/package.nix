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
  pname = "xf86-video-sunleo";
  version = "1.2.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-sunleo";
    tag = "xf86-video-sunleo-${finalAttrs.version}";
    hash = "sha256-YAm1KpPpY+jJ+uBTxzi9bju1XNVnKy28IofP57MzQmk=";
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
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-sunleo-(.*)" ]; };
  };

  meta = {
    description = "Sun Leo video driver for the Xorg X server";
    longDescription = ''
      This is an Xorg driver for Sun Leo (ZX) video cards.
      Also known as the ZX or T(urbo)ZX, Leo is a 24 bit accelerated 3D graphics card. Both cards
      are double-width, but the TZX also requires extra cooling in the form of an additional
      double-width fan card, so effectively takes up 4 SBus slots.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-sunleo";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xf86-video-sunleo.x86_64-darwin
  };
})
