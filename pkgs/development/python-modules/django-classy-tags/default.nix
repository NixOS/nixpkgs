{ lib
, buildPythonPackage
, fetchPypi
, django
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-classy-tags";
  version = "4.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yNnRqi+m5xxNhm303RHSOmm40lu7dQskkKF7Fhd07lk=";
  };

  propagatedBuildInputs = [
    django
  ];

  # pypi version doesn't include runtest.py, needed to run tests
  doCheck = false;

  pythonImportsCheck = [
    "classytags"
  ];

  meta = with lib; {
    description = "Class based template tags for Django";
    homepage = "https://github.com/divio/django-classy-tags";
    changelog = "https://github.com/django-cms/django-classy-tags/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
