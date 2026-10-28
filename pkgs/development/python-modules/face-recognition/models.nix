{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "face-recognition-models";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "face_recognition_models";
    inherit (finalAttrs) version;
    hash = "sha256-t5vSAKiMh8mp1EbJkK5xxaYm0fNzAXTm1XAVf/HYls8=";
  };

  patches = [
    # Replace deprecated pkg_resources with importlib.resources
    # https://github.com/ageitgey/face_recognition_models/pull/24
    ./0001-use-importlib-resources.patch
  ];

  build-system = [ setuptools ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "face_recognition_models" ];

  meta = {
    homepage = "https://github.com/ageitgey/face_recognition_models";
    license = lib.licenses.cc0;
    maintainers = [ ];
    description = "Trained models for the face_recognition python library";
  };
})
