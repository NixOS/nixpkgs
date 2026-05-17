{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "minidump";
  version = "0.0.24";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-964JuUTzsXzPXOzGb5/1p6RbBTR0oTrrAS9MkgRHBDc=";
  };

  build-system = [ setuptools ];

  # Upstream doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "minidump" ];

  meta = {
    description = "Python library to parse and read Microsoft minidump file format";
    homepage = "https://github.com/skelsec/minidump";
    changelog = "https://github.com/skelsec/minidump/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "minidump";
  };
}
