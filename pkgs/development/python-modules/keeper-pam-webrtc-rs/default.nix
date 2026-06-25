{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytest,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "keeper-pam-webrtc-rs";
  version = "1.1.7";
  pyproject = true;

  src = fetchPypi {
    pname = builtins.replaceStrings [ "-" ] [ "_" ] pname;
    inherit version;
    hash = "sha256-6RnqIZx+p7a+4Dv549n4BBVJANzFfBGmDk07/Fi+ssU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-sdkkWJjrVDtstMnjX2VpcU46S8bHiK6eSh16dslpBUE=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  patchPhase = ''
    # If missing README.md: Failed to read readme specified in pyproject.toml, which should be at /build/keeper_pam_webrtc_rs-1.1.6/README.md
    touch README.md
  '';

  nativeCheckInputs = [
    pytest
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests require internet access
    "tests/test_cleanup.py::TestCleanupIntegration::test_integration_pattern_old_style"
    "tests/test_close_operations.py::TestCloseOperations::test_close_connection_after_peer_connection"
    "tests/test_ice_restart_and_keepalive.py::TestICERestartAndKeepalive::test_connection_stats_api"
    "tests/test_ice_restart_and_keepalive.py::TestICERestartAndKeepalive::test_keepalive_functionality_monitoring"
    "tests/test_ice_restart_and_keepalive.py::TestICERestartAndKeepalive::test_manual_ice_restart_api"
    "tests/test_metrics_system.py::TestMetricsSystem::test_metrics_integration_with_basic_functionality"
    "tests/test_performance.py::TestWebRTCPerformance::test_data_channel_load"
    "tests/test_performance.py::TestWebRTCPerformance::test_e2e_echo_flow"
    "tests/test_performance.py::TestWebRTCFragmentation::test_data_channel_fragmentation"
  ];

  preCheck = ''
    # Or fails with: ModuleNotFoundError: No module named 'test_utils'
    cd tests
  '';

  doCheck = true;
  pythonImportsCheck = [ "keeper_pam_webrtc_rs" ];

  meta = {
    description = "A secure, stable, and high-performance Tube API for Python, providing WebRTC-based secure tunneling with enterprise-grade security and reliability optimizations.";
    homepage = "https://pypi.org/project/keeper-pam-webrtc-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gesperon ];
  };
}
