{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  yarn-berry_3,

  # build-system
  hatchling,
  hatch-jupyter-builder,
  jupyterlab,

  # dependencies
  bqplot,
  ipywidgets,
  pandas,
  py2vega,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ipydatagrid";
  version = "1.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyter-widgets";
    repo = "ipydatagrid";
    tag = finalAttrs.version;
    hash = "sha256-6jaIYgLbNXIYzM+mZIVMZ1CXOpcbVK5k9nzGjq5UdLI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml package.json \
      --replace-fail 'jlpm' 'yarn'
  '';

  yarnOfflineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
    hash = "sha256-5KZl9mK6xNvy2XdWieH20hEZJ+h/KzvjOfpo78FlWpg=";
  };

  nativeBuildInputs = [
    yarn-berry_3
    yarn-berry_3.yarnBerryConfigHook
  ];

  build-system = [
    hatchling
    hatch-jupyter-builder
    jupyterlab
  ];

  dependencies = [
    bqplot
    ipywidgets
    pandas
    py2vega
  ];

  pythonImportsCheck = [ "ipydatagrid" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Expects the pandas 2 table schema; pandas 3 tags string columns with `extDtype: "str"`
    "test_data_object_generation"
  ];

  meta = {
    description = "Fast Datagrid widget for the Jupyter Notebook and JupyterLab";
    homepage = "https://github.com/jupyter-widgets/ipydatagrid";
    changelog = "https://github.com/jupyter-widgets/ipydatagrid/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ flokli ];
  };
})
