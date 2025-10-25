{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  dash,
}:

buildPythonPackage rec {
  pname = "dash-ag-grid";
  version = "32.3.2";
  pyproject = true;

  src = fetchPypi {
    pname = "dash_ag_grid";
    inherit version;
    hash = "sha256-wxN7Zsc7Legto3nCqiOPT76bVVkTwzYeEdkwlqDmH1A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dash
  ];

  pythonImportsCheck = [ "dash_ag_grid" ];
  #nativeCheckInputs = [ pytestCheckHook ];  # TODO

  meta = {
    description = "High-performance and highly customizable component that wraps AG Grid, designed for creating rich datagrids";
    homepage = "https://github.com/plotly/dash-ag-grid";
    changelog = "https://github.com/plotly/dash-ag-grid/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
