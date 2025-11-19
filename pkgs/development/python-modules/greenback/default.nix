{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  asgiref,
  greenlet,
  importlib-metadata,
  setuptools,
  sniffio,
  outcome,
}:

buildPythonPackage rec {
  pname = "greenback";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oremanj";
    repo = "greenback";
    rev = "v${version}";
    hash = "sha256-u7kihdE5EH3Xbq4dQGY4ojiootjw3muYnoI7d2MrMkE=";
  };

  build-system = [
    setuptools
    importlib-metadata
  ];

  propagatedBuildInputs = [
    asgiref
    greenlet
    sniffio
    outcome
  ];

  pythonImportsCheck = [ "greenback" ];

  meta = with lib; {
    description = "Use anyio and asyncio from synchronous code";
    homepage = "https://github.com/oremanj/greenback";
    changelog = "https://github.com/oremanj/greenback/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
