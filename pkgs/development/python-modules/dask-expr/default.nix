{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  versioneer,
  wheel,
  dask,
  pandas,
  pyarrow,
  distributed,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dask-expr";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-expr";
    rev = "refs/tags/v${version}";
    hash = "sha256-yVwaOOjxHVxAhFlEENnjpX8LbJs9MW0OOmwAH5RhPgE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "versioneer[toml]==0.28" "versioneer[toml]"
  '';

  nativeBuildInputs = [
    setuptools
    versioneer
    wheel
  ];

  propagatedBuildInputs = [
    dask
    pandas
    pyarrow
  ];

  pythonImportsCheck = [ "dask_expr" ];

  nativeCheckInputs = [
    distributed
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "";
    homepage = "https://github.com/dask/dask-expr";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
