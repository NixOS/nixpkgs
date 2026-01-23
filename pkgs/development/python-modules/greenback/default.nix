{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  asgiref,
  greenlet,
  importlib-metadata,
  outcome,
  setuptools,
  sniffio,
}:

buildPythonPackage rec {
  pname = "greenback";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oremanj";
    repo = "greenback";
    tag = "v${version}";
    hash = "sha256-u7kihdE5EH3Xbq4dQGY4ojiootjw3muYnoI7d2MrMkE=";
  };

  build-system = [
    importlib-metadata
    setuptools
  ];

  dependencies = [
    asgiref
    greenlet
    outcome
    sniffio
  ];

  pythonImportsCheck = [ "greenback" ];

  meta = {
    description = "Use anyio and asyncio from synchronous code";
    homepage = "https://github.com/oremanj/greenback";
    changelog = "https://github.com/oremanj/greenback/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taranarmo ];
  };
}
