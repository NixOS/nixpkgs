{
  buildPythonPackage,
  fetchPypi,
  lib,
  playwright,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "playwright-stealth";
  version = "2.0.0";
  pyproject = true;

  # Changes haven't been pushed to Github or Gitlab; pypi is the only source
  src = fetchPypi {
    inherit version;
    pname = "playwright_stealth";
    hash = "sha256-T0TUFtQiZomJWk0c+0Do0TchbAyXEOqPhLri2/EYb8U=";
  };

  build-system = [ poetry-core ];

  dependencies = [ playwright ];

  # Tests require Chromium binary
  doCheck = false;

  pythonImportsCheck = [ "playwright_stealth" ];

  meta = {
    description = "Playwright stealth";
    homepage = "https://github.com/AtuboDad/playwright_stealth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
