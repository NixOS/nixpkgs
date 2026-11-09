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

buildPythonPackage (finalAttrs: {
  pname = "proton-core";
  version = "0.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WTxFGua0OhgqsxgZJUI3M+WvUeYF9MsYVIa6Us7UfZ0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bcrypt
    aiohttp
    pyopenssl
    python-gnupg
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pyotp
  ];

  pythonImportsCheck = [ "proton" ];

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
    changelog = "https://github.com/ProtonVPN/python-proton-core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
