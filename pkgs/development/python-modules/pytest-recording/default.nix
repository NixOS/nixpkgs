{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
# install dependencies
, pytest
, vcrpy
<<<<<<< HEAD
# test dependencies
, hatchling
=======
, attrs
# test dependencies
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pytest-httpbin
, pytest-mock
, requests
}:

buildPythonPackage rec {
  pname = "pytest-recording";
<<<<<<< HEAD
  version = "0.13.0";
  format = "pyproject";
=======
  version = "0.12.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kiwicom";
    repo = "pytest-recording";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-SCHdzii6GYVWVY7MW/IW6CNZMuu5h/jXEj49P0jvhoE=";
  };

  buildInputs = [
    hatchling
=======
    hash = "sha256-nivwxaW8AIrBtPkzPJYfxlPxWn2NuYcaMry/IrBnnl0=";
  };

  buildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest
  ];

  propagatedBuildInputs = [
    vcrpy
<<<<<<< HEAD
  ];

  __darwinAllowLocalNetworking = true;

=======
    attrs
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkInputs = [
    pytestCheckHook
    pytest-httpbin
    pytest-mock
    requests
  ];

  disabledTests = [
    "test_block_network_with_allowed_hosts"
  ] ++ lib.optionals stdenv.isDarwin [
    # Missing socket.AF_NETLINK
    "test_other_socket"
  ];

  pytestFlagsArray = [
    "tests"
  ];

  pythonImportsCheck = [
    "pytest_recording"
  ];

  meta = with lib; {
    description = "A pytest plugin that allows you recording of network interactions via VCR.py";
    homepage = "https://github.com/kiwicom/pytest-recording";
    license = licenses.mit;
    maintainers = with maintainers; [ jbgosselin ];
  };
}
