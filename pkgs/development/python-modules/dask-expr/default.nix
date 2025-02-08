{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  versioneer,

  # dependencies
  dask,
  pandas,
  pyarrow,

  # checks
  jinja2,
  pytestCheckHook,
  xarray,
}:

buildPythonPackage rec {
  pname = "dask-expr";
  version = "1.1.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-expr";
    tag = "v${version}";
    hash = "sha256-t1vPlTxV5JYArg/a7CzPP13NHbstEoCgHRmd8Y9mDfA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "versioneer[toml]==0.28" "versioneer[toml]"
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    dask
    pandas
    pyarrow
  ];

  pythonImportsCheck = [ "dask_expr" ];

  nativeCheckInputs = [
    jinja2
    pytestCheckHook
    xarray
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Rewrite of Dask DataFrame that includes query optimization and generally improved organization";
    homepage = "https://github.com/dask/dask-expr";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
