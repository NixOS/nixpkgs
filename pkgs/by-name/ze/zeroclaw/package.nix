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
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "zeroclaw-labs";
    repo = "zeroclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hVHfsBw3u0CLWAbmizLA9ZrB+3B0qBIrSUuzsyChwW0=";
  };

  postPatch =
    let
      zeroclaw-web = callPackage ./zeroclaw-web { inherit (finalAttrs) src version; };
    in
    ''
      mkdir -p web
      ln -s ${zeroclaw-web} web/dist
    '';

  cargoHash = "sha256-6MGIJsaqRp3k/ysjdu6BE2iM2sehERQR+QoSqiThSpg=";

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

  # wiremock tests require socket binding, which is denied in the darwin sandbox
  checkFlags = [
    "--skip=tests::exchange_pairing_code_posts_code_and_returns_token"
    "--skip=tests::fetch_pairing_code_reads_gateway_pair_code_response"
    "--skip=integration::telegram_attachment_fallback::"
    "--skip=integration::telegram_finalize_draft::"
  ];

  # The gateway serves the web dashboard from <binary_dir>/web/dist at runtime
  postInstall =
    let
      zeroclaw-web = callPackage ./zeroclaw-web { inherit (finalAttrs) src version; };
    in
    ''
      mkdir -p $out/bin/web
      ln -s ${zeroclaw-web} $out/bin/web/dist
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, small, and fully autonomous AI assistant infrastructure — deploy anywhere, swap anything";
    homepage = "https://github.com/zeroclaw-labs/zeroclaw";
    changelog = "https://github.com/zeroclaw-labs/zeroclaw/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      nixosclaw
    ];
    mainProgram = "zeroclaw";
  };
})
