{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-colorful";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9mg3SyD22BNaLeRTTKDW2L2z1GI124ZkqNhTLlrw9m4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ django ];

  # Tests aren't run
  doCheck = false;

  pythonImportsCheck = [ "colorful" ];

  meta = {
    description = "Django extension that provides database and form color fields";
    homepage = "https://github.com/charettes/django-colorful";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
