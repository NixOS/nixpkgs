{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  dask,
  numpy,
  scipy,
  pandas,
  pims,
  pytestCheckHook,
  scikit-image,
}:

buildPythonPackage rec {
  pname = "dask-image";
  version = "2024.5.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-image";
    rev = "refs/tags/v${version}";
    hash = "sha256-kXCAqJ2Zgo/2Khvo2YcK+n4oGM219GyQ2Hsq9re1Lac=";
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

  pythonImportsCheck = [ "dask_image" ];

  meta = {
    description = "Distributed image processing";
    homepage = "https://github.com/dask/dask-image";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
