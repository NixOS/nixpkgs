{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  playwright,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "playwright-stealth";
  version = "1.0.6-unstable-2023-09-11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "AtuboDad";
    repo = "playwright_stealth";
    # https://github.com/AtuboDad/playwright_stealth/issues/25
    rev = "43f7433057906945b1648179304d7dbd8eb10874";
    hash = "sha256-ZWmuVwjEgrPmfxjvws3TdocW6tyNH++fyRfKQ0oJ6bo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ playwright ];

  # Tests require Chromium binary
  doCheck = false;

  pythonImportsCheck = [ "playwright_stealth" ];

  meta = with lib; {
    description = "Playwright stealth";
    homepage = "https://github.com/AtuboDad/playwright_stealth";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
