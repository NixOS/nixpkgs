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
  # makes zeroclaw-web overrideable
  npmDepsHash ? "sha256-RMiFoPj4cbUYONURsCp4FrNuy9bR1eRWqgAnACrVXsI=",
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeroclaw";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "zeroclaw-labs";
    repo = "zeroclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uBlM5N9+a22HL7CSlpLIapqFFd+MEqhbb94LtiN3FAs=";
  };

  postPatch =
    let
      zeroclaw-web = callPackage ./zeroclaw-web {
        inherit (finalAttrs) src version;
        inherit npmDepsHash;
      };
    in
    ''
      mkdir -p web
      ln -s ${zeroclaw-web} web/dist
    '';

  cargoHash = "sha256-1/s2ijYqanhHIsYSw85c4H3T5phnAfvV7oQeAl/6lxQ=";

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
