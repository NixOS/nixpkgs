{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  args,
}:

buildPythonPackage (finalAttrs: {
  pname = "clint";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-BSJMMrEHVWPQsW0AFfqvnaQ6ohTkohQOUfCHieekxao=";
  };

  build-system = [ setuptools ];

  dependencies = [ args ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "clint" ];

  meta = {
    homepage = "https://github.com/kennethreitz/clint";
    description = "Python Command Line Interface Tools";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
})
