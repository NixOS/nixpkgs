{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pybind11,
  setuptools,

  # dependencies
  einops,
  numpy,
  matplotlib,
  pandas,
  pytorch-msssim,
  scipy,
  torch,
  torch-geometric,
  torchvision,

  # optional-dependencies
  ipywidgets,
  jupyter,

  # tests
  plotly,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "compressai";
  version = "1.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "InterDigitalInc";
    repo = "CompressAI";
    rev = "refs/tags/v${version}";
    hash = "sha256-xvzhhLn0iBzq3h1nro8/83QWEQe9K4zRa3RSZk+hy3Y=";
    fetchSubmodules = true;
  };

  build-system = [
    pybind11
    setuptools
  ];

  dependencies = [
    einops
    numpy
    matplotlib
    pandas
    pytorch-msssim
    scipy
    torch
    torch-geometric
    torchvision
  ];

  optional-dependencies = {
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

  meta = {
    description = "PyTorch library and evaluation platform for end-to-end compression research";
    homepage = "https://github.com/InterDigitalInc/CompressAI";
    license = lib.licenses.bsd3Clear;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
