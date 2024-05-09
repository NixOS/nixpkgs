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
  version = "3.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = "django-sesame";
    rev = "refs/tags/${version}";
    hash = "sha256-8jbYhD/PfPnutJZonmdrqLIQdXiUHF12w0M9tuyyDz0=";
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
    changelog = "https://github.com/aaugustin/django-sesame/blob/${version}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
