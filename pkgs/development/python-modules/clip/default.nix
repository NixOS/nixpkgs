{ buildPythonPackage
, fetchFromGitHub
, ftfy
, lib
, regex
, torch
, torchvision
, tqdm
}:

buildPythonPackage rec {
  pname = "clip";
  version = "unstable-2022-11-17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "d50d76daa670286dd6cacf3bcd80b5e4823fc8e1";
    hash = "sha256-GAitNBb5CzFVv2+Dky0VqSdrFIpKKtoAoyqeLoDaHO4=";
  };

  propagatedBuildInputs = [
    ftfy
    regex
    torch
    torchvision
    tqdm
  ];

  pythonImportsCheck = [ "clip" ];

  meta = with lib; {
    description = "Contrastive Language-Image Pretraining";
    homepage = "https://github.com/openai/CLIP";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
