{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dash,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dash-ag-grid";
  version = "35.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "dash-ag-grid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vSvWcqzrM92m8Yvv/Ehmzh5zkFUX2dR+L0ZE5CM/WBw=";
  };

  build-system = [ setuptools ];

  dependencies = [ dash ];

  # TODO
  # ModuleNotFoundError: No module named 'dash_ag_grid._imports_'
  pythonImportsCheck = [ "dash_ag_grid" ];

  meta = {
    description = "High-performance and highly customizable component that wraps AG Grid, designed for creating rich datagrids";
    homepage = "https://github.com/plotly/dash-ag-grid";
    changelog = "https://github.com/plotly/dash-ag-grid/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
