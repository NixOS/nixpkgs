{
  lib,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  nicegui,
  hatchling,
  pyprojectVersionPatchHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nicegui-highcharts";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zauberzeug";
    repo = "nicegui-highcharts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QvhvQU/na33ZYQbAuCJvsVDDRkTy+Z4STJg9vlZrQbY=";
  };

  pythonRelaxDeps = [ "docutils" ];

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    docutils
    nicegui
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "nicegui_highcharts" ];

  meta = {
    description = "NiceGUI with support for Highcharts";
    homepage = "https://github.com/zauberzeug/nicegui-highcharts";
    changelog = "https://github.com/zauberzeug/nicegui-highcharts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
