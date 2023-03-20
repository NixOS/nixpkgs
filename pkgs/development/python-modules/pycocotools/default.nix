{ lib
, buildPythonPackage
, fetchPypi
, cython
, matplotlib
}:

buildPythonPackage rec {
  pname = "pycocotools";
  version = "2.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f+CJsFzBjoBtzzvXZHCNhtq5IqEA83NOt3+3enCh0Yw=";
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
