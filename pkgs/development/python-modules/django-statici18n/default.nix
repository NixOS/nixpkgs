{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, django-appconf
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-statici18n";
  version = "2.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zyegfryed";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2fFJJNdF0jspS7djDL8sToPTetzNR6pfNp5ohCNa30I=";
  };

  propagatedBuildInputs = [
    django
    django-appconf
  ];

  pythonImportsCheck = [
    "statici18n"
  ];

  DJANGO_SETTINGS_MODULE = "tests.test_project.project.settings";

  checkInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Helper for generating Javascript catalog to static files";
    homepage = "https://github.com/zyegfryed/django-statici18n";
    license = licenses.bsd3;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
