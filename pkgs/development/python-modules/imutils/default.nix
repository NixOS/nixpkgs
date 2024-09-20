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
    sha256 = "03827a9fca8b5c540305c0844a62591cf35a0caec199cb0f2f0a4a0fb15d8f24";
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
