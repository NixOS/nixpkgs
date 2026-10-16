{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  dash,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dash-ag-grid";
  version = "35.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "dash_ag_grid";
    inherit (finalAttrs) version;
    hash = "sha256-UH9dzPcjW/G5ryxZ1M0PEiBdsDw0ifYFlI8TxyvOzk8=";
  };

  build-system = [ setuptools ];

  dependencies = [ dash ];

  pythonImportsCheck = [ "dash_ag_grid" ];

  # TODO
  # ImportError: attempted relative import with no known parent package
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "High-performance and highly customizable component that wraps AG Grid, designed for creating rich datagrids";
    homepage = "https://github.com/plotly/dash-ag-grid";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
