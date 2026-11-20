{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  graphviz,
  ipywidgets,
  matplotlib,
  ninja,
  notebook,
  numpy,
  opt-einsum,
  pandas,
  pillow,
  pyro-api,
  scikit-learn,
  scipy,
  seaborn,
  setuptools,
  torch,
  torchvision,
  tqdm,
  wget,
  pytest-xdist,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyro-ppl";
  version = "1.9.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "pyro";
    tag = finalAttrs.version;
    hash = "sha256-P33neKtdBoIjKjv8KvoECOtlyaLEyb1spDwyGhPAVHk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    opt-einsum
    pyro-api
    torch
    tqdm
  ];

  optional-dependencies = {
    extras = [
      notebook
      ipywidgets
      graphviz
      matplotlib
      torchvision
      pandas
      pillow
      scikit-learn
      seaborn
      scipy
      wget
    ];
  };

  pythonImportsCheck = [
    "pyro"
    "pyro.distributions"
    "pyro.infer"
    "pyro.optim"
  ];

  # Added for the tests/distributions/test_spanning_tree.py
  preCheck = ''
    export TORCH_EXTENSIONS_DIR=$(mktemp -d)
  '';

  nativeCheckInputs = [
    graphviz
    ninja
    pytest-xdist
    pytestCheckHook
    scipy
  ];

  pytestFlags = [ "--stage=unit" ];

  disabledTests = [
    "test_stable_with_log_prob_param_fit"
  ];

  meta = {
    description = "Library for probabilistic modeling and inference";
    homepage = "http://pyro.ai";
    changelog = "https://github.com/pyro-ppl/pyro/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Filippo-Galli
      georgewhewell
      teh
    ];
  };
})
