{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  bokeh,
  packaging,
}:

buildPythonPackage (finalAttrs: {
  pname = "panel-material-ui";
  version = "0.16.7";
  pyproject = true;

  src = fetchPypi {
    pname = "panel_material_ui";
    inherit (finalAttrs) version;
    hash = "sha256-LrP7If6+EXP3K9fbU32IiikUBvpZ558zUZNy7EFdqZU=";
  };

  # The sdist already ships the compiled JS bundle; compiling it would
  # require node and panel, which depends on this package
  env.PANEL_MATERIAL_UI_SKIP_COMPILE = "1";

  postPatch = ''
    # panel is only needed at build time to compile the JS bundle
    substituteInPlace pyproject.toml \
      --replace-fail '"panel >=1.9.0", ' ""
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  # Circular dependency: panel-material-ui is only ever imported through
  # panel, which depends on it
  pythonRemoveDeps = [ "panel" ];

  dependencies = [
    bokeh
    packaging
  ];

  # panel_material_ui imports panel at runtime, which would reintroduce
  # the circular dependency
  doCheck = false;

  meta = {
    description = "MaterialUI components for Panel";
    homepage = "https://github.com/panel-extensions/panel-material-ui";
    changelog = "https://github.com/panel-extensions/panel-material-ui/blob/main/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
