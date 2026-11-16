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
  aws-lc,
  writableTmpDirAsHomeHook,
  gitMinimal,
  jq,
  python3,
  versionCheckHook,
  makeBinaryWrapper,
  which,
  nix-update-script,
  withMatrix ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeroclaw";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "zeroclaw-labs";
    repo = "zeroclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h5x5+ubEHLS6//Fge30wp2b+MBXSasXC/YNS3uk05bM=";
  };

  cargoHash = "sha256-w0g8THP4Dg59dMPMVeK3hTQciZ2+1ldRZ8bBmFAIr9I=";

  # zerocode is a separate workspace member and expects the daemon beside it.
  cargoBuildFlags = [
    "--package"
    "zeroclaw"
    "--package"
    "zerocode"
  ]
  ++ lib.optionals withMatrix [
    "--features"
    "zeroclaw/channel-matrix"
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
    aws-lc
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
    python3
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
    # PTY job-control regression test hangs in the Nix build sandbox
    "--skip=component::daemon_startup_feedback::daemon_feedback_follows_foreground_job_control_transitions"
    # runtime-trace.jsonl is not populated in the Nix build sandbox
    "--skip=component::verifiable_intent_notice_visibility::a_patch_that_does_not_enable_the_section_adds_no_second_record"
    "--skip=component::verifiable_intent_notice_visibility::enabling_the_section_through_config_patch_records_the_notice_once"
    "--skip=component::verifiable_intent_notice_visibility::the_withheld_notice_is_recorded_once_per_config_application"
    "--skip=component::verifiable_intent_notice_visibility::trace_is_the_channel_that_disappears_and_doctor_is_the_one_that_does_not"
    "--skip=component::verifiable_intent_notice_visibility::traced_notice_is_categorised_and_carries_its_warning_code"
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
