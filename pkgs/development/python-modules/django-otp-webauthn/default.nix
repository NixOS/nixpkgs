{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  django,
  django-otp,
  djangorestframework,
  webauthn,
}:

buildPythonPackage rec {
  pname = "django-otp-webauthn";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "django_otp_webauthn";
    sha256 = "sha256-+Y46/PDeXL9zayoZykaU63faQmnLHzYPmqJJeRBx+hs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    django-otp
    djangorestframework
    webauthn
  ];

  # Tests are on the roadmap, but not yet implemented

  pythonImportsCheck = [ "django_otp_webauthn" ];

  meta = with lib; {
    description = "Passkey support for Django";
    homepage = "https://github.com/Stormbase/django-otp-webauthn";
    changelog = "https://github.com/Stormbase/django-otp-webauthn/blob/main/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };

}
