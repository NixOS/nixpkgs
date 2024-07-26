{ lib
, buildPythonPackage
, fetchFromGitHub

# tests
, django
, djangorestframework
, python
}:

buildPythonPackage rec {
  pname = "rules";
  version = "3.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dfunckt";
    repo = "django-rules";
    rev = "v${version}";
    hash = "sha256-UFRfRwcvxEn0fD3ScJJ7f/EHd93BOpY3cEF9QDryJZY=";
  };

  pythonImportsCheck = [
    "rules"
  ];

  nativeCheckInputs = [
    django
    djangorestframework
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/manage.py test testsuite -v2
    runHook postCheck
  '';

  meta = with lib; {
    description = "Awesome Django authorization, without the database";
    homepage = "https://github.com/dfunckt/django-rules";
    changelog = "https://github.com/dfunckt/django-rules/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
