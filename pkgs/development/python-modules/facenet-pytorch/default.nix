{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pillow,
  requests,
  torchvision,
}:

buildPythonPackage (finalAttrs: {
  pname = "facenet-pytorch";
  version = "2.5.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "timesler";
    repo = "facenet-pytorch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3YVyqKgVLD5aePwyVQA8kOiqx32kqg9lxU2uwPWGkCU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pillow
    requests
    torchvision
  ];

  pythonImportsCheck = [ "facenet_pytorch" ];

  # The only tests require internet access
  doCheck = false;

  meta = {
    description = "Pretrained Pytorch face detection (MTCNN) and facial recognition (InceptionResnet) models";
    homepage = "https://github.com/timesler/facenet-pytorch";
    changelog = "https://github.com/timesler/facenet-pytorch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
