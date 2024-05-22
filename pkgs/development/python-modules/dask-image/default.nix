{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, dask
, numpy
, scipy
, pandas
, pims
, pytestCheckHook
, scikit-image
}:

buildPythonPackage rec {
  pname = "dask-image";
  version = "2024.5.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-image";
    rev = "refs/tags/v${version}";
    hash = "sha256-smoiGSY7ou4zPRf0+6bRoViZDwNFBIwq+Mk8Tc9vniM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dask
    numpy
    scipy
    pandas
    pims
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scikit-image
  ];

  pythonImportsCheck = [
    "dask_image"
  ];

  meta = {
    description = "Distributed image processing";
    homepage = "https://github.com/dask/dask-image";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
