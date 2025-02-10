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
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "mycrl";
    repo = "turn-rs";
    tag = "v${version}";
    hash = "sha256-kNE6FbHAFVWH04uTJBCRkrB0yzIjuXX3rxi2h5WmKWo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VHfWVEYla7iHOATC4Rv7k560O2VUqAe4ZMo/hLiSOi4=";

  # By default, no features are enabled
  # https://github.com/mycrl/turn-rs?tab=readme-ov-file#features-1
  cargoBuildFlags = [ "--all-features" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/turn-server";
  versionCheckProgramArg = [ "--version" ];
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
