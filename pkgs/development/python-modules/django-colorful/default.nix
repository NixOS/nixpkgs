{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-colorful";
  version = "1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/SRvL7KX7QdNxDSZZtM6HILQMIt/sNbvbi52uQzv/7c=";
  };

  build-system = [ setuptools ];

  buildInputs = [ django ];

  # Tests aren't run
  doCheck = false;

  pythonImportsCheck = [ "colorful" ];

  meta = with lib; {
    description = "Django extension that provides database and form color fields";
    homepage = "https://github.com/charettes/django-colorful";
    license = licenses.mit;
    maintainers = [ ];
  };
}
