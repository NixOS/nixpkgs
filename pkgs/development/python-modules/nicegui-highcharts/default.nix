{
  lib,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  nicegui,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "nicegui-highcharts";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zauberzeug";
    repo = "nicegui-highcharts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ihPWk/FnOAJzO3kWM4dV0ZbbDgBfGb4o+6zkVEb6wrA=";
  };

  pythonRelaxDeps = [ "docutils" ];

  build-system = [ hatchling ];

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
