{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, mock
, pytestCheckHook
, pythonOlder
, pytz
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "duo-client";
  version = "5.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "duosecurity";
    repo = "duo_client_python";
    rev = "refs/tags/${version}";
    hash = "sha256-MnSAFxKgExq+e8TOwgsPAoO4GEfsc3sjPNGLxzch5f0=";
  };

  postPatch = ''
    substituteInPlace requirements-dev.txt \
      --replace "dlint" "" \
      --replace "flake8" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    freezegun
    mock
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [
    "duo_client"
  ];

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
    changelog = "https://github.com/duosecurity/duo_client_python/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
