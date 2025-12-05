{
  lib,
  fetchPypi,
  buildPythonPackage,
  celery,
  django,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-celery-results";
  version = "2.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "django_celery_results";
    inherit version;
    hash = "sha256-mrzYNq5rYQY3eSRNiIeoj+gLv6uhQ98208sHA0ZxJ3w=";
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
    changelog = "https://github.com/celery/django-celery-results/blob/v${version}/Changelog";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
