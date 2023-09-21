{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchurl
, cython
, torch
, torchvision
, pillow
, tqdm
, scikit-learn
, pywavelets
, matplotlib
, pytestCheckHook
, pytest-mock
}:
let
  MobileNetV3 = fetchurl {
    url = "https://download.pytorch.org/models/mobilenet_v3_small-047dcff4.pth";
    hash = "sha256-BH3P9K3e+G6lvC7/E8lhTcEfR6sRYNCnGiXn25lPTh8=";
  };
  ViT = fetchurl {
    url = "https://download.pytorch.org/models/vit_b_16_swag-9ac1b537.pth";
    hash = "sha256-msG1N42ZJ71sg3TODNVX74Dhs/j7wYWd8zLE3J0P2CU=";
  };
  EfficientNet = fetchurl {
    url = "https://download.pytorch.org/models/efficientnet_b4_rwightman-7eb33cd5.pth";
    hash = "sha256-I6uLzVvb72GnpDuRrcrYH2Iv1/NvtJNaVpgo13iIxE4=";
  };
in
buildPythonPackage rec {
  pname = "imagededup";
  version = "0.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "idealo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B2IuNMTZnzBi6IxrHBoMDsmIcqGQpznd/2f1XKo1Oa4=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    torch
    torchvision
    pillow
    tqdm
    scikit-learn
    pywavelets
    matplotlib
  ];

  nativeCheckInputs = [ pytestCheckHook pytest-mock ];

  preCheck = ''
    # checks fail with: error: [Errno 13] Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)

    # checks with CNN are preloaded to avoid downloads in check-phase
    mkdir -p $HOME/.cache/torch/hub/checkpoints/
    ln -s ${MobileNetV3} $HOME/.cache/torch/hub/checkpoints/${MobileNetV3.name}
    ln -s ${ViT} $HOME/.cache/torch/hub/checkpoints/${ViT.name}
    ln -s ${EfficientNet} $HOME/.cache/torch/hub/checkpoints/${EfficientNet.name}
  '';

  pythonImportsCheck = [ "imagededup" ];

  meta = with lib; {
    homepage = "https://idealo.github.io/imagededup/";
    changelog = "https://github.com/idealo/imagededup/releases/tag/${src.rev}";
    description = "Finding duplicate images made easy";
    license = licenses.asl20;
    maintainers = with maintainers; [ stunkymonkey ];
  };
}
