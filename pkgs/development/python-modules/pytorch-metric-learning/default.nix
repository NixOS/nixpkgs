{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, numpy
, scikitlearn
, pytorch
, torchvision
, tqdm
}:

buildPythonPackage rec {
  pname   = "pytorch-metric-learning";
  version = "0.9.92";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "KevinMusgrave";
    repo = pname;
    rev = "v${version}";  # no version tag
    sha256 = "085zjbwyl603y863vi9klxa5c29pva8jnmd0wnravajvdl7i22ys";
  };

  propagatedBuildInputs = [
    numpy
    pytorch
    scikitlearn
    torchvision
    tqdm
  ];

  meta = {
    description = "Metric learning library for PyTorch";
    homepage = "https://github.com/KevinMusgrave/pytorch-metric-learning";
    changelog = "https://github.com/KevinMusgrave/pytorch-metric-learning/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
