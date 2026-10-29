{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "nclib";
  version = "1.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-IVnWqHpoYF5bzek0aWWiKtlWiUaX1jcZq+DfLK0FGoI=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "nclib" ];

  meta = {
    description = "Python module that provides netcat features";
    homepage = "https://nclib.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "serve-stdio";
  };
})
