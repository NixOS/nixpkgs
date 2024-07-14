{
  lib,
  buildPythonPackage,
  fetchPypi,
  opencv4,
}:

buildPythonPackage rec {
  version = "0.5.4";
  format = "setuptools";
  pname = "imutils";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A4J6n8qLXFQDBcCESmJZHPNaDK7BmcsPLwpKD7FdjyQ=";
  };

  propagatedBuildInputs = [ opencv4 ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "imutils"
    "imutils.video"
    "imutils.io"
    "imutils.feature"
    "imutils.face_utils"
  ];

  meta = with lib; {
    homepage = "https://github.com/jrosebr1/imutils";
    description = "Series of convenience functions to make basic image processing functions";
    mainProgram = "range-detector";
    license = licenses.mit;
    maintainers = [ ];
  };
}
