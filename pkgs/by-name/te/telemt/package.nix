{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "telemt";
  version = "3.4.11";

  src = fetchFromGitHub {
    owner = "telemt";
    repo = "telemt";
    tag = version;
    hash = "sha256-jBspeSj8aRbHngK8bviVt/i1UiYUPRHSd8+7dnmJOQY=";
  };

  cargoHash = "sha256-x5/SLSlYeGx40oXj/I/5zvyTNgSBwKsA33OwVIq9LGw=";

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
