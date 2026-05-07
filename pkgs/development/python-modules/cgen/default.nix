{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytools,
  numpy,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cgen";
  version = "2025.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-efAeAQ1JwT5YtMqPLUmWprcXiWj18tkGJiczSArnotQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pytools
    numpy
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "C/C++ source generation from an AST";
    homepage = "https://github.com/inducer/cgen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
