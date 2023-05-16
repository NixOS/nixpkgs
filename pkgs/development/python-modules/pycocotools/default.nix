{ lib
, buildPythonPackage
, fetchPypi
, cython
, matplotlib
}:

buildPythonPackage rec {
  pname = "pycocotools";
<<<<<<< HEAD
  version = "2.0.7";
=======
  version = "2.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-2ot4FRlu6/Ctq/Z/zEWRJsvGSYu8arH9FEw3FGXYaHk=";
=======
    hash = "sha256-f+CJsFzBjoBtzzvXZHCNhtq5IqEA83NOt3+3enCh0Yw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
