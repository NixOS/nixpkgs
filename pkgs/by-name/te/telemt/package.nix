{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "telemt";
  version = "3.4.25";

  src = fetchFromGitHub {
    owner = "telemt";
    repo = "telemt";
    tag = version;
    hash = "sha256-A9+PWpVyHgQOFb/OsLc8vl4kq8J9reW1/5Hn4yTdJeI=";
  };

  cargoHash = "sha256-ZaaT3S3Qy7HBI2dETy8JtvWttJWnkhRNA3wWz44pTpQ=";

  checkFlags = [
    # flaky: races between MiddleClientWriterCancelled and TrafficBudgetWaitCancelled observation paths
    "--skip=proxy::middle_relay::middle_relay_atomic_quota_invariant_tests::me_writer_data_write_obeys_flow_cancellation"
    # flaky: timing-coupling assertion fires on slower hardware
    "--skip=proxy::masking::masking_timing_budget_coupling_security_tests::adversarial_delayed_interface_lookup_does_not_consume_outcome_floor_budget"
  ];

  meta = {
    mainProgram = "telemt";
    description = "MTProxy for Telegram on Rust + Tokio";
    homepage = "https://github.com/telemt/telemt";
    maintainers = with lib.maintainers; [ r4v3n6101 ];
    platforms = lib.platforms.linux;
  };
}
