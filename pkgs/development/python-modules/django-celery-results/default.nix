{ lib
, fetchPypi
, buildPythonPackage
, celery
, django
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-celery-results";
  version = "2.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "django_celery_results";
    inherit version;
    hash = "sha256-PstxR/dz800DgbrGJGM3zkz4ii6nuCd07UjlGLZ7uP0=";
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
    changelog = "https://github.com/celery/django-celery-results/blob/v{version}/Changelog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ babariviere ];
  };
}
