{ lib
, buildPythonPackage
, fetchPypi
, dask
, scipy
, pims
, scikitimage
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.6.0";
  pname = "dask-image";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zzxrvbm52xn7azkn74pjinlk0jkpdcyl3r5vxxy5lmjnmzlrrpy";
  };

  propagatedBuildInputs = [ dask scipy pims ];

  prePatch = ''
    substituteInPlace setup.cfg --replace "--flake8" ""
  '';

  checkInputs = [
    pytestCheckHook
    scikitimage
  ];

  pythonImportsCheck = [ "dask_image" ];

  meta = with lib; {
    homepage = "https://github.com/dask/dask-image";
    description = "Distributed image processing";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
