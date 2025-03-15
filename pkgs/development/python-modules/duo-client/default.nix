{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  mock,
  pytestCheckHook,
  pythonOlder,
  pytz,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "duo-client";
  version = "5.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "duosecurity";
    repo = "duo_client_python";
    tag = version;
    hash = "sha256-CZfB40TMTNhs2sGPVobcs3poSsYJ03qDjVoADlvLi88=";
  };

  postPatch = ''
    substituteInPlace requirements-dev.txt \
      --replace-fail "dlint" "" \
      --replace-fail "flake8" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [
    freezegun
    mock
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "duo_client" ];

  disabledTests = [
    # Tests require network access
    "test_server_hostname"
    "test_server_hostname_with_port"
    "test_get_billing_edition"
    "test_get_telephony_credits"
    "test_set_business_billing_edition"
    "test_set_enterprise_billing_edition"
    "test_set_telephony_credits"
  ];

  meta = with lib; {
    description = "Python library for interacting with the Duo Auth, Admin, and Accounts APIs";
    homepage = "https://github.com/duosecurity/duo_client_python";
    changelog = "https://github.com/duosecurity/duo_client_python/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
