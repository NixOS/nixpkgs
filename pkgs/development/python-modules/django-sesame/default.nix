{ lib, buildPythonPackage, fetchPypi
, django }:

buildPythonPackage rec {
  pname = "django-sesame";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e68bad4a6ef44322380f1f01d009f9d3cb55d1ffef0b669574b511db5ab0c6c0";
  };

  checkInputs = [ django ];

  checkPhase = ''
    PYTHONPATH="$(pwd):$PYTHONPATH" \
    DJANGO_SETTINGS_MODULE=sesame.test_settings \
      django-admin test sesame
  '';

  meta = with lib; {
    description = "URLs with authentication tokens for automatic login";
    homepage = https://github.com/aaugustin/django-sesame;
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
