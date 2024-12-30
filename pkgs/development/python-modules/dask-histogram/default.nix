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
  version = "2024.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-histogram";
    tag = version;
    hash = "sha256-chznfEsMFuIioIlTz6uNpVAkjMMoMXjS62R4luKxVZQ=";
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
    changelog = "https://github.com/dask-contrib/dask-histogram/releases/tag/${src.tag}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
