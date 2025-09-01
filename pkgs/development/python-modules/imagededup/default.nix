{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  fetchurl,
  matplotlib,
  pillow,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pywavelets,
  scikit-learn,
  setuptools,
  torch,
  torchvision,
  tqdm,
  fetchpatch,
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
    url = "https://download.pytorch.org/models/efficientnet_b4_rwightman-23ab8bcd.pth";
    hash = "sha256-I6uLzVvb72GnpDuRrcrYH2Iv1/NvtJNaVpgo13iIxE4=";
  };
in
buildPythonPackage rec {
  pname = "imagededup";
  version = "03.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "idealo";
    repo = "imagededup";
    tag = "v${version}";
    hash = "sha256-tm6WGf74xu3CcwpyeA7+rvO5wemO0daXpj/jvYrH19E=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [
    matplotlib
    pillow
    pywavelets
    scikit-learn
    torch
    torchvision
    tqdm
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)

    # Checks with CNN are preloaded to avoid downloads in the check phase
    mkdir -p $HOME/.cache/torch/hub/checkpoints/
    ln -s ${MobileNetV3} $HOME/.cache/torch/hub/checkpoints/${MobileNetV3.name}
    ln -s ${ViT} $HOME/.cache/torch/hub/checkpoints/${ViT.name}
    ln -s ${EfficientNet} $HOME/.cache/torch/hub/checkpoints/${EfficientNet.name}
  '';

  pythonImportsCheck = [ "imagededup" ];

  patches = [
    # https://github.com/idealo/imagededup/pull/217
    (fetchpatch {
      name = "pytest-warnings-none.patch";
      url = "https://github.com/idealo/imagededup/commit/e2d7a21568e3115acd0632af569549c511ad5c0d.patch";
      hash = "sha256-AQwJpU3Ag6ONRAw0z8so5icW4fRpMHuBOMT5X+HsQ2w=";
    })
  ];

  meta = with lib; {
    homepage = "https://idealo.github.io/imagededup/";
    changelog = "https://github.com/idealo/imagededup/releases/tag/${src.tag}";
    description = "Finding duplicate images made easy";
    license = licenses.asl20;
    maintainers = with maintainers; [ stunkymonkey ];
  };
}
