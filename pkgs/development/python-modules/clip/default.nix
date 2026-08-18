{
  buildPythonPackage,
  fetchFromGitHub,
  ftfy,
  lib,
  regex,
  setuptools,
  torch,
  torchvision,
  tqdm,
}:

buildPythonPackage {
  pname = "clip";
  version = "1.0-unstable-2022-07-27";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "clip";
    rev = "d50d76daa670286dd6cacf3bcd80b5e4823fc8e1";
    hash = "sha256-GAitNBb5CzFVv2+Dky0VqSdrFIpKKtoAoyqeLoDaHO4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ftfy
    regex
    torch
    torchvision
    tqdm
  ];

  pythonImportsCheck = [ "clip" ];

  meta = {
    description = "Contrastive Language-Image Pretraining";
    homepage = "https://github.com/openai/CLIP";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
