{ lib
, buildPythonPackage
, fetchPypi
, opencv3
}:

buildPythonPackage rec {
  version = "0.5.4";
  pname = "imutils";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03827a9fca8b5c540305c0844a62591cf35a0caec199cb0f2f0a4a0fb15d8f24";
  };

  propagatedBuildInputs = [ opencv3 ];

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
    description = "A series of convenience functions to make basic image processing functions";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
