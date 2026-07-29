{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  setuptools,
  torch,
  torchvision,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "lpips";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "richzhang";
    repo = "PerceptualSimilarity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dIQ9B/HV/2kUnXLXNxAZKHmv/Xv37kl2n6+8IfwIALE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    torch
    torchvision
    tqdm
  ];

  # Tests require network access to download pretrained models.
  doCheck = false;

  pythonImportsCheck = [ "lpips" ];

  meta = {
    description = "Learned Perceptual Image Patch Similarity metric";
    homepage = "https://github.com/richzhang/PerceptualSimilarity";
    changelog = "https://github.com/richzhang/PerceptualSimilarity/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jeffcshelton ];
  };
})
