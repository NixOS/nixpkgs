{
  lib,
  buildPythonPackage,
  fetchPypi,
  bokeh,
  packaging,
  panel,
  param,
}:
let
  version = "0.16.6";
in buildPythonPackage {
  pname = "panel-material-ui";
  inherit version;
  format = "wheel";

  src = fetchPypi {
    pname = "panel_material_ui";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-doTIK7iayFNrZy2h+eNQNpMcR+9TXFDwc2T6RBJpU3E=";
  };

  dependencies = [
    bokeh
    packaging
    panel
    param
  ];

  pythonImportsCheck = [ "panel_material_ui" ];

  meta = {
    description = "An extension to bring MaterialUI components to Panel";
    homepage = "https://github.com/panel-extensions/panel-material-ui";
    changelog = "https://github.com/panel-extensions/panel-material-ui/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ charmoniumQ ];
  };
}
