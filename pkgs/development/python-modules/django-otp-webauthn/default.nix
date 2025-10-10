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
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "django_otp_webauthn";
    hash = "sha256-X+ZpptOy6pI6pYUQ+WKuNbOsvGNJD3ufmFgQS10dg+I=";
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
    changelog = "https://github.com/Stormbase/django-otp-webauthn/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };

}
