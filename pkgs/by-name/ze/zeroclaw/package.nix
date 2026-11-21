{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  pkg-config,
  protobuf,
  sqlite,
  writableTmpDirAsHomeHook,
  gitMinimal,
  jq,
  versionCheckHook,
  makeBinaryWrapper,
  which,
  nix-update-script,
  withMatrix ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeroclaw";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "zeroclaw-labs";
    repo = "zeroclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ntONOqywlcJXLO4/v+212xUn637ipnw7Fi1ejfpstNo=";
  };

  cargoHash = "sha256-FY77N8KhBmfm9IwNvpb6G49gj4f8lqGKlb91i6CfeqA=";

  # zerocode is a separate workspace member and expects the daemon beside it.
  cargoBuildFlags = [
    "--package"
    "zeroclawlabs"
    "--package"
    "zerocode"
  ]
  ++ lib.optionals withMatrix [
    "--features"
    "zeroclawlabs/channel-matrix"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/web";
    hash = "sha256-xwp8rzQeZf51W4c/F//HlpYHi18Z61TeGuKD3DjUltk=";
  };
  npmRoot = "web";

  postPatch = ''
    # build.rs runs `npm ci && npm run build` during compilation,
    # skip and handle it ourselves in postBuild
    substituteInPlace crates/zeroclaw-gateway/build.rs \
      --replace-fail 'build_web_dashboard();' '// dashboard built via postBuild'

    # upstream hardcodes a Debian cross toolchain name that doesn't exist in the Nix sandbox
    substituteInPlace .cargo/config.toml \
      --replace-fail 'linker = "aarch64-linux-gnu-gcc"' ""
  '';

  nativeBuildInputs = [
    pkg-config
    protobuf
    nodejs
    npmHooks.npmConfigHook
    makeBinaryWrapper
  ];

  buildInputs = [
    sqlite
  ];

  postBuild = ''
    cargo run --frozen --release --package xtask --bin web -- gen-api
    pushd web
    npm run build
    popd
  '';

  # the release-workflow architecture tests shell out to scripts/release/*.sh
  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    gitMinimal
    jq
    which
  ];

  # wiremock tests require socket binding, which is denied in the darwin sandbox
  checkFlags = [
    "--skip=commands::update::tests::download_release_preserves_missing_checksum_fallback"
    "--skip=commands::update::tests::download_release_rejects_checksum_mismatch_without_writing"
    "--skip=commands::update::tests::download_release_verifies_checksum_before_writing"
    "--skip=tests::exchange_pairing_code_posts_code_and_returns_token"
    "--skip=tests::fetch_pairing_code_reads_gateway_pair_code_response"
    "--skip=tests::gateway_addr_in_use_message_skips_occupied_restart_hint_port"
    "--skip=tests::gateway_restart_hint_uses_gateway_bind_fallback_for_hostnames"
    "--skip=integration::telegram_attachment_fallback::"
    "--skip=integration::telegram_finalize_draft::"
  ];

  # The gateway serves the web dashboard from <binary_dir>/web/dist at runtime
  postInstall = ''
    mkdir -p $out/bin/web
    cp -r web/dist $out/bin/web/dist
    wrapProgram $out/bin/zerocode --prefix PATH : ${lib.makeBinPath [ which ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, small, and fully autonomous AI assistant infrastructure — deploy anywhere, swap anything";
    homepage = "https://github.com/zeroclaw-labs/zeroclaw";
    changelog = "https://github.com/zeroclaw-labs/zeroclaw/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      nixosclaw
    ];
    mainProgram = "zeroclaw";
  };
})
