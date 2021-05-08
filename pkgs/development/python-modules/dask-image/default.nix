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
  version = "0.5.0";
  pname = "dask-image";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bf7ea8dcd9d795505b498bd632394720c048f50761e23c574d9a6bacfb27cbb";
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
