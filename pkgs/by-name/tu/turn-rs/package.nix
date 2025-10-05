{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "turn-rs";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "mycrl";
    repo = "turn-rs";
    tag = "v${version}";
    hash = "sha256-BW5dNPkf/JGrf00BI41rEoZRmqftoz+RMGiP6ECVEec=";
  };

  cargoHash = "sha256-wnbovuxh3wc1TU8BYZEOG/8SO9bCUd0eWRC81MtAdqo=";

  # By default, no features are enabled
  # https://github.com/mycrl/turn-rs?tab=readme-ov-file#features-1
  cargoBuildFlags = [ "--all-features" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/turn-server";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.nixos = nixosTests.turn-rs;
  };

  meta = {
    description = "Pure rust implemented turn server";
    homepage = "https://github.com/mycrl/turn-rs";
    changelog = "https://github.com/mycrl/turn-rs/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "turn-server";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.linux;
  };
}
