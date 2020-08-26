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
  version = "0.9.81";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "KevinMusgrave";
    repo = pname;
    rev = "cb23328aba64f7f4658374cc2920ef5d56cda5c8";  # no version tag
    sha256 = "0c2dyi4qi7clln43481xq66f6r4fadrz84jphjc5phz97bp33ds8";
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
