{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MwmCHltvzu3M5raXXxqcf6tq58fQ4SdqkONFlG+g3Lg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ django ];

  # Tests assume the availability of a mysql/postgresql database
  doCheck = false;

  pythonImportsCheck = [ "reversion" ];

  meta = with lib; {
    description = "Extension to the Django web framework that provides comprehensive version control facilities";
    homepage = "https://github.com/etianen/django-reversion";
    changelog = "https://github.com/etianen/django-reversion/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
