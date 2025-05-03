{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  version = "0.18.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = "datashader";
    tag = "v${version}";
    hash = "sha256-HduEO2XDH20tovtlpg5DbF96G5Lpbo+XVmQKnWvfyL8=";
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
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
