{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "asdf-standard";
  version = "1.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "asdf_standard";
    inherit version;
    hash = "sha256-WULK99FD859y9jRIQ3PH9AzkhXHR2zwnHhOFjjP+WWY=";
  };

  build-system = [ setuptools-scm ];

  # Circular dependency on asdf
  doCheck = false;

  pythonImportsCheck = [ "asdf_standard" ];

  meta = {
    description = "Standards document describing ASDF";
    homepage = "https://github.com/asdf-format/asdf-standard";
    changelog = "https://github.com/asdf-format/asdf-standard/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
