{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, django
, tablib
, python
}:

buildPythonPackage rec {
  pname = "django-tables2";
  version = "2.6.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jieter";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-n8qvsm/i+2VclFc00jQGO0Z4l6Ke8qZ03EYuEQcPuVQ=";
  };

  propagatedBuildInputs = [
    django
    tablib
  ];

  pythonImportsCheck = [
    # Requested setting DJANGO_TABLES2_TEMPLATE, but settings are not configured.
  ];

  doCheck = false; # needs django-boostrap{3,4} packages

  # Leave this in! Discovering how to run tests is annoying in Django apps
  checkPhase = ''
    ${python.interpreter} example/manage.py test
  '';

  meta = with lib; {
    description = "Django app for creating HTML tables";
    homepage = "https://github.com/jieter/django-tables2";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
