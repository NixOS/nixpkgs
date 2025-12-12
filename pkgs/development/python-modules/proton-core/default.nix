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
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-core";
    tag = "v${version}";
    hash = "sha256-ZT/LkppzeEDGs9aOCx561fA1EgAShPCnMs8c05mgF0k=";
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
    "test_raw_ping"
    "test_successful"
    "test_without_pinning"
    # Failed assertions
    "test_bad_pinning_fingerprint_changed"
    "test_bad_pinning_url_changed"
    # Bcrypt 72-byte limit exceeded
    # https://github.com/ProtonVPN/python-proton-core/pull/10
    "test_compute_v"
    "test_generate_v"
    "test_srp"
  ];

  meta = {
    description = "Core logic used by the other Proton components";
    homepage = "https://github.com/ProtonVPN/python-proton-core";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
