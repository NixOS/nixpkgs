{ lib
, buildPythonPackage
, fetchPypi

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
    maintainers = with maintainers; [ globin qyliss ];
  };
}
