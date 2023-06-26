{ lib
, buildPythonPackage
, fetchFromGitHub

# dependencies
, accelerate
, clean-fid
, clip-anytorch
, einops
, jsonmerge
, kornia
, pillow
, resize-right
, scikit-image
, scipy
, torch
, torchdiffeq
, torchsde
, torchvision
, tqdm
, wandb

}:

buildPythonPackage rec {
  pname = "k-diffusion";
  version = "0.0.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "crowsonkb";
    repo = "k-diffusion";
    rev = "v${version}";
    hash = "sha256-KKVgk+1hidDBVaRnXjoqwuSRydI10OPHK3YModAizZU=";
  };

  propagatedBuildInputs = [
   accelerate
    clean-fid
    clip-anytorch
    einops
    jsonmerge
    kornia
    pillow
    resize-right
    scikit-image
    scipy
    torch
    torchdiffeq
    torchsde
    torchvision
    tqdm
    wandb
  ];

  pythonImportsCheck = [
    "k_diffusion"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Karras et al. (2022) diffusion models for PyTorch";
    homepage = "https://github.com/crowsonkb/k-diffusion";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
