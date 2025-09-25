{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  dash,
}:

buildPythonPackage rec {
  pname = "dash-ag-grid";
  version = "32.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "dash-ag-grid";
    tag = "v${version}";
    hash = "sha256-eLRIJkI2MWezCxbVrHafspecyKPXoYrlSGV1qXs3+4c=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dash
  ];

  # TODO not working: ModuleNotFoundError: No module named 'dash_ag_grid._imports_'
  #pythonImportsCheck = [ "dash_ag_grid" ];
  #nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "High-performance and highly customizable component that wraps AG Grid, designed for creating rich datagrids";
    homepage = "https://github.com/plotly/dash-ag-grid";
    changelog = "https://github.com/plotly/dash-ag-grid/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
