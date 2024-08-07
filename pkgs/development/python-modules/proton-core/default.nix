{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  bcrypt,
  pyopenssl,
  python-gnupg,
  requests,
  pytestCheckHook,
  pyotp,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "proton-core";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-EZsPw2kPgY42MQxrXt7yAtCNSmSNN5AYxx7SllwsbvA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bcrypt
    aiohttp
    pyopenssl
    python-gnupg
    requests
  ];

  pythonImportsCheck = [ "proton" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pyotp
  ];

  disabledTestPaths = [
    # Single test, requires internet connection
    "tests/test_alternativerouting.py"
  ];

  disabledTests = [
    # Invalid modulus
    "test_modulus_verification"
    # Permission denied: '/run'
    "test_broken_data"
    "test_broken_index"
    "test_sessions"
    # No working transports found
    "test_auto_works_on_prod"
    "test_ping"
    "test_successful"
    "test_without_pinning"
    # Failed assertions
    "test_bad_pinning_fingerprint_changed"
    "test_bad_pinning_url_changed"
  ];

  meta = {
    description = "Core logic used by the other Proton components";
    homepage = "https://github.com/ProtonVPN/python-proton-core";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
