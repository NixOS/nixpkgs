{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  numpy,
  platformdirs,
  pytestCheckHook,
  typing-extensions,
  siphash24,
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2025.2.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p/U1BkTUbZjunH5ntLQWkzCKoPXpsYjY8GlLJ9yU46I=";
  };

  build-system = [ hatchling ];

  dependencies = [
    platformdirs
    siphash24
    typing-extensions
  ];

  optional-dependencies = {
    numpy = [ numpy ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytools"
    "pytools.batchjob"
    "pytools.lex"
  ];

  meta = {
    description = "Miscellaneous Python lifesavers";
    homepage = "https://github.com/inducer/pytools/";
    changelog = "https://github.com/inducer/pytools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
