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

  meta = with lib; {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
