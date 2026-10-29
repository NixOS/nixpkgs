{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  numpy,
  scipy,

  # optional-dependencies
  # doc
  h5netcdf,
  jupyter-sphinx,
  myst-nb,
  myst-parser,
  numpydoc,
  sphinx,
  sphinx-book-theme,
  sphinx-copybutton,
  sphinx-design,
  # numba
  numba,
  xarray-einstats,
  # test
  pytest,
  pytest-cov,

  # xarray
  arviz-base,
  xarray,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "arviz-stats";
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz-stats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-81duRavbPUKsqTWaeD0G6ieWLtyoZm7sRk06QkG5dKQ=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    numpy
    scipy
  ];

  optional-dependencies = {
    doc = [
      h5netcdf
      jupyter-sphinx
      myst-nb
      myst-parser
      numpydoc
      sphinx
      # sphinx-autosummary-accessors
      sphinx-book-theme
      sphinx-copybutton
      sphinx-design
    ];
    numba = [
      numba
      xarray-einstats
    ];
    test = [
      pytest
      pytest-cov
    ];
    test-xarray = [
      h5netcdf
      pytest
      pytest-cov
    ];
    xarray = [
      arviz-base
      xarray
      xarray-einstats
    ];
  };

  pythonImportsCheck = [ "arviz_stats" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Statistical computation and diagnostics for ArviZ";
    homepage = "https://github.com/arviz-devs/arviz-stats";
    changelog = "https://github.com/arviz-devs/arviz-stats/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
