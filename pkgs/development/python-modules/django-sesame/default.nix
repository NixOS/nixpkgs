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
  version = "3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Pyyhm0th0cNEkM0sd6maCnf4qELsSO82c9CQuqQdn0w=";
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
