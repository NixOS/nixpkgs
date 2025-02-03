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
  version = "5.0.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wEfMmanxukqubbicOsJDR41t6Y7Ipgxwc/zIddicXNs=";
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
