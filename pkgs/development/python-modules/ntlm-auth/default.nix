{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "ntlm-auth";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "ntlm-auth";
    rev = "v${version}";
    hash = "sha256-CRBR2eXUGngU7IvGuRfBnvH6QZhhwyh1dgd47VZxtwE=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [
    "ntlm_auth"
  ];

  disabledTests = [
    # Tests are outdated as module will be replaced by pyspnego
    "test_authenticate_message"
    "test_authenticate_without_domain_workstation"
    "test_create_authenticate_message"
    "test_get_"
    "test_lm_v"
    "test_nt_"
    "test_ntlm_context"
    "test_ntowfv"
  ];

  meta = with lib; {
    description = "Calculates NTLM Authentication codes";
    homepage = "https://github.com/jborean93/ntlm-auth";
    changelog = "https://github.com/jborean93/ntlm-auth/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elasticdog ];
  };
}
