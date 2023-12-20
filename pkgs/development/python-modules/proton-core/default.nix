{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, aiohttp
, bcrypt
, pyopenssl
, python-gnupg
, requests
, pytestCheckHook
}:

buildPythonPackage {
  pname = "proton-core";
  version = "0.1.15-unstable-2023-10-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-core";
    rev = "5e795e04094dff67c03c56f2f3de03ff43514cc4";
    hash = "sha256-hchwrolc65tVmSe2IzxwH2zDU2JZzXrCMzWaETWcMDI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    bcrypt
    aiohttp
    pyopenssl
    python-gnupg
    requests
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton" ];

  nativeCheckInputs = [
    pytestCheckHook
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
    maintainers = with lib.maintainers; [ wolfangaukang ];
  };
}
