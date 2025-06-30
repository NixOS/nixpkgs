{
  buildPythonPackage,
  fetchFromGitHub,
  idasen,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "idasen-ha";
  version = "2.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "idasen-ha";
    tag = version;
    hash = "sha256-Z4MfJGL2uDqY1ddoV2fB+Ty/dKFhCUY8qBfP/i/naJs=";
  };

  build-system = [ setuptools ];

  dependencies = [ idasen ];

  pythonImportsCheck = [ "idasen_ha" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/abmantis/idasen-ha/releases/tag/${version}";
    description = "Home Assistant helper lib for the IKEA Idasen Desk integration";
    homepage = "https://github.com/abmantis/idasen-ha";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
