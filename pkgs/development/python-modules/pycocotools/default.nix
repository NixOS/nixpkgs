{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "pycocotools";
  version = "2.0.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ekdgnN78leXhUTE8fZOmHPBuFdQse6mbYB47wPns4uE=";
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
