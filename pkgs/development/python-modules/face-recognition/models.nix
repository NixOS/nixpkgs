{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "face-recognition-models";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "face_recognition_models";
    inherit version;
    hash = "sha256-t5vSAKiMh8mp1EbJkK5xxaYm0fNzAXTm1XAVf/HYls8=";
  };

  propagatedBuildInputs = [ setuptools ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "face_recognition_models" ];

  meta = with lib; {
    homepage = "https://github.com/ageitgey/face_recognition_models";
    license = licenses.cc0;
    maintainers = with maintainers; [ ];
    description = "Trained models for the face_recognition python library";
  };
}
