{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  boost-histogram,
  dask,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dask-histogram";
  version = "2024.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-histogram";
    rev = "refs/tags/${version}";
    hash = "sha256-k+hD5y9K6Jsm++H+IAWJ/Z3wlCN4fV8RIcyAnvOvem0=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    boost-histogram
    dask
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dask_histogram" ];

  meta = {
    description = "Histograms with task scheduling";
    homepage = "https://dask-histogram.readthedocs.io/";
    changelog = "https://github.com/dask-contrib/dask-histogram/releases/tag/${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
