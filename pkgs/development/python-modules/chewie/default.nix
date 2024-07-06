{ lib
, fetchFromGitHub
, buildPythonPackage
, pbr
, eventlet
, transitions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "chewie";
  version = "0.0.24";

  src = fetchFromGitHub {
    owner = "faucetsdn";
    repo = "chewie";
    rev = version;
    sha256 = "sha256-ppv72wA2LvbnrJNRuOA7eZMqXjrZx4nbP+Gn02IwL9U=";
  };

  # We are installing from a tarball, so pbr will not be able to derive versioning.
  PBR_VERSION = version;

  propagatedBuildInputs = [
    pbr
    eventlet
    transitions
  ];

  pytestFlagsArray = [
    "--ignore=test/integration"
    "--ignore=test/fuzzer"
  ];

  /*
  Flaky tests due to state machine issues, ref https://github.com/faucetsdn/chewie/blob/master/test/unit/test_chewie.py#L27-L29

        > =========================== short test summary info ============================
       > FAILED test/unit/test_chewie.py::ChewieTestCase::test_logoff_dot1x - Assertio...
       > FAILED test/unit/test_chewie.py::ChewieTestCase::test_success_dot1x - Asserti...
       > ======================== 2 failed, 104 passed in 39.43s ========================
  */

  disabledTests = [
    "test_logoff_dot1x"
    "test_success_dot1x"
  ];


  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "EAPOL/802.1x implementation in Python, designed to serve as a library for the Faucet SDN project.";
    homepage = "https://github.com/faucetsdn/chewie";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
