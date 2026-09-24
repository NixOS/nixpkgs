{
  lib,
  buildPythonPackage,
  fetchPypi,
  typing-extensions,
  poetry-core,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "expression";
  version = "5.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-RU9v4Tg0cZSkPH+HjZWO/puEucx3DkYgEMelLhgFgGU=";
  };

  build-system = [ poetry-core ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    pydantic = [ pydantic ];
  };

  pythonImportsCheck = [
    "expression"
  ];

  meta = {
    description = "Functional programming for Python";
    homepage = "https://github.com/dbrattli/Expression";
    changelog = "https://github.com/dbrattli/Expression/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
