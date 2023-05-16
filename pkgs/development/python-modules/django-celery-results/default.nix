{ lib
, fetchPypi
, buildPythonPackage
, celery
, django
, pythonOlder
}:

buildPythonPackage rec {
<<<<<<< HEAD
  pname = "django-celery-results";
  version = "2.5.1";
=======
  pname = "django_celery_results";
  version = "2.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
<<<<<<< HEAD
    pname = "django_celery_results";
    inherit version;
    hash = "sha256-PstxR/dz800DgbrGJGM3zkz4ii6nuCd07UjlGLZ7uP0=";
=======
    inherit pname version;
    hash = "sha256-dapRlw21aRy/JCxqD/UMjN9BniZc0Om3cjNdBkNsS5k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # Drop malformatted tests_require specification
    sed -i '/tests_require=/d' setup.py
  '';

  propagatedBuildInputs = [
    celery
    django
  ];

  # Tests need access to a database.
  doCheck = false;

  meta = with lib; {
    description = "Celery result back end with django";
    homepage = "https://github.com/celery/django-celery-results";
<<<<<<< HEAD
    changelog = "https://github.com/celery/django-celery-results/blob/v{version}/Changelog";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ babariviere ];
  };
}
