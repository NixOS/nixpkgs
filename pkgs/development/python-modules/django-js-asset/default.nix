{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, python
}:

buildPythonPackage rec {
  pname = "django-js-asset";
  version = "unstable-2021-06-07";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
    rev = "a186aa0b5721ca95da6cc032a2fb780a152f581b";
    sha256 = "141zxng0wwxalsi905cs8pdppy3ad717y3g4fkdxw4n3pd0fjp8r";
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
