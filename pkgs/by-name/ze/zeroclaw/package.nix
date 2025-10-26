{
  lib,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  sqlite,
  writableTmpDirAsHomeHook,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeroclaw";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "zeroclaw-labs";
    repo = "zeroclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4AcWGEnSXdFmq4Fn/ecMrDVoUxSRYxqwiLQ3pcfCKv8=";
  };

  postPatch =
    let
      zeroclaw-web = callPackage ./zeroclaw-web { inherit (finalAttrs) src version; };
    in
    ''
      mkdir -p web
      ln -s ${zeroclaw-web} web/dist
    '';

  cargoHash = "sha256-NDE+OuYVs9j/wl+nK9hmAEPTbfF6ZOKkANhb+C+dAns=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    sqlite
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    gitMinimal
  ];

  checkFlags = [
    "--skip=memory::lucid::tests::failure_cooldown_avoids_repeated_lucid_calls"
    "--skip=memory::lucid::tests::recall_handles_lucid_cold_start_delay_within_timeout"
    "--skip=memory::lucid::tests::recall_merges_lucid_and_local_results"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, small, and fully autonomous AI assistant infrastructure — deploy anywhere, swap anything";
    homepage = "https://github.com/zeroclaw-labs/zeroclaw";
    changelog = "https://github.com/zeroclaw-labs/zeroclaw/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "zeroclaw";
  };
})
