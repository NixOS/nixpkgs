{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  numpy,
  typing-extensions,
  xarray,

  # optional-dependencies
  black,
  build,
  isort,
  mypy,
  pre-commit,
  cloudpickle,
  h5netcdf,
  jupyter-sphinx,
  myst-nb,
  myst-parser,
  numpydoc,
  sphinx,
  sphinx-book-theme,
  sphinx-copybutton,
  sphinx-design,
  netcdf4,
  pytest,
  pytest-cov,
  scipy,
  zarr,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "arviz-base";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz-base";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g2DmhYqO9dgvDZwAXXSDFn5wHU0BvxXNgOzk6mmEmsw=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    numpy
    typing-extensions
    xarray
  ];

  optional-dependencies = {
    check = [
      black
      build
      # docstub
      isort
      mypy
      pre-commit
    ];
    ci = [
      cloudpickle
      pre-commit
    ];
    doc = [
      h5netcdf
      jupyter-sphinx
      myst-nb
      myst-parser
      numpydoc
      sphinx
      sphinx-book-theme
      sphinx-copybutton
      sphinx-design
    ];
    h5netcdf = [
      h5netcdf
    ];
    netcdf4 = [
      netcdf4
    ];
    test = [
      pytest
      pytest-cov
      scipy
      xarray
    ];
    zarr = [
      zarr
    ];
  };

  pythonImportsCheck = [ "arviz_base" ];

  nativeCheckInputs = [
    h5netcdf
    netcdf4
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Base ArviZ features and converters";
    homepage = "https://github.com/arviz-devs/arviz-base";
    changelog = "https://github.com/arviz-devs/arviz-base/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
