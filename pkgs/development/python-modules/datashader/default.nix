{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  colorcet,
  multipledispatch,
  numba,
  numpy,
  pandas,
  param,
  pyct,
  requests,
  scipy,
  toolz,
  packaging,
  xarray,
  pytestCheckHook,
  pytest-xdist,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "datashader";
  version = "0.18.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = "datashader";
    tag = "v${version}";
    hash = "sha256-ad1L0QyqLtMafFr+ZK1dItlFuPQZ0Caa96RgkLsqNkA=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    colorcet
    multipledispatch
    numba
    numpy
    pandas
    param
    pyct
    requests
    scipy
    toolz
    packaging
    xarray
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "datashader" ];

  meta = {
    description = "Data visualization toolchain based on aggregating into a grid";
    mainProgram = "datashader";
    homepage = "https://datashader.org";
    changelog = "https://github.com/holoviz/datashader/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
