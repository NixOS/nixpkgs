<<<<<<< HEAD
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
=======
{ lib, buildPythonPackage, fetchPypi, django-gravatar2, django-compressor
, django-allauth, mailmanclient, django, mock
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.3.9";
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GpI1W0O9aJpLF/mcS23ktJDZsP69S2zQy7drOiWBnTM=";
  };

<<<<<<< HEAD
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
=======
  propagatedBuildInputs = [
    django-gravatar2 django-compressor django-allauth mailmanclient
  ];
  nativeCheckInputs = [ django mock ];

  checkPhase = ''
    cd $NIX_BUILD_TOP/$sourceRoot
    PYTHONPATH=.:$PYTHONPATH django-admin.py test --settings=django_mailman3.tests.settings_test
  '';

  pythonImportsCheck = [ "django_mailman3" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Django library for Mailman UIs";
    homepage = "https://gitlab.com/mailman/django-mailman3";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ globin qyliss ];
  };
}
