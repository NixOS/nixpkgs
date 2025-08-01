{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "first";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/yhbCMVfjJfOTqcBJ0OvJJXJ8SkXhfFjcivTb2r2078=";
  };

  doCheck = false; # no tests

  pythonImportsCheck = [ "first" ];

  meta = with lib; {
    description = "Function you always missed in Python";
    homepage = "https://github.com/hynek/first/";
    changelog = "https://github.com/hynek/first/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
