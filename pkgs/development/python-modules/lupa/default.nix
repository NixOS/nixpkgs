{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "lupa";
  version = "2.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2AImQbnsjs8sXsvp9H5acOC4fEta6SG5LLAqY44KzQg=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "lupa" ];

  meta = {
    description = "Lua in Python";
    homepage = "https://github.com/scoder/lupa";
    changelog = "https://github.com/scoder/lupa/blob/lupa-${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
