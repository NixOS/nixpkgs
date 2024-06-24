{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "pytweening";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JDMYt3NmmAZsXzYuxcK2Q07PQpfDyOfKqKv+avTKxxs=";
  };

  pythonImportsCheck = [ "pytweening" ];
  checkPhase = ''
    python -m unittest tests.basicTests
  '';

  meta = with lib; {
    description = "Set of tweening / easing functions implemented in Python";
    homepage = "https://github.com/asweigart/pytweening";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lucasew ];
  };
}
