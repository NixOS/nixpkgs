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

buildPythonPackage (finalAttrs: {
  pname = "dask-histogram";
  version = "2026.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-histogram";
    tag = finalAttrs.version;
    hash = "sha256-F48mFKP3XLYOn4TuiU3HGHTd089kPk0dF2XnJot5s+I=";
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
    changelog = "https://github.com/dask-contrib/dask-histogram/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
