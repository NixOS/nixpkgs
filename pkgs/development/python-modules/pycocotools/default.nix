{ lib
, buildPythonPackage
, fetchPypi
, cython
, matplotlib
}:

buildPythonPackage rec {
  pname = "pycocotools";
  version = "2.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2ot4FRlu6/Ctq/Z/zEWRJsvGSYu8arH9FEw3FGXYaHk=";
  };

  propagatedBuildInputs = [
    cython
    matplotlib
  ];

  pythonImportsCheck = [
    "pycocotools.coco"
    "pycocotools.cocoeval"
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Official APIs for the MS-COCO dataset";
    homepage = "https://github.com/cocodataset/cocoapi/tree/master/PythonAPI";
    license = licenses.bsd2;
    maintainers = with maintainers; [ piegames ];
  };
}
