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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tbtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gVVJzStmLJQMsc6DF8vEcJxTwpoRC0Kwq5WMzyNweB4=";
  };

  cargoHash = "sha256-0zwxpvCKpR78L6d/nJk/e1S5GQHL0lCQi2Ns9J/U1/o=";

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
