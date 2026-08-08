{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "pytweening";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JDMYt3NmmAZsXzYuxcK2Q07PQpfDyOfKqKv+avTKxxs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pytweening" ];
  checkPhase = ''
    python -m unittest tests.basicTests
  '';

  meta = {
    description = "Set of tweening / easing functions implemented in Python";
    homepage = "https://github.com/asweigart/pytweening";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
