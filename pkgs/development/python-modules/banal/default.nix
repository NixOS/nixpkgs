{
  lib,
  fetchPypi,
  buildPythonPackage,
}:
buildPythonPackage rec {
  pname = "banal";
  version = "1.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L+AskwX1MWhEGUj0oD37+i6sxz2zDbSpMwkIPLDiUKU=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "banal" ];

  meta = with lib; {
    description = "Commons of banal micro-functions for Python";
    homepage = "https://github.com/pudo/banal";
    license = licenses.mit;
    maintainers = [ ];
  };
}
