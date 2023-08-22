{ lib
, accelerate
, buildPythonPackage
, clean-fid
, clip-anytorch
, einops
, fetchFromGitHub
, jsonmerge
, kornia
, pillow
, pythonOlder
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
  version = "0.0.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "crowsonkb";
    repo = "k-diffusion";
    rev = "refs/tags/v${version}";
    hash = "sha256-tOWDFt0/hGZF5HENiHPb9a2pBlXdSvDvCNTsCMZljC4=";
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
