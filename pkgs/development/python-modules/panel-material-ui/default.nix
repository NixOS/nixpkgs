{
  lib,
  buildPythonPackage,
  fetchPypi,
  bokeh,
  packaging,
  panel,
  param,
}:

buildPythonPackage (finalAttrs: {
  pname = "panel-material-ui";
  version = "0.16.6";
  format = "wheel";

  src = fetchPypi {
    pname = "panel_material_ui";
    inherit (finalAttrs) version;
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

  # See note on cycle in ../panel/default.nix
  pythonImportsCheck = [ "panel_material_ui" ];

  meta = {
    description = "An extension to bring MaterialUI components to Panel";
    homepage = "https://github.com/panel-extensions/panel-material-ui";
    changelog = "https://github.com/panel-extensions/panel-material-ui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      locnide
      charmoniumQ
    ];
  };
})
