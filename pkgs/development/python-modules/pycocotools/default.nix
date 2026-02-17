{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "pycocotools";
  version = "2.0.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NCVNdtqFV2/K9cHzqpquFrjLFUGDNLpCg7gAeWvRmT0=";
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

  meta = {
    description = "Official APIs for the MS-COCO dataset";
    homepage = "https://github.com/cocodataset/cocoapi/tree/master/PythonAPI";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ piegames ];
  };
}
