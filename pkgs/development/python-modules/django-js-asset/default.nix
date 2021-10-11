{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, python
}:

buildPythonPackage rec {
  pname = "django-js-asset";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
    rev = version;
    sha256 = "0viygwdz9i0ra6bz3z4w7h94qc7q134aq7bd4x2qwwhm84qmrip4";
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
