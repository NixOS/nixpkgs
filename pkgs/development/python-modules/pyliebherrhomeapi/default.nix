{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytestCheckHook,
  pytest-asyncio,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyliebherrhomeapi";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mettolen";
    repo = "pyliebherrhomeapi";
    tag = finalAttrs.version;
    hash = "sha256-j6hdzgGMG3A2WS6nScUC65buRuhDjiNLz57Dv5hBAOs=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ];

  pythonImportsCheck = [ "pyliebherrhomeapi" ];

  meta = {
    description = "Python library for Liebherr Home API";
    homepage = "https://github.com/mettolen/pyliebherrhomeapi";
    changelog = "https://github.com/mettolen/pyliebherrhomeapi/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
