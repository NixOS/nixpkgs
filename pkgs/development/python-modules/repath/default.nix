{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "repath";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gpITm6xqDkP9nXBgXU6NrrJdRmcuSE7TGiTHzgrvD7c=";
  };

  propagatedBuildInputs = [ six ];

  pythonImportsCheck = [ "repath" ];

  meta = {
    description = "Port of the node module path-to-regexp to Python";
    homepage = "https://github.com/nickcoutsos/python-repath";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.heyimnova ];
  };
}
