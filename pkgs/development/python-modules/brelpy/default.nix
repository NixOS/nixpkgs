{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pycryptodome,
}:

buildPythonPackage (finalAttrs: {
  pname = "brelpy";
  version = "0.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-MYWSKYd7emHZfY+W/UweQtTg62GSUMybpecL9BR8dhg=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycryptodome ];

  # Source not tagged and PyPI releases don't contain tests
  doCheck = false;

  pythonImportsCheck = [ "brelpy" ];

  meta = {
    description = "Python to communicate with the Brel hubs";
    homepage = "https://gitlab.com/rogiervandergeer/brelpy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
