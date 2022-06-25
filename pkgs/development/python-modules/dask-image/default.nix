{ lib
, stdenv
, buildPythonPackage
, dask
, fetchPypi
, numpy
, pims
, pytestCheckHook
, pythonOlder
, scikitimage
, scipy
}:

buildPythonPackage rec {
  pname = "dask-image";
  version = "2021.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nb5JYmvQHD44khKBJqJ9XuMmahmKjjx+MNWervcS/Pk=";
  };

  propagatedBuildInputs = [
    dask
    numpy
    scipy
    pims
  ];

  checkInputs = [
    pytestCheckHook
    scikitimage
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--flake8" ""
  '';

  pythonImportsCheck = [
    "dask_image"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Distributed image processing";
    homepage = "https://github.com/dask/dask-image";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ costrouc ];
  };
}
