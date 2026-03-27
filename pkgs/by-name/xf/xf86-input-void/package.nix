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
  pname = "xf86-input-void";
  version = "1.4.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-void";
    tag = "xf86-input-void-${finalAttrs.version}";
    hash = "sha256-R2c+FUBJQ9GfMcZ9NKSgT0lfOkqiCKrA+lFVu8l6e10=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];

  buildInputs = [
    xorg-server
    xorgproto
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-input-void-(.*)" ]; };
  };

  meta = {
    description = "Null input driver for the Xorg X server";
    longDescription = ''
      This is a null input driver for the Xorg X server.
      It doesn't connect to any physical device, and it never delivers any events.
      It functions as both a pointer and keyboard device, and may be used as the X server's core
      pointer and/or core keyboard.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-input-void";
    license = with lib.licenses; [
      hpndSellVariant
      mit
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xf86-input-void.x86_64-darwin
  };
})
