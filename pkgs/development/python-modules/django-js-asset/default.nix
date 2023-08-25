{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, django
, python
}:

buildPythonPackage rec {
  pname = "django-js-asset";
  version = "2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-rxJ9TgVBiJByiFSLTg/dtAR31Fs14D4sh2axyBcKGTU=";
  };

  nativeBuildInputs = [
    hatchling
  ];

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
