{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ppdeep";
  version = "20250625";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t9pQ5U7ZvXkyY4K28vUfNxgW8ElaUjPe4jqUafh6Kng=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ppdeep" ];

  meta = {
    description = "Python library for computing fuzzy hashes (ssdeep)";
    homepage = "https://github.com/elceef/ppdeep";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
