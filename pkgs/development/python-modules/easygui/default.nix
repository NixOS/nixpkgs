{
  lib,
  fetchPypi,
  buildPythonPackage,
  tkinter,
}:

buildPythonPackage rec {
  pname = "easygui";
  version = "0.98.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1lP/ee4fQvY7WgkPL5jOAjNdhq2JY7POJmGAXK/pmgQ=";
  };

  propagatedBuildInputs = [ tkinter ];

  doCheck = false; # No tests available

  pythonImportsCheck = [ "easygui" ];

  meta = with lib; {
    description = "Very simple, very easy GUI programming in Python";
    homepage = "https://github.com/robertlugg/easygui";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
