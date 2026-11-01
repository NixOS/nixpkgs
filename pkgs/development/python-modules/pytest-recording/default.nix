{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.13.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kiwicom";
    repo = "pytest-recording";
    tag = "v${version}";
    hash = "sha256-S++MnI0GgpQxS6kFkt05kcE4JMW7jyFjJ3o7DhfYoVA=";
  };

  patches = [
    # fixes test_pytest_vcr_incompatibility test
    (fetchpatch {
      url = "https://github.com/kiwicom/pytest-recording/pull/211.patch";
      excludes = [
        ".github/workflows/build.yml"
      ];
      hash = "sha256-rQnS4Z26jdQ5qKpMmsF/TU/jpdgxu7eCqgDB7GOmLpE=";
    })
  ];

  build-system = [ hatchling ];

  buildInputs = [
    pytest
  ];

  dependencies = [ vcrpy ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-httpbin
    pytest-mock
    requests
  ];

  disabledTests = [
    "test_block_network_with_allowed_hosts"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Missing socket.AF_NETLINK
    "test_other_socket"
  ];

  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [ "pytest_recording" ];

  meta = {
    description = "Pytest plugin that allows you recording of network interactions via VCR.py";
    homepage = "https://github.com/kiwicom/pytest-recording";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jbgosselin ];
  };
}
