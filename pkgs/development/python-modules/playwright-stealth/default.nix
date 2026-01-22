{
  lib,
  buildPythonPackage,
  fetchPypi,
  playwright,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "playwright-stealth";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "playwright_stealth";
    inherit (finalAttrs) version;
    hash = "sha256-o29zXWFGnBK9oXm1jV/EIou+5hyc9bE0OxSXpf1R7Bo=";
  };

  build-system = [ poetry-core ];

  dependencies = [ playwright ];

  pythonImportsCheck = [ "playwright_stealth" ];

  meta = {
    description = "Make your playwright instance stealthy";
    homepage = "https://github.com/AtuboDad/playwright_stealth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
