{
  lib,
  buildPythonPackage,
  fetchPypi,
  playwright,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "playwright-stealth";
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "playwright_stealth";
    inherit (finalAttrs) version;
    hash = "sha256-rFflGHMZDaXmU+A3IOlIyPCj0GsJjx1WdjED0j7kgUM=";
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
