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
  version = "2023.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XpqJhbBSehtZQsan50Tg5X0mTiIscFjwW664HDdNBLY=";
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
    maintainers = with maintainers; [ ];
  };
}
