{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "tola";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "tola-rs";
    repo = "tola-ssg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nFM+EXi3njnyfUxEGYPvk4izmmVs4ZW2ebOEGCwey+I=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-0cpAm4QHvgH0VlZm65/5pmD82nTBl23kHkNouiyXFyE=";

  # Tests bind localhost TCP listeners on macOS.
  __darwinAllowLocalNetworking = true;

  # TODO: drop this list once upstream feature-gates these tests.
  # FSEvents is unavailable in the Darwin sandbox.
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=dev::rebuild::tests::failed_font_reads_remain_watched"
    "--skip=dev::rebuild::tests::rejected_config_frees_generator_events"
    "--skip=dev::watch::fs::tests::failed_candidate_keeps_hook_inputs"
    "--skip=dev::watch::fs::tests::failed_chain_retry_follows_recorded_hook_output"
    "--skip=dev::watch::fs::tests::failed_hook_outputs_never_suppress"
    "--skip=dev::watch::fs::tests::missing_candidate_inputs_wake_recovery"
    "--skip=dev::watch::fs::tests::repaired_package_input_rechecks_once"
  ];

  cargoTestFlags = [ "--workspace" ];

  meta = {
    description = "Typst-based static site generator";
    homepage = "https://tola.build";
    license = lib.licenses.mit;
    mainProgram = "tola";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      kawayww
      matthiasbeyer
    ];
  };
})
