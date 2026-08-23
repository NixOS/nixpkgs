{
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  idasen,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  pyprojectVersionPatchHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "idasen-ha";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "idasen-ha";
    tag = version;
    hash = "sha256-Je7zwPkwAJ1gOWV8wL0utbqC+RkLB10B+IZUFoUFeY4=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    bleak-retry-connector
    idasen
  ];

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
