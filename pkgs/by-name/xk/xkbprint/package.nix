{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  libx11,
  libxkbfile,
  xorgproto,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xkbprint";
  version = "1.0.8";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xkbprint";
    tag = "xkbprint-${finalAttrs.version}";
    hash = "sha256-ul/gMblKljyUYA2EK1X3FRRKbJ6I0x9Y31Bmi4QdDoo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];

  buildInputs = [
    libx11
    libxkbfile
    xorgproto
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=xkbprint-(.*)" ]; };

  meta = {
    description = "Generates a PostScript image of an XKB keyboard description.";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xkbprint";
    license = with lib.licenses; [
      hpnd
      hpndDec
    ];
    mainProgram = "xkbprint";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
