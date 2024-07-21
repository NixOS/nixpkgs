{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  # install dependencies
  pytest,
  vcrpy,
  # test dependencies
  hatchling,
  pytestCheckHook,
  pytest-httpbin,
  pytest-mock,
  requests,
}:

buildPythonPackage rec {
  pname = "pytest-recording";
  version = "0.13.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kiwicom";
    repo = "pytest-recording";
    rev = "refs/tags/v${version}";
    hash = "sha256-HyV1wWYS/8p45mZxgA1XSChLCTYq5iOzBRqKXyZpwgo=";
  };

  buildInputs = [
    hatchling
    pytest
  ];

  propagatedBuildInputs = [ vcrpy ];

  __darwinAllowLocalNetworking = true;

  checkInputs = [
    pytestCheckHook
    pytest-httpbin
    pytest-mock
    requests
  ];

  disabledTests =
    [ "test_block_network_with_allowed_hosts" ]
    ++ lib.optionals stdenv.isDarwin [
      # Missing socket.AF_NETLINK
      "test_other_socket"
    ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "pytest_recording" ];

  meta = with lib; {
    description = "Pytest plugin that allows you recording of network interactions via VCR.py";
    homepage = "https://github.com/kiwicom/pytest-recording";
    license = licenses.mit;
    maintainers = with maintainers; [ jbgosselin ];
  };
}
