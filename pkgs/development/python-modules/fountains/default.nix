{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bitlist,
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kRu+jCKRfkH0URNuYvTF3TF1WslyfeE2EHE1VLCMyys=";
  };

  build-system = [ setuptools ];

  dependencies = [ bitlist ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "fountains" ];

  meta = {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
