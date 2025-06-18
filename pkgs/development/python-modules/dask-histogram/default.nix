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
  dask-awkward,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dask-histogram";
  version = "2025.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-histogram";
    tag = version;
    hash = "sha256-5Ec/qzVc/7LDG6SJym1e76BbxmbVjKKQHckwtTs1+6M=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    boost-histogram
    dask
    dask-awkward
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
