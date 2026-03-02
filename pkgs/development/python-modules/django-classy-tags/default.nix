{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
}:

buildPythonPackage rec {
  pname = "django-classy-tags";
  version = "4.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yNnRqi+m5xxNhm303RHSOmm40lu7dQskkKF7Fhd07lk=";
  };

  propagatedBuildInputs = [ django ];

  # pypi version doesn't include runtest.py, needed to run tests
  doCheck = false;

  pythonImportsCheck = [ "classytags" ];

  meta = {
    description = "Class based template tags for Django";
    homepage = "https://github.com/divio/django-classy-tags";
    changelog = "https://github.com/django-cms/django-classy-tags/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
