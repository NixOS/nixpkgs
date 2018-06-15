{ buildPythonPackage, stdenv, fetchPypi }:

buildPythonPackage rec {
  pname = "face_recognition_models";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kwnv3qpy5bhspk780bkyg8jd9n5f6p91ja6sjlwk1wcm00d56xp";
  };

  # no module named `tests` as no tests are available
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/ageitgey/face_recognition_models;
    license = licenses.cc0;
    maintainers = with maintainers; [ ma27 ];
    description = "Trained models for the face_recognition python library";
  };
}
