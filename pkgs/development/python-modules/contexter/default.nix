{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "contexter";
  version = "0.1.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-xzCJCxqRUFFBSmNQ2Ooc3cp9Adj3Vrre2zC5vzBeoKg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "contexter" ];

  meta = {
    homepage = "https://bitbucket.org/defnull/contexter";
    license = lib.licenses.mit;
  };
})
