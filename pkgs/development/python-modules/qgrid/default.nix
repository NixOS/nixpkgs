{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  ipywidgets,
  looseversion,
  notebook,
  pandas,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "qgrid";
  version = "1.3.1";
  pyproject = true;
  __structuredAttrs = true;

  # Using the Pypi archive to avoid building the node modules from source
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/or1tQgzCE3AtqJlzRrHuDfAPA+FIRUBY1YNzneNcRw=";
  };

  postPatch = ''
    substituteInPlace qgrid/grid.py \
      --replace-fail \
        "from distutils.version import LooseVersion" \
        "from looseversion import LooseVersion"
  ''
  # Fixes compatibility of qgrid with ipywidgets >= 8.0.0
  # See https://github.com/quantopian/qgrid/pull/331
  + ''
    substituteInPlace qgrid/grid.py \
      --replace-fail \
        "@widgets.register()" \
        "@widgets.register"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    ipywidgets
    looseversion
    notebook
    pandas
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Those tests are also failing upstream
  disabledTests = [
    "test_edit_date"
    "test_edit_multi_index_df"
    "test_multi_index"
    "test_period_object_column"
    # probably incompatible with pandas>=2.1
    "test_add_row_button"
  ];

  pythonImportsCheck = [ "qgrid" ];

  meta = {
    description = "Interactive grid for sorting, filtering, and editing DataFrames in Jupyter notebooks";
    homepage = "https://github.com/quantopian/qgrid";
    changelog = "https://github.com/quantopian/qgrid/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
