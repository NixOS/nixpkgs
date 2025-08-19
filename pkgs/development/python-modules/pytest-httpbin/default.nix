{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpbin,
  pytest,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-httpbin";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kevin1024";
    repo = "pytest-httpbin";
    tag = "v${version}";
    hash = "sha256-gESU1SDpqSQs8GRcGJclWM0WpS4DZicfdtwxk2sQubQ=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ httpbin ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  disabledTests = [
    # incompatible with flask 2.3
    "test_redirect_location_is_https_for_secure_server"
    # Timeout on Hydra
    "test_dont_crash_on_handshake_timeout"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pytest_httpbin" ];

  meta = with lib; {
    description = "Test your HTTP library against a local copy of httpbin.org";
    homepage = "https://github.com/kevin1024/pytest-httpbin";
    changelog = "https://github.com/kevin1024/pytest-httpbin/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
