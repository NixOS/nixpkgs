{
  buildPythonPackage,
  fetchPypi,
  pillow,
  torchvision,
  lib,
}:

buildPythonPackage rec {
  pname = "facenet-pytorch";
  version = "2.5.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mMxbQqSPg3wCPrkvKlcc1KxqRmh8XnG56ZtJEIcnPis=";
  };

  doCheck = false; # pypi version doesn't ship with tests

  pythonImportsCheck = [ "facenet_pytorch" ];

  propagatedBuildInputs = [
    pillow
    torchvision
  ];

  meta = {
    description = "Pretrained Pytorch face detection (MTCNN) and facial recognition (InceptionResnet) models";
    homepage = "https://github.com/timesler/facenet-pytorch";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lucasew ];
  };
}
