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
  version = "2022.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8SPf0Wp9FcdmYqasFHeFCe1e7ZtJT0Mi5ZRemxWSNUc=";
  };

  propagatedBuildInputs = [
    dask
    numpy
    scipy
    pims
  ];

  nativeCheckInputs = [
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
