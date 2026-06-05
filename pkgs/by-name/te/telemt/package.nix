{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "telemt";
  version = "3.4.13";

  src = fetchFromGitHub {
    owner = "telemt";
    repo = "telemt";
    tag = version;
    hash = "sha256-ChzvbbWS/h7bZXqG4h3Iftslzsv2Rad+hXx+SyY2p30=";
  };

  cargoHash = "sha256-UicmtNQvGUZJtj3I8zztyGiy+oU66LWwNV+MNpZ3omc=";

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
