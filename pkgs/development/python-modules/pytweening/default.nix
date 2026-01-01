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

<<<<<<< HEAD
  meta = {
    description = "Set of tweening / easing functions implemented in Python";
    homepage = "https://github.com/asweigart/pytweening";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lucasew ];
=======
  meta = with lib; {
    description = "Set of tweening / easing functions implemented in Python";
    homepage = "https://github.com/asweigart/pytweening";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lucasew ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
