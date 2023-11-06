{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch

# propagates
, django-gravatar2
, django-allauth
, mailmanclient
, pytz

# tests
, django
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.3.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GpI1W0O9aJpLF/mcS23ktJDZsP69S2zQy7drOiWBnTM=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/mailman/django-mailman3/-/commit/840d0d531a0813de9a30e72427e202aea21b40fe.patch";
      hash = "sha256-vltvsIP/SWpQZeXDUB+GWlTu+ghFMUqIT8i6CrYcmGo=";
    })
    (fetchpatch {
      url = "https://gitlab.com/mailman/django-mailman3/-/commit/25c55e31d28f2fa8eb23f0e83c12f9b0a05bfbf0.patch";
      hash = "sha256-ug5tBmnVfJTn5ufDDVg/cEtsZM59jQYJpQZV51T3qIc=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'django>=3.2,<4.2' 'django>=3.2,<4.3'
  '';

  propagatedBuildInputs = [
    django-allauth
    django-gravatar2
    mailmanclient
    pytz
  ];

  nativeCheckInputs = [
    django
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "django_mailman3"
  ];

  meta = with lib; {
    description = "Django library for Mailman UIs";
    homepage = "https://gitlab.com/mailman/django-mailman3";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
