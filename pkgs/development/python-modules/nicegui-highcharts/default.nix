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
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zauberzeug";
    repo = "nicegui-highcharts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wzpgTDXTI3INQrkio6lgge07r+76wUKd193mt5ugc6g=";
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
