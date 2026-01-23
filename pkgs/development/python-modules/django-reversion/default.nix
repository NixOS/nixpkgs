{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "6.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "django_reversion";
    inherit version;
    hash = "sha256-yrD9kGQLLOs316iXgjynKiG5YK0dajuctONR+rvSfZw=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  # Tests assume the availability of a mysql/postgresql database
  doCheck = false;

  pythonImportsCheck = [ "reversion" ];

  meta = {
    description = "Extension to the Django web framework that provides comprehensive version control facilities";
    homepage = "https://github.com/etianen/django-reversion";
    changelog = "https://github.com/etianen/django-reversion/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
