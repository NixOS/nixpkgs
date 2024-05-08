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
  version = "1.0.12";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-expr";
    rev = "refs/tags/v${version}";
    hash = "sha256-B/BkLOZhvUyjinaFKp0ecUfzvLb5S90q+YHmJwS6WSQ=";
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

  meta = with lib; {
    description = "";
    homepage = "https://github.com/dask/dask-expr";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
