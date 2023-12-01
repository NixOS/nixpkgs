{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, poetry-core
, python
, pythonOlder
, ua-parser
}:

buildPythonPackage rec {
  pname = "django-sesame";
  version = "3.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-R7ySuop7E1lkxtRSVNFfzyb3Ba1mW0o6PDiTxTztK/Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    django
    ua-parser
  ];

  pythonImportsCheck = [
    "sesame"
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m django test --settings=tests.settings

    runHook postCheck
  '';

  meta = with lib; {
    description = "URLs with authentication tokens for automatic login";
    homepage = "https://github.com/aaugustin/django-sesame";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
