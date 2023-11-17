{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, cython_3
, setuptools

# dependencies
, basicsr
, facexlib
, lmdb
, numpy
, opencv4
, pyyaml
, scipy
, tensorboard
, torch
, torchvision
, tqdm
, yapf

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gfpgan";
  version = "1.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TencentARC";
    repo = "GFPGAN";
    rev = "v${version}";
    hash = "sha256-frJ3hSniHvCSEPB1awJsXLuUxYRRMbV9GS4GSPKwXOg=";
  };

  patches = [
    ./basicsr-1.4-compat.patch
  ];

  nativeBuildInputs = [
    cython_3
    setuptools
  ];

  propagatedBuildInputs = [
    basicsr
    facexlib
    lmdb
    numpy
    opencv4
    pyyaml
    scipy
    tensorboard
    torch
    torchvision
    tqdm
    yapf
  ];

  pythonImportsCheck = [
    "gfpgan"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Torch not compiled with CUDA enabled
    "test_basicblock"
    "test_bottleneck"
    "test_gfpgan_model"

    # Requires network access
    "test_gfpganer"

    # v2.error: OpenCV(4.7.0) :-1: error: (-5:Bad argument) in function 'imencode'
    "test_ffhq_degradation_dataset"
  ];

  meta = with lib; {
    changelog = "https://github.com/TencentARC/GFPGAN/releases/tag/v${version}";
    description = "GFPGAN aims at developing Practical Algorithms for Real-world Face Restoration";
    homepage = "https://github.com/TencentARC/GFPGAN";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
