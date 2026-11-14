{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  uv-build,
  anyio,
  typing-extensions,
  pydantic,
  pytestCheckHook,
  dirty-equals,
}:
buildPythonPackage (finalAttrs: {
  pname = "fast-depends";
  version = "3.0.7";
  pyproject = true;
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "Lancetnik";
    repo = "FastDepends";
    tag = finalAttrs.version;
    hash = "sha256-AjQS7aqz0/CojwHlyD6ZU575SdhxGcaA6unE62gzxnE=";
  };

  dependencies = [
    anyio
    typing-extensions
  ];

  build-system = [ uv-build ];

  optional-dependencies = {
    pydantic = [ pydantic ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    dirty-equals
  ]
  ++ finalAttrs.passthru.optional-dependencies.pydantic;

  pythonImportsCheck = [ "fast_depends" ];

  meta = {
    description = "Dependency injection system extracted from FastAPI, with async and sync support";
    homepage = "https://github.com/Lancetnik/FastDepends";
    changelog = "https://github.com/Lancetnik/FastDepends/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
