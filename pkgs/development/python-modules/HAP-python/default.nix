{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, curve25519-donna, ed25519
, cryptography, ecdsa, zeroconf, pytestCheckHook }:

buildPythonPackage rec {
  pname = "HAP-python";
  version = "3.1.0";

  # pypi package does not include tests
  src = fetchFromGitHub {
    owner = "ikalchev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qg38lfjby2xfm09chzc40a7i3b84kgyfs7g4xq8f5m8s39hg6d7";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    curve25519-donna
    ed25519
    cryptography
    ecdsa
    zeroconf
  ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    #disable tests needing network
    "test_persist"
    "test_setup_endpoints"
    "test_auto_add_aid_mac"
    "test_service_callbacks"
    "test_send_events"
    "test_not_standalone_aid"
    "test_start_stop_async_acc"
    "test_external_zeroconf"
    "test_start_stop_sync_acc"
  ];

  meta = with lib; {
    homepage = "https://github.com/ikalchev/HAP-python";
    description = "HomeKit Accessory Protocol implementation in python";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
