{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  numpy,
  pillow,
  requests,
  scipy,
  torch,
  torchvision,
  tqdm,
}:

buildPythonPackage {
  pname = "clean-fid";
  version = "0.1.35";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GaParmar";
    repo = "clean-fid";
    rev = "c8ffa420a3923e8fd87c1e75170de2cf59d2644b";
    hash = "sha256-fqBU/TmCXDTPU3KTP0+VYQoP+HsT2UMcZeLzQHKD9hw=";
  };

  propagatedBuildInputs = [
    numpy
    pillow
    requests
    scipy
    torch
    torchvision
    tqdm
  ];

  pythonImportsCheck = [ "cleanfid" ];

  # no tests1
  doCheck = false;

  meta = with lib; {
    description = "PyTorch - FID calculation with proper image resizing and quantization steps [CVPR 2022]";
    homepage = "https://github.com/GaParmar/clean-fid";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}
