{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  libxkbfile,
  libx11,
  xorgproto,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xwd";
  version = "1.0.9";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xwd";
    tag = "xwd-${finalAttrs.version}";
    hash = "sha256-cEKm0c50qwWzGSkH1sdovNfN3dW1hmnaEDwuJKwxGdo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];

  buildInputs = [
    libxkbfile
    libx11
    xorgproto
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=xwd-(.*)" ]; };

  meta = {
    description = "Utility to dump an image of an X window in XWD format";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xwd";
    license = with lib.licenses; [
      mitOpenGroup
      hpndSellVariant
    ];
    mainProgram = "xwd";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
