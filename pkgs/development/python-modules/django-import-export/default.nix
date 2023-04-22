{ lib
, buildPythonPackage
, chardet
, diff-match-patch
, django
, fetchFromGitHub
, python
, pythonOlder
, pytz
, tablib
}:

buildPythonPackage rec {
  pname = "django-import-export";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django-import-export";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-GvauDAkQd8dVCgon8nC7FPW4yLM7kS72g8bOBwt9RuY=";
  };

  propagatedBuildInputs = [
    diff-match-patch
    django
    tablib
  ] ++ (with tablib.optional-dependencies; html ++ ods ++ xls ++ xlsx ++ yaml);

  nativeCheckInputs = [
    chardet
    pytz
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/manage.py test core --settings=settings
    runHook postCheck
  '';

  pythonImportsCheck = [
    "import_export"
  ];

  meta = with lib; {
    description = "Django application and library for importing and exporting data with admin integration";
    homepage = "https://github.com/django-import-export/django-import-export";
    changelog = "https://github.com/django-import-export/django-import-export/blob/${version}/docs/changelog.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sephi ];
  };
}
