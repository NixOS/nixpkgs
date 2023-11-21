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
  version = "2023.10.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-histogram";
    rev = "refs/tags/${version}";
    hash = "sha256-ugAqNdvCROCCXURwsGLpnl/lBEAremvTI7MVa/TWt6c=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    boost-histogram
    dask
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dask_histogram"
  ];

  meta = with lib; {
    description = "Histograms with task scheduling";
    homepage = "https://dask-histogram.readthedocs.io/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
