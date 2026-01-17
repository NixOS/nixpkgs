{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorgproto,
  libx11,
  libxmu,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xpr";
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xpr";
    tag = "xpr-${finalAttrs.version}";
    hash = "sha256-q8WcQSzlAwbdIcXWyQjjHmvuqYa4k2e7O+VhShwBDUE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];

  buildInputs = [
    xorgproto
    libx11
    libxmu
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=xpr-(.*)" ]; };

  meta = {
    description = "Utility to print an X window dump from xwd";
    longDescription = ''
      xpr takes as input a window dump file produced by xwd and formats it for output on various
      types of printers.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xpr";
    license = with lib.licenses; [
      mit
      x11
      hpnd
    ];
    mainProgram = "xpr";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
