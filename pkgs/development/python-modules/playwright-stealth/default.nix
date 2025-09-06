{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  playwright,
  setuptools,
}:

buildPythonPackage {
  pname = "playwright-stealth";
  version = "1.0.6-unstable-2023-09-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AtuboDad";
    repo = "playwright_stealth";
    # https://github.com/AtuboDad/playwright_stealth/issues/25
    rev = "43f7433057906945b1648179304d7dbd8eb10874";
    hash = "sha256-ZWmuVwjEgrPmfxjvws3TdocW6tyNH++fyRfKQ0oJ6bo=";
  };

  build-system = [ setuptools ];

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
