{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ppdeep";
  version = "20250622";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QKEcNp8B+K5eE+2DOvfkMMIl9Y+gS3dlGqSWgeQe1Gw=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ppdeep" ];

  meta = with lib; {
    description = "Python library for computing fuzzy hashes (ssdeep)";
    homepage = "https://github.com/elceef/ppdeep";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
