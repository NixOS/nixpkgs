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
  version = "5.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "duosecurity";
    repo = "duo_client_python";
    rev = "refs/tags/${version}";
    hash = "sha256-G0XLZZaQTPD64WXN34wq2z+YtzECgtC2nJXzDxAlgyg=";
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
  ];

  meta = with lib; {
    description = "Python library for interacting with the Duo Auth, Admin, and Accounts APIs";
    homepage = "https://github.com/duosecurity/duo_client_python";
    changelog = "https://github.com/duosecurity/duo_client_python/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
