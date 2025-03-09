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
  distributed,
  pytestCheckHook,
  xarray
}:

buildPythonPackage rec {
  pname = "dask-expr";
  version = "1.1.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-expr";
    rev = "refs/tags/v${version}";
    hash = "sha256-Uze6YxNEuy5izx4tqORgCjD+ItH9Hf1vrbXU7fn4o1M=";
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
    distributed
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
