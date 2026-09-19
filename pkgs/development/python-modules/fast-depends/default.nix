{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  uv-build,
  anyio,
  typing-extensions,
}:
buildPythonPackage (finalAttrs: {
  pname = "fast-depends";
  version = "3.0.7";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "Lancetnik";
    repo = "FastDepends";
    tag = "${finalAttrs.version}";
    hash = "sha256-AjQS7aqz0/CojwHlyD6ZU575SdhxGcaA6unE62gzxnE=";
  };
  dependencies = [
    anyio
    typing-extensions
  ];
  build-system = [ uv-build ];
  meta = {
    description = "Dependency injection system extracted from FastAPI, with async and sync support";
    homepage = "https://github.com/Lancetnik/FastDepends";
    changelog = "https://github.com/Lancetnik/FastDepends/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
