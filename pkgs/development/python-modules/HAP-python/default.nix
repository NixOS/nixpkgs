{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, curve25519-donna, ed25519
, cryptography, ecdsa, zeroconf, pytest }:

buildPythonPackage rec {
  pname = "HAP-python";
  version = "2.9.2";

  # pypi package does not include tests
  src = fetchFromGitHub {
    owner = "ikalchev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d2ji2psla7jq3f9grb0l665nf8qsy2rlbkr2qg1d1a7mvf80x7k";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    curve25519-donna
    ed25519
    cryptography
    ecdsa
    zeroconf
  ];

  checkInputs = [ pytest ];

  #disable tests needing network
  checkPhase = ''
    pytest -k 'not test_persist \
    and not test_setup_endpoints \
    and not test_auto_add_aid_mac \
    and not test_service_callbacks \
    and not test_send_events \
    and not test_not_standalone_aid \
    and not test_start_stop_async_acc \
    and not test_external_zeroconf \
    and not test_start_stop_sync_acc'
  '';

  meta = with lib; {
    homepage = "https://github.com/ikalchev/HAP-python";
    description = "HomeKit Accessory Protocol implementation in python";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
