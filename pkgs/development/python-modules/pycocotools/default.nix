{ buildPythonPackage
, cython
, fetchPypi
, lib
, matplotlib
, numpy
, pytest
}:
buildPythonPackage rec {
  pname = "pycocotools";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version ;
    sha256 = "cbb8c2fbab80450a67ee9879c63b0bc8a69e58dd9a0153d55de404c0d383a94b";
  };

  nativeBuildInputs = [
    cython
  ];

  checkInputs = [
    numpy
    pytest
    matplotlib
  ];

  # No tests available on pypi.org
  doCheck = false;

  pythonImportsCheck = [ "pycocotools" ];

  meta = with lib; {
    description = "COCO API - http://cocodataset.org/";
    homepage = "https://github.com/cocodataset/cocoapi";
    license = licenses.bsd0;
    maintainers = with maintainers; [ rakesh4g ];
  };

}
