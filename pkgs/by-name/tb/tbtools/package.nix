{
  fetchFromGitHub,
  lib,
  nix-update-script,
  pkg-config,
  rustPlatform,
  stdenv,
  systemd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tbtools";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tbtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xLMnB8KliwHVU5y4L7K0a43gfdhLKFxnAx4wxGL9xMc=";
  };

  cargoHash = "sha256-QuiDI2/XzhUKF7BGnoKeJ2143keJtmi+8WG1MpulLZo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    systemd
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Thunderbolt/USB4 debugging tools";
    homepage = "https://github.com/intel/tbtools";
    license = lib.licenses.mit;
    mainProgram = "tblist";
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    platforms = lib.platforms.linux;
  };
})
