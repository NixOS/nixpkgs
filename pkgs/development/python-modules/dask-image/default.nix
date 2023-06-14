{ lib
, stdenv
, buildPythonPackage
, dask
, fetchPypi
, numpy
, pims
, pytestCheckHook
, pythonOlder
, scikit-image
, scipy
}:

buildPythonPackage rec {
  pname = "dask-image";
  version = "2023.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M6qckhUG2DvBw2uY5pAJFyuvatC7owVlb6XWkkrzAys=";
  };

  propagatedBuildInputs = [
    dask
    numpy
    scipy
    pims
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scikit-image
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--flake8" ""
  '';

  pythonImportsCheck = [
    "dask_image"
  ];

  meta = with lib; {
    description = "Distributed image processing";
    homepage = "https://github.com/dask/dask-image";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ costrouc ];
  };
}
