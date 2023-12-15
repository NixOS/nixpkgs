{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pybind11
, setuptools
, wheel
, numpy
, matplotlib
, pytorch-msssim
, scipy
, torch
, torchvision
, ipywidgets
, jupyter
, plotly
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "compressai";
  version = "1.2.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "InterDigitalInc";
    repo = "CompressAI";
    rev = "refs/tags/v${version}";
    hash = "sha256-nT2vd7t67agIWobJalORbRuns0UJGRGGbTX2/8vbTiY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pybind11
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    matplotlib
    pytorch-msssim
    scipy
    torch
    torchvision
  ];

  passthru.optional-dependencies = {
    tutorials = [
      ipywidgets
      jupyter
    ];
  };

  pythonImportsCheck = [
    "compressai"
    "compressai._CXX"
  ];

  preCheck = ''
    # We have to delete the source because otherwise it is used intead the installed package.
    rm -rf compressai

    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    plotly
    pytestCheckHook
  ];

  disabledTests = [
    # Those tests require internet access to download some weights
    "test_image_codec"
    "test_update"
    "test_eval_model_pretrained"
    "test_cheng2020_anchor"
    "test_pretrained"
  ];

  meta = with lib; {
    description = "A PyTorch library and evaluation platform for end-to-end compression research";
    homepage = "https://github.com/InterDigitalInc/CompressAI";
    license = licenses.bsd3Clear;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
