{
  lib,
  rustPlatform,
  fetchFromGitHub,
  # Dependencies
  protobuf,
  coturn,
  # Tests
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "turn-rs";
  version = "4.1.5";

  src = fetchFromGitHub {
    owner = "mycrl";
    repo = "turn-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GNmRf+BFn8vtAKn7pkoCM9VF8MP/ymrqWrfhKRG3hUs=";
  };

  cargoHash = "sha256-TmmVZfAe48hgeDNkCQ746lBDRnrsgfFpXD8XwJRLB1o=";

  # By default, no features are enabled
  # https://github.com/mycrl/turn-rs?tab=readme-ov-file#features-1
  cargoBuildFlags = [ "--all-features" ];

  nativeBuildInputs = [
    protobuf
  ];

  # Fix coturn needed
  nativeCheckInputs = [ coturn ];
  env.COTURN_UCLIENT_PATH = lib.getExe' coturn "turnutils_uclient";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/turn-server";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.nixos = nixosTests.turn-rs;
  };

  meta = {
    description = "Pure rust implemented turn server";
    homepage = "https://github.com/mycrl/turn-rs";
    changelog = "https://github.com/mycrl/turn-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "turn-server";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.linux;
  };
})
