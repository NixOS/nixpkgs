{
  lib,
  buildPythonPackage,
  fetchPypi,
  playwright,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "playwright-stealth";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "playwright_stealth";
    inherit version;
    hash = "sha256-T0TUFtQiZomJWk0c+0Do0TchbAyXEOqPhLri2/EYb8U=";
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
}
