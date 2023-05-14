{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, python
}:

buildPythonPackage rec {
  pname = "django-js-asset";
  version = "2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-YDOmbqB0xDBAlOSO1UBYJ8VfRjJ8Z6Hw1i24DNSrnjw=";
  };

  propagatedBuildInputs = [
    django
  ];

  pythonImportsCheck = [
    "js_asset"
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/manage.py test testapp
    runHook postCheck
  '';

  meta = with lib; {
    description = "Script tag with additional attributes for django.forms.Media";
    homepage = "https://github.com/matthiask/django-js-asset";
    maintainers = with maintainers; [ hexa ];
    license = with licenses; [ bsd3 ];
  };
}
