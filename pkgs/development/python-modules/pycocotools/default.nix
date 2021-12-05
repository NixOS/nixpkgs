{ lib, buildPythonPackage, fetchPypi, cython, matplotlib }:

buildPythonPackage rec {
  pname = "pycocotools";
  version = "2.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OCkCSTABN3EVZSGkuNtLOu9ZBVbPo6jdP6sCfTmyFeE=";
  };

  propagatedBuildInputs = [ cython matplotlib ];

  pythonImportsCheck = [ "pycocotools.coco" "pycocotools.cocoeval" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Official APIs for the MS-COCO dataset";
    homepage = "https://github.com/cocodataset/cocoapi/tree/master/PythonAPI";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa piegames ];
  };
}
