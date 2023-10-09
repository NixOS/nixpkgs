{ lib
, accelerate
, buildPythonPackage
, clean-fid
, clip-anytorch
, dctorch
, einops
, fetchFromGitHub
, jsonmerge
, kornia
, pillow
, pythonOlder
, rotary-embedding-torch
, safetensors
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
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "crowsonkb";
    repo = "k-diffusion";
    rev = "refs/tags/v${version}";
    hash = "sha256-jcIA0HfEnVHk9XDXPevGBw81GsXlm1Ztp8ceNirShEA=";
  };

  propagatedBuildInputs = [
    accelerate
    clean-fid
    clip-anytorch
    dctorch
    einops
    jsonmerge
    kornia
    pillow
    rotary-embedding-torch
    scikit-image
    scipy
    safetensors
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
