{ lib
, buildPythonPackage
, fetchFromGitHub
, boost-histogram
, dask
, hatchling
, hatch-vcs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dask-histogram";
  version = "2024.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-histogram";
    rev = "refs/tags/${version}";
    hash = "sha256-YU5i7mGOZxj/pvpkZLwohoSuHJgS3zkHYVuj1Vtyrj4=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    boost-histogram
    dask
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dask_histogram"
  ];

  meta = with lib; {
    description = "Histograms with task scheduling";
    homepage = "https://dask-histogram.readthedocs.io/";
    changelog = "https://github.com/dask-contrib/dask-histogram/releases/tag/${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
