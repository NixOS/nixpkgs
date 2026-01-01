{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "pycocotools";
<<<<<<< HEAD
  version = "2.0.11";
=======
  version = "2.0.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-NCVNdtqFV2/K9cHzqpquFrjLFUGDNLpCg7gAeWvRmT0=";
=======
    hash = "sha256-ekdgnN78leXhUTE8fZOmHPBuFdQse6mbYB47wPns4uE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Official APIs for the MS-COCO dataset";
    homepage = "https://github.com/cocodataset/cocoapi/tree/master/PythonAPI";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ piegames ];
=======
  meta = with lib; {
    description = "Official APIs for the MS-COCO dataset";
    homepage = "https://github.com/cocodataset/cocoapi/tree/master/PythonAPI";
    license = licenses.bsd2;
    maintainers = with maintainers; [ piegames ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
