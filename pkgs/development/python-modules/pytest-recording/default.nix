{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
# install dependencies
, pytest
, vcrpy
, attrs
# test dependencies
, pytestCheckHook
, pytest-httpbin
, pytest-mock
, requests
}:

buildPythonPackage rec {
  pname = "pytest-recording";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "kiwicom";
    repo = "pytest-recording";
    rev = "v${version}";
    hash = "sha256-nivwxaW8AIrBtPkzPJYfxlPxWn2NuYcaMry/IrBnnl0=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    vcrpy
    attrs
  ];

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
    maintainers = with maintainers; [ dennajort ];
  };
}
