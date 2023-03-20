{ lib
, fetchPypi
, buildPythonPackage
, celery
, django
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django_celery_results";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dapRlw21aRy/JCxqD/UMjN9BniZc0Om3cjNdBkNsS5k=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ babariviere ];
  };
}
