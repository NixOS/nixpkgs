{
  lib,
  buildPythonPackage,
  fetchPypi,
  playwright,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "playwright-stealth";
  version = "2.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "playwright_stealth";
    inherit (finalAttrs) version;
    hash = "sha256-HY5Ij73Y8ZDxJp6oz11X0U3zqfGvEAHEHuNYiyqsMTM=";
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
