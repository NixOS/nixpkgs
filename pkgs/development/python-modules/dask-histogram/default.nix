{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  boost-histogram,
  dask,
  hatchling,
  hatch-vcs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dask-histogram";
  version = "2024.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-histogram";
    rev = "refs/tags/${version}";
    hash = "sha256-RqZMAEGFqEXNmNv7SWCyQw9cI+I+Oa6s8O/7Jp+9id8=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    boost-histogram
    dask
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dask_histogram" ];

  meta = with lib; {
    description = "Histograms with task scheduling";
    homepage = "https://dask-histogram.readthedocs.io/";
    changelog = "https://github.com/dask-contrib/dask-histogram/releases/tag/${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
