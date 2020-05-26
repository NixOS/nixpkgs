{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, curve25519-donna, ed25519
, cryptography, ecdsa, zeroconf, pytest }:

buildPythonPackage rec {
  pname = "HAP-python";
  version = "2.8.1";

  # pypi package does not include tests
  src = fetchFromGitHub {
    owner = "ikalchev";
    repo = pname;
    rev = "v${version}";
    sha256 = "182s3dk7y29wql9bazlnw840xqgsbr44ad72m668qgxd82jl6y9c";
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
    and not test_start_stop_sync_acc'
  '';

  meta = with lib; {
    homepage = "https://github.com/ikalchev/HAP-python";
    description = "HomeKit Accessory Protocol implementation in python";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
