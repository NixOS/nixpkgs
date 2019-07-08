{ lib, buildPythonPackage, fetchPypi
, django }:

buildPythonPackage rec {
  pname = "django-sesame";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "081q3vd9waiajiipg99flw0vlzk920sz07067v3n5774gx0qhbaa";
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
